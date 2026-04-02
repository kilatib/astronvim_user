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

-- CodeCompanion schedules vim.treesitter.start() on the chat buffer; disable highlight-only
-- attachment to avoid nvim 0.12 decoration / markdown query edge cases (parser stays active).
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "codecompanion", "codecompanion_input" },
	callback = function(ev)
		vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(ev.buf) then
				pcall(vim.treesitter.stop, ev.buf)
			end
		end, 100)
	end,
})

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
