return {
	"nickkadutskyi/jb.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
	},
	config = function(_, opts)
		require("jb").setup(opts)
	end,
}
