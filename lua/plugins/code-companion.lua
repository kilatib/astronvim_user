-- Heavy interactions (chat / agent / workflow): OpenAI with OPENAI_API_KEY by default.
-- Set CODECOMPANION_HEAVY_ADAPTER=homeLab to force local Ollama for those when offline.
-- Inline edits stay on homeLab for speed and cost.
local heavy_adapter = os.getenv("CODECOMPANION_HEAVY_ADAPTER")
	or os.getenv("CODECOMPANION_ADAPTER")
	or os.getenv("AI_PROVIDER")
	or "openaiArchitect"

local tool_opts = {
	opts = {
		auto_submit_errors = true,
		auto_submit_success = true,
	},
	["cmd_runner"] = {
		opts = {
			require_approval_before = false,
		},
	},
}

local function heavy_interaction(adapter)
	return {
		adapter = adapter,
		tools = tool_opts,
	}
end

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = heavy_interaction(heavy_adapter),
			inline = { adapter = "homeLab" },
			agent = heavy_interaction(heavy_adapter),
			workflow = heavy_interaction(heavy_adapter),
		},

		adapters = {
			http = {
				openaiArchitect = function()
					return require("plugins/code-companion/adapters/openaiArchitect")
				end,
				homeLabLight = function()
					return require("plugins/code-companion/adapters/homeLabLight")
				end,
				homeLab = function()
					return require("plugins/code-companion/adapters/homeLab")
				end,
			},
		},

		prompt_library = {
			["Generate Commit (7b)"] = require("plugins/code-companion/prompt/ai-local-commit"),
			["Auto Fix Tests"] = require("plugins/code-companion/prompt/auto-fix-test"),
			["Auto Create/Update Tests"] = require("plugins/code-companion/prompt/create-test"),
		},
	},
}
