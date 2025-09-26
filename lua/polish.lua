vim.opt.swapfile = false
vim.opt.spelloptions = "camel"
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.api.nvim_set_hl(
	0, -- global highlight group
	"SpellBad",
	{ fg = "red", underline = true }
)

-- Set up custom filetypes
vim.filetype.add({
	extension = {
		foo = "fooscript",
	},
	filename = {
		["Foofile"] = "fooscript",
	},
	pattern = {
		["~/%.config/foo/.*"] = "fooscript",
	},
})

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
