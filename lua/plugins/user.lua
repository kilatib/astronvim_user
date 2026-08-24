---@type LazySpec
return {
	{ "andweeb/presence.nvim", event = "VeryLazy" },
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_signature").setup()
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					header = table.concat({
						"   ██████╗  █████╗ ████████╗",
						"  ██╔═══██╗██╔══██╗╚══██╔══╝",
						"██║   ██║███████║   ██║",
						"██║   ██║██╔══██║   ██║",
						"╚██████╔╝██║  ██║   ██║",
						" ╚═════╝ ╚═╝  ╚═╝   ╚═╝",
					}, "\n"),
				},
			},
			input = { enabled = true },
			notifier = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
		},
		config = function(_, opts)
			local snacks = require("snacks")
			snacks.setup(opts)
			snacks.input.enable()
			snacks.picker.setup()
		end,
	},
	{ "max397574/better-escape.nvim", enabled = false },
	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require("luasnip")
			luasnip.filetype_extend("javascript", { "javascriptreact" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom autopairs configuration such as custom rules
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			npairs.add_rules(
				{
					Rule("$", "$", { "tex", "latex" })
						:with_pair(cond.not_after_regex("%%"))
						:with_pair(cond.not_before_regex("xxx", 3))
						:with_move(cond.none())
						:with_del(cond.not_after_regex("xx"))
						:with_cr(cond.none()),
				},
				Rule("a", "a", "-vim")
			)
		end,
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			transparent = true,
		},
	},
}
