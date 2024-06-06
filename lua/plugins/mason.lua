-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        "ansiblels",
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "jsonls",
        "tsserver",
        "marksman",
        "intelephense",
        "yamlls",
        -- add more arguments for adding more language servers
      })
      -- local lspconfig = require "lspconfig"
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true
      -- lspconfig.intelephense.setup {
      --   capabilities = capabilities,
      --   settings = {
      --     intelephense = {
      --       files = {
      --         exclude = {
      --           "**/.git/**",
      --           "**/.svn/**",
      --           "**/.hg/**",
      --           "**/CVS/**",
      --           "**/.DS_Store/**",
      --           "**/node_modules/**",
      --           "**/bower_components/**",
      --           "**/.history/**",
      --         },
      --       },
      --       environment = {
      --         shortOpenTag = false,
      --         includePaths = {
      --           "**/vendor/**/{Tests,tests}/**",
      --           "**/vendor/**/vendor/**",
      --           "**/qtism/**",
      --         },
      --         phpVersion = "8.2",
      --       },
      --     },
      --   },
      -- }
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "prettierd",
        "stylua",
        "phpcbf",
        "write_good",
        "cspell",
        "pell",
        "codespell",
        "phpcsfixer",
        -- add more arguments for adding more null-ls sources
      })
    end,
  },
}
