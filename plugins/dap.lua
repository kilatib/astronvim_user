return {
  "jay-babu/mason-nvim-dap.nvim",
  -- overrides `require("mason-nvim-dap").setup(...)`
  opts = {
    ensure_installed = { "php", "node2" },
    automatic_installation = true,
    handlers = {
      function(config) require("mason-nvim-dap").default_setup(config) end,
      node2 = function(config)
        local dap = require "dap"
        dap.defaults.fallback.switchbuf = "useopen"
        dap.configurations.typescript = {
          {
            type = "node2",
            request = "attach",
            name = "SynchronizerBe",
            localRoot = "${workspaceFolder}",
            remoteRoot = "/usr/src/app",
            -- docker inspect -f '{{ (index (index .NetworkSettings.Ports "9229/tcp") 1).HostPort }}' nextgen_tao_synchronizer_be
            port = function()
              local portHandle =
                io.popen "docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' nextgen_tao_synchronizer_be"
              local portData = tonumber(portHandle:read "*a")
              portHandle:close()

              return portData
            end,
          },
        }
        require("mason-nvim-dap").default_setup(config)
      end,
      php = function(config)
        local dap = require "dap"
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
              ["/var/www/router.php"] = "${workspaceFolder}/../docker/resourses/router.php",
            },
          },
        }
        require("mason-nvim-dap").default_setup(config)
      end,
    },
  },
}
