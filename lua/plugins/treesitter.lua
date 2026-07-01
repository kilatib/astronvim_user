-- Customize Treesitter
-- --------------------
-- AstroNvim v6 configures treesitter through AstroCore.
-- The CodeCompanion buffer workaround remains in `lua/polish.lua`.

---@type LazySpec
return {
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = {
			treesitter = {
				highlight = true,
				indent = true,
				auto_install = true,
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"bash",
					"cmake",
					"css",
					"gitignore",
					"graphql",
					"html",
					"http",
					"ini",
					"javascript",
					"json",
					"jsonnet",
					"latex",
					"php",
					"phpdoc",
					"regex",
					"scss",
					"svelte",
					"typst",
					"typescript",
					"vue",
					"xml",
					"yaml",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			require("astrocore").on_load("nvim-treesitter", function()
				pcall(require, "nvim-treesitter.query_predicates")
				require("custom.treesitter_query_fix")
			end)
		end,
	},
}
