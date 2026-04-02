-- Uses OLLAMA_HOST from the environment (same as CodeCompanion's stock Ollama adapter).
return require("codecompanion.adapters").extend("ollama", {
	name = "homeLab",
	schema = {
		model = { default = "qwen2.5-coder:32b" },
	},
	parameters = {
		options = {
			num_ctx = 16384,
			temperature = 0,
		},
	},
})
