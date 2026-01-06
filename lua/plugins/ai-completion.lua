return {
	{
		"milanglacier/minuet-ai.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			provider = "openai_fim_compatible",

			n_completions = 1,
			context_window = 4096,

			virtualtext = {
				auto_trigger_ft = { "*" },
				keymap = {
					accept = false,
					accept_line = false,
					prev = false,
					next = false,
					dismiss = false,
				},
			},

			provider_options = {
				openai_fim_compatible = {
					api_key = "TERM",
					name = "Ollama",
					end_point = "http://localhost:11434/v1/completions",
					model = "qwen2.5-coder:1.5b",

					optional = {
						max_tokens = 64,
						top_p = 0.9,
					},

					template = {
						prompt = function(before, after)
							return before
						end,
						suffix = function(before, after)
							return after
						end,
					},
				},
			},

			throttle = 1000,
		},
	},

	{
		"AstroNvim/astrocore",
		opts = {
			options = {
				g = {
					ai_accept = function()
						if require("minuet.virtualtext").action.is_visible() then
							require("minuet.virtualtext").action.accept()
							return true
						end
					end,
				},
			},
		},
	},

	{
		"saghen/blink.cmp",
		dependencies = { "milanglacier/minuet-ai.nvim" },
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			opts.sources.default = opts.sources.default or {}
			opts.sources.providers = opts.sources.providers or {}

			if not vim.tbl_contains(opts.sources.default, "minuet") then
				table.insert(opts.sources.default, "minuet")
			end

			opts.sources.providers.minuet = {
				name = "minuet",
				module = "minuet.blink",
				score_offset = 100,
				async = true,
			}

			return opts
		end,
	},
}
