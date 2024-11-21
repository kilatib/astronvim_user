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
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    local completion = null_ls.builtins.completion

    local cspell = require "cspell"
    local cspellConfig = {
      config_file_preferred_name = ".cspell.json",
      find_json = function() return vim.fn.expand "~/.config/nvim/spell/cspell.json" end,
    }

    local file_exists = function(file)
      local f = io.open(file, "r")
      if f ~= nil then
        io.close(f)
        return true
      else
        return false
      end
    end
    config.sources = {
      -- Set a formatter
      formatting.stylua,
      formatting.prettierd,
      formatting.phpcbf,
      formatting.phpcsfixer,
      completion.spell,
      formatting.phpcsfixer.with {
        args = {
          "--standard=PSR12",
          "--config",
          "phpcs.xml.dist",
        },
        filetypes = { "php" },
        condition = function(utils) return utils.root_has_file "phpcs.xml.dist" end,
      },
      formatting.prettierd.with {
        extra_filetypes = { "toml", "ts", "js", "svetle" },
        env = {
          PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.config/nvim/lua/plugins/conf/prettier-config/index.json",
        },
      },
      diagnostics.codespell,
      diagnostics.write_good,
      -- diagnostics.eslint_d
      --   .with {
      --   extra_args = function(params)
      --     local file_types = { "js", "cjs", "yaml", "yml", "json" }
      --     for _, file_type in pairs(file_types) do
      --       if file_exists(params.root .. "/.eslintrc." .. file_type) then return {} end
      --     end
      --     return {
      --       -- "--config",
      --       -- vim.fn.expand "~/.config/nvim/lua/plugins/conf/eslint-config-tao/.eslintrc.js",
      --     }
      --   end,
      -- },
      cspell.diagnostics.with { config = cspellConfig },
      cspell.code_actions.with { config = cspellConfig },
    }

    return config
  end,
}
