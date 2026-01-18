return {
	"olimorris/codecompanion.nvim",
	opts = {
		-- =========================
		-- Workflow strategy (Agentic)
		-- =========================
		strategies = {
			workflow = {
				adapter = "openai",
				tools = {
					["insert_edit_into_file"] = { opts = { rewrite = true, auto_approve = true, allow_unsafe = true } },
					["files"] = { opts = { recursive = true, auto_approve = true, allow_unsafe = true } },
					["cmd_runner"] = { opts = { auto_approve = true, allow_unsafe = true } },
				},
			},
		},

		-- =========================
		-- Workflow prompts
		-- =========================
		prompt_library = {
			["Auto Fix Tests"] = {
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

								return [[
### Instructions
You are a fully autonomous test-fixing agent (WAR-MODE).

RULES:
- Never ask the user anything.
- Always act on the target file: {context.filename}.
- Use @{files} to read any files you need (e.g., package.json, composer.json, pytest config).
- Use @{insert_edit_into_file} to overwrite any files.
- Use @{cmd_runner} to run test commands.
- Repeat until tests pass.

AUTONOMOUS LOOP:
1. Detect project language (JS/Node, PHP, Python, etc.).
2. If JS/Node, read package.json using @{files} and extract "test" script.
3. Run the test command via @{cmd_runner}.
4. If tests fail:
   a) Fix import/include paths in the target file using @{insert_edit_into_file}.
   b) Fix any logic errors in implementation using @{insert_edit_into_file}.
5. Overwrite files and rerun tests until all pass.

START IMMEDIATELY.
]]
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
- Use @{files} to read related files for test commands or imports.
- Fix import/include paths in the target file using @{insert_edit_into_file}.
- Fix any logic errors in implementation using @{insert_edit_into_file}.
- Re-run the test command using @{cmd_runner}.
- Do not ask questions, do not explain actions.
]],
						},
					},
				},
			},
			["Auto Create/Update Tests"] = {
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
- Never ask the user anything.
- Detect the project language of the current file (JS, Node, PHP, Python, etc.).
- Scan the project using @{files} to find existing tests for the same language.
- Determine:
  - test file naming convention (e.g., *.spec.js, *Test.php)
  - test directory
  - test style/framework (Jest, PHPUnit, Pytest, etc.)
- Automatically create or update a test covering the current file in the correct directory and naming style.
- Use @{insert_edit_into_file} to create or overwrite the test file.
- Do not ask questions, do not explain actions.

AUTONOMOUS LOOP:
1. Scan project to infer test conventions and locations.
2. Generate a test file that covers the current file.
3. Write the test in the correct language and framework using @{insert_edit_into_file}.
4. Repeat if additional coverage is needed or framework conventions require updates.
5. Stop only when the test is correctly created and follows project conventions.

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
- Ensure the test file exists in the correct directory with the proper naming style.
- Ensure the test covers the current file (all public functions/methods).
- If the test needs updates or additional coverage, modify it using @{insert_edit_into_file}.
- Use @{files} only to inspect other test files for style/reference.
- Do not ask questions, do not explain actions.
- Stop only when the test file is fully created and matches project conventions.
]],
						},
					},
				},
			},
		},
	},
}
