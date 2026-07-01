-- Customize None-ls sources

---@type LazySpec
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	opts = function(_, config)
		-- opts variable is the default configuration table for the setup function call
		-- local null_ls = require "null-ls"

		-- Check supported formatters and linters
		-- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		-- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

		-- Only insert new sources, do not replace the existing ones
		-- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
		--
		--
		local null_ls = require("null-ls")
		local diagnostics = null_ls.builtins.diagnostics
		local formatting = null_ls.builtins.formatting
		local completion = null_ls.builtins.completion

		local file_exists = function(file)
			local f = io.open(file, "r")
			if f ~= nil then
				io.close(f)
				return true
			else
				return false
			end
		end

		config.sources = require("astrocore").list_insert_unique(config.sources, {
			-- Set a formatter
			formatting.stylua,
			formatting.prettierd,
			formatting.phpcbf,
			completion.spell,
			formatting.phpcsfixer.with({
				args = {
					"--standard=PSR12",
					"--config",
					"phpcs.xml.dist",
				},
				filetypes = { "php" },
				condition = function(utils)
					return utils.root_has_file("phpcs.xml.dist")
				end,
			}),
			formatting.prettierd.with({
				extra_filetypes = { "toml", "ts", "js", "svelte", "typescript", "jsonc", "ini", "conf" },
				env = {
					PRETTIERD_DEFAULT_CONFIG = function()
						local globalFile = vim.fn.expand("~/.config/nvim/lua/plugins/conf/prettier-config/index.json")
						local localFile = vim.fs.joinpath(vim.loop.cwd(), ".prettierrc.json")
						if file_exists(localFile) then
							return localFile
						else
							return globalFile
						end
					end,
				},
			}),
			require("none-ls.diagnostics.eslint_d").with({
				extra_args = function(params)
					local file_types = { "js", "cjs", "yaml", "yml", "json" }
					for _, file_type in pairs(file_types) do
						if file_exists(params.root .. "/.eslintrc." .. file_type) then
							return {}
						end
					end
					return {
						"--config",
						"~/.config/nvim/lua/plugins/conf/eslint-config-tao/index.js",
					}
				end,
			}),
		})
	end,
}
