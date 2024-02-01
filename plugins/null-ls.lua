return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    --
    local null_ls = require "null-ls"
    config.sources = {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.phpcbf,
      null_ls.builtins.formatting.phpcsfixer,
      null_ls.builtins.completion.spell,
      null_ls.builtins.formatting.prettierd.with {
        extra_filetypes = { "toml" },
        env = {
          PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.config/nvim/lua/user/plugins/conf/.prettierrc.json",
        },
      },
    }
    return config -- return final config table
  end,
}
