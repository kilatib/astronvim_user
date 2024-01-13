#!/bin/sh

# Customize the following:
phpunitPath=$REMOTE_PHPUNIT_BIN

# detect local path and remove from args
argsInput=${@}
runFile=$(echo $argsInput| awk '{print $1}')
phpTestPath=$(dirname "$runFile")
pushd $phpTestPath > /dev/null
projectPath="$(git rev-parse --show-toplevel)"
pushd > /dev/null

containerName=$(sed 's#.*/##' <<< $projectPath | sed s/-/_/g)
containerName=nextgen_$(sed 's#-#_#' <<< $containerName)

## detect test result output
for i in $argsInput; do
    case $i in
        --log-junit=*)
            outputPath="${i#*=}"
            ;;
        *)
            ;;
    esac
done

# replace with local
args=("${@/$projectPath\//}")

# Detect path
container=$(docker ps -n=-1 --filter name=$containerName --format="{{.ID}}")
dockerPath=$(docker inspect --format {{.Config.WorkingDir}} $container)

## debug
# echo "Params: "${args[@]}
# echo "Docker: "$dockerPath
# echo "Local:  "$projectPath
# echo "Result: "$outputPath

# Run the tests
docker exec -it $container /bin/sh -c "php -d memory_limit=-1 -d xdebug.idekey=deliver-be $phpunitPath ${args[@]}"

# copy results
docker cp -a "$container:$outputPath" "$outputPath"|- &> /dev/null

# replace docker path to locals
echo $dockerPath
sed -i '_' "s#$dockerPath#$projectPath#g" $outputPath
