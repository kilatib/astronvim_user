return {
	-- 1. Minuet AI Configuration
	{
		"milanglacier/minuet-ai.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			return {
				provider = "openai_fim_compatible",
				n_completions = 1,
				context_window = 4096,

				virtualtext = {
					auto_trigger_ft = { "*" },
					keymap = {
						accept = "<A-y>",
						accept_line = false,
						prev = "<A-[>",
						next = "<A-]>",
						dismiss = "<A-e>",
					},
				},

				provider_options = {
					openai_fim_compatible = {
						-- FIX: Use a function to return the key directly.
						-- This bypasses the "environment variable" requirement.
						api_key = function()
							-- OPTION A: Hardcode for testing (Uncomment and paste key to test immediately)
							-- return "sk-proj-YOUR_ACTUAL_KEY_HERE"

							-- OPTION B: Best Practice (Read from a file)
							-- 1. Run in terminal: echo "sk-proj-..." > ~/.openai_api_key
							-- 2. This code reads it automatically:
							local key_file = os.getenv("HOME") .. "/.openai_api_key"
							local file = io.open(key_file, "r")
							if file then
								local key = file:read("*a"):gsub("%s+", "") -- Remove whitespace/newlines
								file:close()
								return key
							end

							-- OPTION C: Fallback to env var (only works in Terminal)
							return os.getenv("OPENAI_API_KEY") or ""
						end,

						name = "OpenAI",
						end_point = "https://api.openai.com/v1/completions",
						model = "gpt-3.5-turbo-instruct",

						optional = {
							max_tokens = 256,
							top_p = 0.9,
							temperature = 0.2,
						},

						template = {
							prompt = function(before, after)
								return before or ""
							end,
							suffix = function(before, after)
								return after or ""
							end,
						},
					},
				},
				throttle = 1000,
			}
		end,
		config = function(_, opts)
			require("minuet").setup(opts)
		end,
	},

	-- 2. AstroCore (Safe Keymapping)
	{
		"AstroNvim/astrocore",
		opts = {
			options = {
				g = {
					ai_accept = function()
						local status, minuet_vt = pcall(require, "minuet.virtualtext")
						if status and minuet_vt.action.is_visible() then
							minuet_vt.action.accept()
							return true
						end
					end,
				},
			},
		},
	},

	-- 3. Blink CMP Integration
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
				score_offset = 8,
				async = true,
			}
			return opts
		end,
	},
}
