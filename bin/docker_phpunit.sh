#!/usr/bin/env bash

set -euo pipefail

readonly CONTAINER_RESULTS_PATH="/tmp/phpunit-result.xml"
readonly DEFAULT_REMOTE_PHPUNIT_BIN="${REMOTE_PHPUNIT_BIN:-bin/phpunit}"

find_project_root() {
  local input_path dir
  input_path="$1"
  if [ -d "$input_path" ]; then
    dir="$input_path"
  else
    dir=$(dirname "$input_path")
  fi

  while [ "$dir" != "/" ]; do
    if [ -f "$dir/composer.json" ]; then
      printf "%s\n" "$dir"
      return 0
    fi
    dir=$(dirname "$dir")
  done

  return 1
}

find_repo_root() {
  local dir
  dir="$1"

  while [ "$dir" != "/" ]; do
    if [ -d "$dir/.git" ]; then
      printf "%s\n" "$dir"
      return 0
    fi
    dir=$(dirname "$dir")
  done

  return 1
}

project_to_container_name() {
  local project_root repo_root rel_path candidate
  project_root="$1"

  if ! repo_root=$(find_repo_root "$project_root" 2>/dev/null); then
    return 1
  fi

  rel_path=${project_root#"$repo_root"/}
  rel_path=${rel_path//\/apps\//\/}
  candidate=${rel_path//\//_}
  candidate=${candidate//-/_}
  printf "nextgen_%s\n" "$candidate"
}

find_container_for_project() {
  local project_root name destination candidate working_dir
  project_root="$1"

  while IFS= read -r name; do
    [ -n "$name" ] || continue
    destination=$(docker inspect -f "{{range .Mounts}}{{if eq .Source \"$project_root\"}}{{println .Destination}}{{end}}{{end}}" "$name" 2>/dev/null | tr -d "\r")
    if [ -n "$destination" ]; then
      printf "%s|%s\n" "$name" "$destination"
      return 0
    fi
  done < <(docker ps --format "{{.Names}}")

  if candidate=$(project_to_container_name "$project_root" 2>/dev/null); then
    if docker inspect "$candidate" >/dev/null 2>&1; then
      working_dir=$(docker inspect -f '{{.Config.WorkingDir}}' "$candidate" 2>/dev/null | tr -d '\r')
      if [ -n "$working_dir" ]; then
        printf "%s|%s\n" "$candidate" "$working_dir"
        return 0
      fi
    fi
  fi

  return 1
}

find_remote_phpunit() {
  local container
  container="$1"
  docker exec "$container" sh -lc '
    for candidate in "$REMOTE_PHPUNIT_BIN" vendor/bin/phpunit vendor/bin/simple-phpunit bin/phpunit; do
      if [ -z "$candidate" ] || [ ! -f "$candidate" ]; then
        continue
      fi

      if [ "$candidate" = "bin/phpunit" ] \
        && grep -q "vendor/symfony/phpunit-bridge/bin/simple-phpunit.php" "$candidate" 2>/dev/null \
        && [ ! -f vendor/symfony/phpunit-bridge/bin/simple-phpunit.php ]; then
        continue
      fi

      printf "%s\n" "$candidate"
      exit 0
    done
    exit 1
  ' 2>/dev/null
}

find_local_phpunit() {
  local cached_phpunit

  if [ -x vendor/bin/phpunit ]; then
    printf "%s\n" "vendor/bin/phpunit"
    return 0
  fi

  if [ -x vendor/bin/.phpunit/phpunit/phpunit ]; then
    printf "%s\n" "vendor/bin/.phpunit/phpunit/phpunit"
    return 0
  fi

  cached_phpunit=$(find vendor/bin/.phpunit -maxdepth 2 -type f -name phpunit 2>/dev/null | sort -r | head -n 1 || true)
  if [ -n "$cached_phpunit" ]; then
    printf "%s\n" "$cached_phpunit"
    return 0
  fi

  if [ -x vendor/bin/simple-phpunit ]; then
    printf "%s\n" "vendor/bin/simple-phpunit"
    return 0
  fi

  if [ -x bin/phpunit ]; then
    printf "%s\n" "bin/phpunit"
    return 0
  fi

  return 1
}

run_local_phpunit() {
  local phpunit_bin
  phpunit_bin=$(find_local_phpunit || true)
  if [ -z "$phpunit_bin" ]; then
    phpunit_bin="$DEFAULT_REMOTE_PHPUNIT_BIN"
  fi

  if [[ "$phpunit_bin" == "vendor/bin/simple-phpunit" ]]; then
    exec env COMPOSER_DISABLE_NETWORK=1 SYMFONY_DEPRECATIONS_HELPER=weak php -d memory_limit=-1 -d xdebug.idekey=deliver-be "$phpunit_bin" "$@"
  fi

  exec env SYMFONY_DEPRECATIONS_HELPER=weak php -d memory_limit=-1 -d xdebug.idekey=deliver-be "$phpunit_bin" "$@"
}

if [ "$#" -eq 0 ]; then
  run_local_phpunit
fi

first_arg="$1"
if ! project_root=$(find_project_root "$first_arg" 2>/dev/null); then
  run_local_phpunit "$@"
fi

cd "$project_root"

if ! container_info=$(find_container_for_project "$project_root" 2>/dev/null); then
  run_local_phpunit "$@"
fi

container_name=${container_info%%|*}
container_root=${container_info#*|}
remote_phpunit=$(REMOTE_PHPUNIT_BIN="$DEFAULT_REMOTE_PHPUNIT_BIN" find_remote_phpunit "$container_name" || true)

if [ -z "$remote_phpunit" ]; then
  run_local_phpunit "$@"
fi

output_path=""
remote_args=()
for arg in "$@"; do
  case "$arg" in
    --log-junit=*)
      output_path=${arg#*=}
      ;;
    "$project_root"/*)
      relative_path=${arg#"$project_root"/}
      remote_args+=("$container_root/$relative_path")
      ;;
    *)
      remote_args+=("$arg")
      ;;
  esac
done

escaped_args=()
for arg in "${remote_args[@]}"; do
  escaped_args+=("$(printf "%q" "$arg")")
done

container_command=$(printf 'php -d memory_limit=-1 -d xdebug.idekey=deliver-be %q' "$remote_phpunit")
if [ "${#escaped_args[@]}" -gt 0 ]; then
  container_command+=" ${escaped_args[*]}"
fi
container_command+=" --log-junit=$(printf "%q" "$CONTAINER_RESULTS_PATH")"

container_status=0
if ! docker exec "$container_name" sh -lc "cd $(printf "%q" "$container_root") && SYMFONY_DEPRECATIONS_HELPER=weak $container_command"; then
  container_status=$?
fi

if [ -n "$output_path" ]; then
  docker cp "$container_name:$CONTAINER_RESULTS_PATH" "$output_path" >/dev/null 2>&1 || true
  if [ -f "$output_path" ]; then
    python3 - "$output_path" "$container_root" "$project_root" <<'INNER'
from pathlib import Path
import sys
path = Path(sys.argv[1])
path.write_text(path.read_text().replace(sys.argv[2], sys.argv[3]))
INNER
  fi
fi

exit "$container_status"
