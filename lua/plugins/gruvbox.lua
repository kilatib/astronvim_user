return {
	"ellisonleao/gruvbox.nvim",
	name = "gruvbox",
	config = function()
		local color_white = "#ebdbb2"
		local color_gray = "#a1a1a1"
		local color_black = "#282828"
		local color_bg = "#232323"
		local color_prompt = "#32302f"
		local color_red = "#cc231d"
		local color_yellow = "#d79921"
		local color_green = "#b8bb26"
		local color_orange = "#fe8019"

		require("gruvbox").setup({
			transparent_mode = true,
			overrides = {
				NormalFloat = { fg = color_white, bg = color_bg },
				FloatBorder = { fg = color_bg, bg = color_bg },
				StatusLine = { fg = color_white, bg = color_bg },
				TelescopeNormal = { bg = color_bg, fg = color_white },
				TelescopeSelection = { bg = color_prompt, fg = color_white },
				TelescopeSelectionCaret = { fg = color_red },
				TelescopeMultiSelection = { fg = color_yellow },
				TelescopeBorder = { bg = color_bg, fg = color_bg },
				TelescopeResultsBorder = {},
				TelescopePreviewBorder = {},
				TelescopeMatching = { fg = color_orange },
				TelescopePromptTitle = { bg = color_yellow, fg = color_black },
				TelescopePromptPrefix = { bg = color_red, fg = color_red },
				TelescopePrompt = { bg = color_orange },
				TelescopePromptNormal = { bg = color_prompt, fg = color_white },
				TelescopePromptBorder = { bg = color_prompt, fg = color_prompt },
				TelescopePreviewTitle = { bg = color_green, fg = color_black },
				CmpPmenu = { bg = color_bg },
				CmpBorder = { fg = color_bg, bg = color_bg },
				CmpDocBorder = { fg = color_bg, bg = color_bg },
				CmpDoc = { bg = color_bg },
				DiagnosticFloatingError = { bg = color_bg, fg = color_red },
				DiagnosticFloatingWarn = { bg = color_bg, fg = color_orange },
				DiagnosticFloatingInfo = { bg = color_bg, fg = color_yellow },
				DiagnosticFloatingHint = { bg = color_bg, fg = color_white },
				NERDTreeHelp = { link = "NONE" },
				WinBarNC = { bg = color_black, fg = color_gray },
			},
		})
	end,
}
