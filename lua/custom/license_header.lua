-- ~/.config/nvim/lua/custom/license_header.lua

local M = {}

local header_lines = {
  "// SPDX-FileCopyrightText: 2023-2026 Open Assessment Technologies S.A.",
  "// Copyright (C) 2024 (original work) Open Assessment Technologies SA ;",
  "//",
  "// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-TAO-Commercial-License",
  "",
}

local function get_header_lines(copyright_line)
  local lines = vim.deepcopy(header_lines)
  if copyright_line then
    lines[1] = copyright_line
  end
  return lines
end

local function find_copyright_line(lines)
  for _, line in ipairs(lines) do
    if line:find("^// SPDX%-FileCopyrightText:") then
      return line
    end
  end
end

local function find_existing_headers(lines)
  local headers = {}
  local max_lines = math.min(#lines, 30)
  local i = 1

  while i <= max_lines do
    if lines[i]:find("^// SPDX%-FileCopyrightText:") then
      local end_idx = math.min(i + 4, max_lines)

      for j = i, math.min(#lines, i + 10) do
        if lines[j]:find("^// SPDX%-License%-Identifier:") then
          end_idx = j
          break
        end
      end

      if lines[end_idx + 1] == "" then
        end_idx = end_idx + 1
      end

      table.insert(headers, { start_idx = i, end_idx = end_idx })
      i = end_idx + 1
    else
      i = i + 1
    end
  end

  return headers
end

local function find_insertion_index(lines)
  for i = 1, math.min(#lines, 30) do
    if lines[i]:find("^<%?php") then
      return i
    end
  end

  return 0
end

local function remove_headers(buf, headers)
  for i = #headers, 1, -1 do
    local header = headers[i]
    vim.api.nvim_buf_set_lines(buf, header.start_idx - 1, header.end_idx, false, {})
  end
end

local function remove_blank_lines_at(buf, index)
  while vim.api.nvim_buf_get_lines(buf, index, index + 1, false)[1] == "" do
    vim.api.nvim_buf_set_lines(buf, index, index + 1, false, {})
  end
end

local function find_existing_header(lines)
  local max_lines = math.min(#lines, 30)
  local start_idx = nil

  for i = 1, max_lines do
    if lines[i] ~= "" then
      start_idx = i
      break
    end
  end

  if not start_idx then
    return nil
  end

  local first_line = lines[start_idx]

  if first_line:find("^// SPDX%-FileCopyrightText:") then
    for i = start_idx, math.min(#lines, start_idx + 10) do
      if lines[i]:find("^// SPDX%-License%-Identifier:") then
        local end_idx = i
        if lines[end_idx + 1] == "" then
          end_idx = end_idx + 1
        end
        return start_idx, end_idx
      end
    end

    return start_idx, math.min(start_idx + 4, max_lines)
  end

  if first_line:find("^/%*%*") then
    for i = start_idx + 1, max_lines do
      if lines[i]:find("^ ?%*/$") then
        local end_idx = i
        if lines[end_idx + 1] == "" then
          end_idx = end_idx + 1
        end
        return start_idx, end_idx
      end
    end
  end

  return nil
end

function M.update_or_add_license_header()
  local buf = vim.api.nvim_get_current_buf()
  local all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local headers = find_existing_headers(all_lines)
  local start_idx, end_idx = find_existing_header(all_lines)
  -- Preserve the copyright period already declared by the file. A formatter
  -- must not replace an established initial year with the template's year.
  local replacement = get_header_lines(find_copyright_line(all_lines))

  if #headers > 0 then
    remove_headers(buf, headers)
    all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local insertion_index = find_insertion_index(all_lines)
    remove_blank_lines_at(buf, insertion_index)
    vim.api.nvim_buf_set_lines(buf, insertion_index, insertion_index, false, replacement)
    return
  end

  if start_idx and end_idx then
    vim.api.nvim_buf_set_lines(buf, start_idx - 1, end_idx, false, replacement)
    return
  end

  if #all_lines > 0 and not (#all_lines == 1 and all_lines[1] == "") then
    local insertion_index = find_insertion_index(all_lines)
    remove_blank_lines_at(buf, insertion_index)
    vim.api.nvim_buf_set_lines(buf, insertion_index, insertion_index, false, replacement)
  end
end

local group = vim.api.nvim_create_augroup("AutoLicenseHeader", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "php" },
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.js", "*.ts", "*.php" },
  group = group,
  callback = function()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, get_header_lines())
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.php" },
  group = group,
  callback = M.update_or_add_license_header,
})

vim.api.nvim_create_user_command("AddLicense", M.update_or_add_license_header, {})

return M
