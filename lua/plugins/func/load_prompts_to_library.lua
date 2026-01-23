return {
	load_prompts_to_library = function()
		local paths = {
			vim.fn.expand("~/src/awesome-copilot/prompts"),
		}
		local lib = {}
		local scandir = require("plenary.scandir")
		local count = 0

		for _, dir in ipairs(paths) do
			if vim.fn.isdirectory(dir) == 1 then
				local files = scandir.scan_dir(dir, { depth = 1, search_pattern = "%.md$" })
				for _, filepath in ipairs(files) do
					local name = vim.fn.fnamemodify(filepath, ":t:r"):gsub("%.prompt$", "")
					local content = table.concat(vim.fn.readfile(filepath), "\n")

					if content and content ~= "" then
						lib["Custom: " .. name] = {
							strategy = "chat",
							description = "File: " .. name,
							prompts = {
								{
									role = "user",
									content = content,
									opts = { contains_code = true, visible = true },
								},
							},
						}
						count = count + 1
					end
				end
			end
		end

		vim.schedule(function()
			if count > 0 then
				vim.notify("✅ CodeCompanion: Loaded " .. count .. " prompts into Library.", vim.log.levels.INFO)
			end
		end)
		return lib
	end,
}
