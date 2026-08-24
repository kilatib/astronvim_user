return {
	"milanglacier/minuet-ai.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		return {
			-- OPENAI_API_KEY is read from the environment; never store the key in this file.
			provider = "openai",
			n_completions = 1,
			context_window = 8192,

			virtualtext = {
				auto_trigger_ft = { "*" },
				show_on_completion_menu = true,
				keymap = {
					accept = "<A-y>",
					accept_line = false,
					prev = "<A-[>",
					next = "<A-]>",
					dismiss = "<A-e>",
				},
			},

			provider_options = {
				openai = {
					model = os.getenv("MINUET_OPENAI_MODEL") or "gpt-5.4-mini",
					api_key = "OPENAI_API_KEY",
					optional = {
						max_completion_tokens = 128,
						reasoning_effort = "none",
					},
				},
			},
			-- Slightly higher throttle avoids hammering Ollama when typing fast on CPU-bound hosts.
			throttle = 650,
		}
	end,
}
