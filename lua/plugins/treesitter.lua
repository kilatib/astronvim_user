-- Customize Treesitter

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
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
		},
	},
}
