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
				["TTD loop JS"] = {
					strategy = "chat",
					description = "Run a Test-Driven Development loop using editor and JS",
					opts = {
						is_default = true,
						is_slash_cmd = true,
						short_name = "tests",
						auto_submit = true,
					},
					prompts = {
						{
							role = "system",
							content = [[
You are required to write code following the instructions provided and test the correctness by running the designated test suite.
Follow these steps exactly:

1. Update the code in #buffer{watch} using the @editor tool
2. Then use the @cmd_runner tool to run the test suite with jest or vitest (do this after you have updated the code)
3. Make sure you trigger both tools in the same response

We'll repeat this cycle until the tests pass. Ensure no deviations from these steps.
]],
							opts = { visible = false },
						},
						{
							role = "user",
							-- CodeCompanion will automatically replace #{buffer} with your file content
							content = "Please begin the loop. The current requirement is: closed account must fail.",
						},
					},
				},
				["TTD loop PHP"] = {
					strategy = "chat",
					description = "Run a Test-Driven Development loop using editor and PHP",
					opts = {
						is_default = true,
						is_slash_cmd = true,
						short_name = "tests",
						auto_submit = true,
					},
					prompts = {
						{
							role = "system",
							content = [[
You are required to write code following the instructions provided and test the correctness by running the designated test suite.
Follow these steps exactly:

1. Update the code in #buffer{watch} using the @editor tool
2. Then use the @cmd_runner tool to run the test suite with phpunit (do this after you have updated the code)
3. Make sure you trigger both tools in the same response

We'll repeat this cycle until the tests pass. Ensure no deviations from these steps.
]],
							opts = { visible = false },
						},
						{
							role = "user",
							-- CodeCompanion will automatically replace #{buffer} with your file content
							content = "Please begin the loop. The current requirement is: closed account must fail.",
						},
					},
				},
			},
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = { default = "qwen2.5-coder:14b" },
							num_ctx = { default = 16384 },
						},
					})
				end,
			},
		},
	},
}
