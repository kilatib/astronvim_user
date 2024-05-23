-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local null_ls = require "null-ls"
    local cspell = require "cspell"
    local cspellConfig = {
      config_file_preferred_name = ".cspell.json",
      find_json = function() return "/Users/checkster/.config/nvim/spell/cspell.json" end,
    }
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.phpcbf,
      null_ls.builtins.formatting.phpcsfixer,
      null_ls.builtins.completion.spell,
      null_ls.builtins.diagnostics.codespell,
      null_ls.builtins.diagnostics.write_good,
      null_ls.builtins.formatting.phpcsfixer.with {
        args = {
          "--standard=PSR12",
          "--config",
          "phpcs.xml.dist",
        },
        filetypes = { "php" },
        condition = function(utils) return utils.root_has_file "phpcs.xml.dist" end,
      },
      null_ls.builtins.formatting.prettierd.with {
        extra_filetypes = { "toml" },
        env = {
          PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.config/nvim/lua/user/plugins/conf/.prettierrc.json",
        },
      },
      cspell.diagnostics.with { config = cspellConfig },
      cspell.code_actions.with { config = cspellConfig },
    }
    return config -- return final config table
  end,
}
