-- ~/.config/nvim/lua/custom/license_header.lua

local M = {}

local license_template = [[
/**
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; under version 2
 * of the License (non-upgradable).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * 31 Milk St # 960789 Boston, MA 02196 USA.
 *
 * Copyright (c) {date} (original work) Open Assessment Technologies SA ;
 */
]]

function M.update_or_add_license_header()
	local buf = vim.api.nvim_get_current_buf()
	local current_year = os.date("%Y")
	local header_found = false
	local all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	for i, line in ipairs(all_lines) do
		if i > 30 then
			break
		end

		if line:find("Foundation, Inc., 51 Franklin Street") then
			local new_address_line = " * 31 Milk St # 960789 Boston, MA 02196 USA."
			vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { new_address_line })
		end

		if line:find("Copyright %(c%)") then
			header_found = true
			local new_copyright_line = line

			local start_year, end_year = line:match("Copyright %(c%) (%d%d%d%d)%s*-%s*(%d%d%d%d)")

			if start_year and end_year then
				if tonumber(current_year) > tonumber(end_year) then
					local old_range = start_year .. "%s*-%s*" .. end_year
					local new_range = start_year .. " - " .. current_year
					new_copyright_line = line:gsub(old_range, new_range)
				end
			else
				local single_year = line:match("Copyright %(c%) (%d%d%d%d)")
				if single_year then
					if tonumber(current_year) > tonumber(single_year) then
						local new_range = single_year .. "-" .. current_year
						new_copyright_line = line:gsub(single_year, new_range)
					end
				end
			end

			if new_copyright_line ~= line then
				vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { new_copyright_line })
			end

			break
		end
	end

	if not header_found and #all_lines > 0 and not (#all_lines == 1 and all_lines[1] == "") then
		local final_license_text = license_template:gsub("{date}", current_year)
		local license_lines = vim.split(final_license_text, "\n")
		vim.api.nvim_buf_set_lines(buf, 0, 0, false, license_lines)
	end
end

local group = vim.api.nvim_create_augroup("AutoLicenseHeader", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = { "*.js", "*.ts", "*.php" },
	group = group,
	callback = function()
		local current_year = os.date("%Y")
		local final_license_text = license_template:gsub("{date}", current_year)
		local license_lines = vim.split(final_license_text, "\n")
		vim.api.nvim_buf_set_lines(0, 0, 0, false, license_lines)
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.ts", "*.php" },
	group = group,
	callback = M.update_or_add_license_header,
})

vim.api.nvim_create_user_command("AddLicense", M.update_or_add_license_header, {})

return M
