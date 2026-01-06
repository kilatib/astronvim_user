return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "ollama",
					opts = {
						system_prompt = "Your are expert in programming. Respond shortly by facts on english. Write clean optimized code.",
					},
				},
				inline = { adapter = "ollama" },
			},
			-- ADDED: Custom prompt library for the /tests command
			prompt_library = {
				["Generate Unit Tests"] = {
					strategy = "chat",
					description = "Generate unit tests for the current buffer",
					opts = {
						is_default = true,
						is_slash_cmd = true,
						short_name = "tests",
						auto_submit = true,
					},
					prompts = {
						{
							role = "system",
							content = "You are an expert developer. Generate tests using the best framework for the language. Respond only with code.",
							opts = { visible = false },
						},
						{
							role = "user",
							-- CodeCompanion will automatically replace #{buffer} with your file content
							content = "Please generate unit tests for this code:\n\n#{buffer}",
						},
					},
				},
			},
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = { default = "qwen2.5-coder:7b" },
							num_ctx = { default = 16384 },
						},
					})
				end,
			},
		},
	},
}
