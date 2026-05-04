local ollama_env = require("custom.ollama_env")

return require("codecompanion.adapters").extend("ollama", {
	name = "homeLabLight",
	env = {
		url = function()
			return ollama_env.ollama_light_base()
		end,
	},
	schema = {
		model = { default = "qwen2.5-coder:7b" },
	},
	parameters = {
		sync = true,
		options = {
			num_ctx = 8192,
			temperature = 0,
		},
	},
})
