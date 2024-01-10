return {
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        handlers = {
          php = function(source_name)
            local dap = require "dap"
            dap.configurations.php = {
              {
                type = 'php',
                request = 'launch',
                name = 'DeliveryBe',
                port = 9000,
                pathMappings = {
                  ['/var/www/html'] = "${workspaceRoot}/tao-deliver-be",
                },
                proxy = {
                    key = 'deliver-be',
                    host= 'host.docker.internal'
                },
              }
            }
          end,
        },
      },
    },
  }

