return {
	{
		"AstroNvim/astrocore",
		---@type AstroCoreOpts
		opts = {
			mappings = {
				-- first key is the mode
				n = {
					["<leader>lF"] = {
						function()
							require("conform").format({ async = true, lsp_fallback = false })
						end,
						desc = "Format selection",
					}, -- change description but the same command
					["<leader>gf"] = { ":Browsher commit<cr>", desc = "Open file on github" }, -- change description but the same command
					-- tables with the `name` key will be registered with which-key if it's installed
					-- this is useful for naming menus
					["<leader>T"] = { name = "Unit Tests" },
					["<leader>Tl"] = {
						desc = "List",
						function()
							require("neotest").summary.open()
						end,
					},
					["<leader>Tr"] = {
						desc = "Run last",
						function()
							require("neotest").run.run_last()
						end,
					},
					["<leader>Tf"] = {
						desc = "Run current file",
						function()
							require("neotest").run.run(vim.fn.expand("%"))
						end,
					},
					["<leader>Tm"] = {
						desc = "Run marked",
						function()
							require("neotest").summary.run_marked()
						end,
					},
					["<leader>Tn"] = {
						desc = "Run nearest test",
						function()
							require("neotest").run.run()
						end,
					},
					["<leader>Td"] = {
						desc = "Run with debug",
						function()
							require("neotest").run.run({ strategy = "dap" })
						end,
					},
					["<leader>k"] = {
						desc = "Toggle LazyDocker",
						"<cmd>LazyDocker<CR>",
					},
				},
				t = {},
				v = {
					["<leader>lj"] = {
						desc = "Format select JSON",
						":'<,'>!python3 -m json.tool<cr>",
					},
					["<leader>gf"] = { ":'<,'>Browsher commit<CR>gv", desc = "Open file on github" }, -- change description but the same command
				},
				i = {
					["<leader><CR>"] = {
						desc = "Apply copilot suggestions",
						'copilot#Accept("<CR>")',
					},
				},
			},
		},
	},
}
