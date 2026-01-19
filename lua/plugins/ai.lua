return {
	"olimorris/codecompanion.nvim",
	opts = {
		-- =========================
		-- Workflow strategy (Agentic)
		-- =========================
		strategies = {
			chat = {
				adapter = {
					name = os.getenv("AI_PROVIDER") or "ollama",
					model = os.getenv("AI_MODEL") or "qwen2.5:7b-instruct",
				},
				tools = {
					["insert_edit_into_file"] = { opts = { rewrite = true, auto_approve = true, allow_unsafe = true } },
					["files"] = { opts = { recursive = true, auto_approve = true, allow_unsafe = true } },
					["cmd_runner"] = { opts = { auto_approve = true, allow_unsafe = true } },
				},
			},
			inline = {
				adapter = {
					name = os.getenv("AI_PROVIDER") or "ollama",
					model = os.getenv("AI_MODEL") or "qwen2.5:7b-instruct",
				},
				tools = {
					["insert_edit_into_file"] = { opts = { rewrite = true, auto_approve = true, allow_unsafe = true } },
					["files"] = { opts = { recursive = true, auto_approve = true, allow_unsafe = true } },
					["cmd_runner"] = { opts = { auto_approve = true, allow_unsafe = true } },
				},
			},
			agent = {
				adapter = {
					name = os.getenv("AI_PROVIDER") or "ollama",
					model = os.getenv("AI_MODEL") or "qwen2.5:7b-instruct",
				},
				tools = {
					["insert_edit_into_file"] = { opts = { rewrite = true, auto_approve = true, allow_unsafe = true } },
					["files"] = { opts = { recursive = true, auto_approve = true, allow_unsafe = true } },
					["cmd_runner"] = { opts = { auto_approve = true, allow_unsafe = true } },
				},
			},
			workflow = {
				adapter = os.getenv("AI_PROVIDER"),
				tools = {
					["insert_edit_into_file"] = { opts = { rewrite = true, auto_approve = true, allow_unsafe = true } },
					["files"] = { opts = { recursive = true, auto_approve = true, allow_unsafe = true } },
					["cmd_runner"] = { opts = { auto_approve = true, allow_unsafe = true } },
				},
			},
		},

		adapters = {
			http = {
				opts = {
					allow_insecure = true,
				},
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						env = {
							url = os.getenv("OLLAMA_ENDPOINT") or "http://localhost:11434",
							api_key = "TERM",
						},
						headers = {
							["Content-Type"] = "application/json",
						},
						parameters = {
							sync = true,
						},
					})
				end,
			},
		},
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

								local test_cmd = string.format("npm test -- %s 2>&1 || true", context.filename)

								return string.format(
									[[
### Instructions
You are a fully autonomous test-fixing agent.

RULES:
- Never ask the user anything.
- Always act on the target test file: %s
- Use @{insert_edit_into_file} to overwrite code.
- Use @{cmd_runner} to run tests.
- Use @{files} to search project files if needed.
- Repeat until tests pass.

AUTONOMOUS LOOP:
1. Analyze test output.
2. If "Cannot find module", fix imports in the target test file.
3. If logic errors, fix implementation.
4. Overwrite files using @{insert_edit_into_file}.
5. Run the test command again.

START IMMEDIATELY:
Command: %s
]],
									context.filename,
									test_cmd
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
			},
		},
	},
}
