local M = {}

local function system(cmd)
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return output[1]
end

local function get_repo_context()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil, "Current buffer has no file on disk"
  end

  local root = system({ "git", "rev-parse", "--show-toplevel" })
  if not root then
    return nil, "Not inside a git repository"
  end

  local prefix = root .. "/"
  if file:sub(1, #prefix) ~= prefix then
    return nil, "Current file is outside the repository root"
  end

  local remote = system({ "git", "remote", "get-url", "origin" })
  if not remote then
    return nil, "Git remote 'origin' is not configured"
  end

  local sha = system({ "git", "rev-parse", "HEAD" })
  if not sha then
    return nil, "Unable to resolve HEAD"
  end

  local host, repo = remote:match("^git@([^:]+):(.+)$")
  if not host then
    host, repo = remote:match("^https?://([^/]+)/(.+)$")
  end
  if not host then
    host, repo = remote:match("^ssh://git@([^/]+)/(.+)$")
  end
  if not host or not repo then
    return nil, "Unsupported git remote URL format"
  end

  repo = repo:gsub("%.git$", "")

  return {
    file = file,
    relpath = file:sub(#prefix + 1),
    host = host,
    repo = repo,
    sha = sha,
  }
end

local function open_url(url)
  if vim.ui.open then
    vim.ui.open(url)
    return
  end

  local opener = vim.fn.has("mac") == 1 and "open" or "xdg-open"
  vim.fn.jobstart({ opener, url }, { detach = true })
end

local function build_url(start_line, end_line)
  local ctx, err = get_repo_context()
  if not ctx then
    vim.notify(err, vim.log.levels.ERROR)
    return nil
  end

  local relpath = vim.uri_encode(ctx.relpath):gsub("%%2F", "/")
  local url = string.format("https://%s/%s/blob/%s/%s", ctx.host, ctx.repo, ctx.sha, relpath)

  if start_line and end_line then
    if start_line == end_line then
      url = string.format("%s#L%d", url, start_line)
    else
      url = string.format("%s#L%d-L%d", url, start_line, end_line)
    end
  end

  return url
end

function M.open_current_line()
  local url = build_url(vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1])
  if url then
    open_url(url)
  end
end

function M.open_visual_selection()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local url = build_url(start_line, end_line)
  if url then
    open_url(url)
  end
end

return M
