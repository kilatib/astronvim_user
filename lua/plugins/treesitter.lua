-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"lua",
			"vim",
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

			-- add more arguments for adding more treesitter parsers
		},
	},
}
