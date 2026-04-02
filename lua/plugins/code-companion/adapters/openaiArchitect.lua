-- Heavy lifting: system design, refactors, multi-file reasoning, agent workflows.
-- Requires OPENAI_API_KEY. Model: OPENAI_ARCHITECT_MODEL or gpt-4.1.
return require("codecompanion.adapters").extend("openai", {
	name = "openaiArchitect",
	formatted_name = "OpenAI · Architect",
	schema = {
		model = {
			default = os.getenv("OPENAI_ARCHITECT_MODEL") or "gpt-4.1",
		},
	},
	parameters = {
		temperature = 0.2,
	},
})
