return {
	"kiddos/gemini.nvim",
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function(_, opts)
		require("gemini").setup(opts)
		local map = vim.keymap.set
		map("n", "<leader>ga", ":Gemini ", { desc = "Ask Gemini" })
		map("v", "<leader>ga", ":'<,'>Gemini<CR>", { desc = "Gemini with Visual Selection" })
	end,
}
