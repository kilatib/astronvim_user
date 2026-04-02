return {
	strategy = "workflow",
	description = "Fully autonomous WAR-MODE: fixes failing tests or code in any language until they pass",
	opts = { is_default = true },

	prompts = {
		{
			{
				name = "Initialize WAR-MODE",
				role = "user",
				opts = { auto_submit = true, stop_context_insertion = true },
				content = function(context)
					local approvals = require("codecompanion.interactions.chat.tools.approvals")
					approvals:toggle_yolo_mode()
					return string.format(
						[[
You are an autonomous test-fixing agent.

ABSOLUTE RULES:
- Never ask questions
- Never explain
- Never chat
- Never output plain text
- Only call tools

TARGET TEST FILE:
%s

AVAILABLE TOOLS:
- @{cmd_runner}
- @{insert_edit_into_file}
- @{files}

WORKFLOW:
1. Run tests using @{cmd_runner}
2. If tests fail:
   - Fix ONLY the target test file
   - Use @{insert_edit_into_file}
3. Repeat until tests pass

FIRST ACTION (MANDATORY):
Call @{cmd_runner} with this command:

npm test -- %s 2>&1 || true
]],
						context.filename,
						context.filename
					)
				end,
			},
		},
		{
			{
				name = "Autonomous Fix Loop",
				role = "user",
				opts = { auto_submit = true },
				condition = function()
					return _G.codecompanion_current_tool == "cmd_runner"
				end,
				repeat_until = function(chat)
					return chat.tools.flags.testing == true
				end,
				content = [[
Tests failed or errors detected.
- Fix import paths if necessary in the target test file using @{insert_edit_into_file}.
- Fix implementation logic if necessary using @{insert_edit_into_file}.
- Re-run the test command using @{cmd_runner}.
- Do not ask questions, do not explain actions.
]],
			},
		},
	},
}
