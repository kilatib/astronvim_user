return {
	strategy = "workflow",
	description = "Automatically create or update a test for the current file based on project style",
	opts = { is_default = false },
	prompts = {
		{
			{
				name = "Initialize Test Creation",
				role = "user",
				opts = { auto_submit = true, stop_context_insertion = true },
				content = [[
### Instructions
You are a fully autonomous test-creation agent.
RULES:
- Detect project language/framework via @{files}.
- Create/update test covering current file via @{insert_edit_into_file}.
- Do not ask questions.
START IMMEDIATELY.
]],
			},
		},
		{
			{
				name = "Autonomous Test Creation Loop",
				role = "user",
				opts = { auto_submit = true },
				condition = function()
					return _G.codecompanion_current_tool == "insert_edit_into_file"
				end,
				repeat_until = function(chat)
					return chat.tools.flags.testing == true
				end,
				content = [[
- Ensure test exists and covers functions.
- Modify via @{insert_edit_into_file}.
- Stop when done.
]],
			},
		},
	},
}
