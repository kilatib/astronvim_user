-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "xiantang/darcula-dark.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
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

      require("gruvbox").setup {
        transparent_mode = true,
        overrides = {
          -- Status Line
          NormalFloat = { fg = "#ebdbb2", bg = color_bg },
          FloatBorder = { fg = color_bg, bg = color_bg },
          StatusLine = { fg = "#ebdbb2", bg = color_bg },
          -- Telescope General
          TelescopeNormal = { bg = color_bg, fg = color_white },
          TelescopeSelection = { bg = color_prompt, fg = color_white },
          TelescopeSelectionCaret = { bg = "", fg = color_red },
          TelescopeMultiSelection = { bg = "", fg = color_yellow },
          TelescopeBorder = { bg = color_bg, fg = color_bg },
          TelescopeResultsBorder = { bg = "", fg = "" },
          TelescopePreviewBorder = { bg = "", fg = "" },
          TelescopeMatching = { bg = "", fg = color_orange },
          -- Prompt Section
          TelescopePromptTitle = { bg = color_yellow, fg = color_black },
          TelescopePromptPrefix = { bg = color_red, fg = color_red },
          TelescopePrompt = { bg = color_orange, fg = "" },
          TelescopePromptNormal = { bg = color_prompt, fg = color_white },
          TelescopePromptBorder = { bg = color_prompt, fg = color_prompt },
          -- Preview Section
          TelescopePreviewTitle = { bg = color_green, fg = color_black },
          -- CMP
          CmpPmenu = { bg = color_bg },
          CmpBorder = { fg = color_bg, bg = color_bg },
          CmpDocBorder = { fg = color_bg, bg = color_bg },
          CmpDoc = { bg = color_bg },
          -- Diagnostics
          DiagnosticFloatingError = { bg = color_bg, fg = color_red },
          DiagnosticFloatingWarn = { bg = color_bg, fg = color_orange },
          DiagnosticFloatingInfo = { bg = color_bg, fg = color_yellow },
          DiagnosticFloatingHint = { bg = color_bg, fg = color_white },
          -- Nerdtree and Nvim-Tree
          NERDTreeHelp = { link = "NONE" },
          -- WinBar
          WinBarNC = { bg = color_black, fg = color_gray },
        },
      }
    end,
  },

}
