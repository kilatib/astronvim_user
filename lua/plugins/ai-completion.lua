return {
	-- 1. Minuet AI Configuration
	{
		"milanglacier/minuet-ai.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			local ai_provider = os.getenv("AI_PROVIDER") or "ollama"

			local endpoint
			local model
			local api_key_value

			if ai_provider == "openai" then
				endpoint = "https://api.openai.com/v1/completions"
				model = os.getenv("OPENAI_MODEL") or "gpt-3.5-turbo-instruct"

				api_key_value = function()
					local key_file = os.getenv("HOME") .. "/.openai_api_key"
					local file = io.open(key_file, "r")
					if file then
						local key = file:read("*a"):gsub("%s+", "")
						file:close()
						return key
					end

					local env_key = os.getenv("OPENAI_API_KEY")
					if env_key and env_key ~= "" then
						return env_key
					end

					return "MISSING_KEY"
				end
			else
				local host = os.getenv("OLLAMA_ENDPOINT") or "http://localhost:11434"
				host = host:gsub("/$", "")
				endpoint = host .. "/v1/completions"

				model = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:1.5b"

				api_key_value = "TERM"
			end

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
						name = ai_provider,
						end_point = endpoint,
						model = model,

						api_key = api_key_value,

						optional = {
							max_tokens = 256,
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
