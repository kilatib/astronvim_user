-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function(plugin, opts)
		require("astronvim.plugins.configs.nvim-treesitter")(plugin, opts)
		require("custom.treesitter_query_fix")
	end,
	opts = function(_, opts)
		-- codecompanion maps to markdown Tree-sitter; nvim 0.12 highlighter can error on that
		-- buffer layout. Skip TS highlight there; parsers/extmarks still work.
		opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
			disable = function(_, bufnr)
				local ft = vim.bo[bufnr].filetype
				return ft == "codecompanion" or ft == "codecompanion_input"
			end,
		})
		opts.ensure_installed = {
			"lua",
			"vim",
			"vimdoc",
			"bash",
			"cmake",
			"json",
			"jsonnet",
			"typescript",
			"javascript",
			"yaml",
			"xml",
			"php",
			"phpdoc",
			"svelte",
			"xml",
			"http",
			"json",
			"graphql",
			"ini",
			"jsonc",
			"css",
			"html",
			"latex",
			"norg",
			"scss",
			"typst",
			"vue",
			"regex",
		}
		return opts
	end,
}
