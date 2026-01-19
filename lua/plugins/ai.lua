local adapterConfig = {
	adapter = {
		name = os.getenv("AI_PROVIDER") or "ollama",
		model = os.getenv("AI_MODEL") or "llama3.1:8b",
	},
	tools = {
		opts = {
			auto_submit_errors = true, -- Send any errors to the LLM automatically?
			auto_submit_success = true, -- Send any successful output to the LLM automatically?
		},
		["cmd_runner"] = {
			opts = {
				require_approval_before = false,
			},
		},
	},
}
return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		completion_provider = "blink",
		log_level = "DEBUG",
		display = {
			diff = {
				enabled = true,
				provider = "default", -- default|mini_diff
			},
		},
		strategies = {
			chat = adapterConfig,
			inline = adapterConfig,
			agent = adapterConfig,
			workflow = adapterConfig,
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
							temperature = 0,
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
