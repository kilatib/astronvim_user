return {
	"nickkadutskyi/jb.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
	},
	config = function(_, opts)
		require("jb").setup(opts)
		require("custom.jb_treesitter_fix")
	end,
}
