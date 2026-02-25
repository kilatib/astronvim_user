return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
	config = function()
		require("mcphub").setup({
			config = vim.fn.expand("~/.config/nvim/lua/plugins/mcphub/servers.json"),
		})
	end,
}
