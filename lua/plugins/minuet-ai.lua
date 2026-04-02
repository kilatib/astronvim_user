return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local ollama_env = require("plugins.ollama_env")
		local host = ollama_env.ollama_light_base()

		return {
			provider = "openai_fim_compatible",
			n_completions = 1,
			context_window = 8192,

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
					name = "Ollama",
					end_point = host .. "/v1/completions",
					api_key = "TERM",
					model = os.getenv("MINUET_OLLAMA_MODEL") or "qwen2.5-coder:7b",
					optional = {
						max_tokens = 256,
						temperature = 0,
						top_p = 0.9,
					},
				},
			},
			-- Slightly higher throttle avoids hammering Ollama when typing fast on CPU-bound hosts.
			throttle = 650,
		}
	end,
}
