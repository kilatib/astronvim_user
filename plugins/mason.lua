-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
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
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "prettier",
        "stylua",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = { "php", "chrome" },
      automatic_installation = true,
      handlers = {
        function(config) require("mason-nvim-dap").default_setup(config) end,
        php = function(config)
          local dap = require "dap"
          -- dap.adapters.php = {
          --   type = "executable",
          --   command = "/usr/bin/php",
          --   args = {
          --     "-dmemory_limit=-1",
          --   },
          -- }
          dap.defaults.fallback.switchbuf = "useopen"
          dap.configurations.php = {
            {
              type = "php",
              request = "launch",
              name = "DeliveryBe",
              port = 9003,
              -- stopOnEntry = true,
              -- pathMappings = {
              --   ["/var/www/html"] = "${workspaceFolder}/tao-deliver-be",
              --   ["/var/www/router.php"] = "${workspaceFolder}/docker/resourses/router.php",
              -- },
              pathMappings = {
                ["/var/www/html"] = "${workspaceFolder}",
                ["/var/www/router.php"] = "${workspaceRoot}/../docker/resourses/router.php",
              },
            },
          }
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },
}
