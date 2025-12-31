return {
	"kiddos/gemini.nvim",
	opts = {
		completion = {
			enabled = true,
			insert_result_key = "<Tab><Tab>",
		},
		hints = {
			enabled = true,
			insert_result_key = "<Tab><Tab>",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function(_, opts)
		require("gemini").setup(opts)
		local map = vim.keymap.set
		map("n", "<leader>ga", ":Gemini ", { desc = "Ask Gemini" })
		map("n", "<leader>gu", "ggVG<cmd>GeminiUnitTest<CR>", { desc = "Ask Gemini write unittest" })
		map("v", "<leader>ga", ":'<,'>Gemini<CR>", { desc = "Gemini with Visual Selection" })
	end,
}
