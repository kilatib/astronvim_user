return {
	"jay-babu/mason-nvim-dap.nvim",
	-- overrides `require("mason-nvim-dap").setup(...)`
	opts = {
		ensure_installed = { "php", "node2" },
		automatic_installation = true,
		handlers = {
			function(config)
				require("mason-nvim-dap").default_setup(config)
			end,
			node2 = function(config)
				local dap = require("dap")
				-- dap.defaults.fallback.switchbuf = "usetab"
				-- dap.defaults.fallback.switchbuf = "useopen,usetab"
				local jsDebugger = {
					{
						type = "node2",
						request = "attach",
						name = "SynchronizerBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						-- docker inspect -f '{{ (index (index .NetworkSettings.Ports "9229/tcp") 1).HostPort }}' nextgen_tao_synchronizer_be
						port = function()
							local portHandle = io.popen(
								"docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' nextgen_tao_synchronizer_be"
							)
							local portData = tonumber(portHandle:read("*a"))
							portHandle:close()

							print("portData: " .. portData)
							return portData
						end,
					},
					{
						type = "node2",
						request = "attach",
						name = "TimersBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = function()
							local portHandle = io.popen(
								"docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' nextgen_rt_timers"
							)
							local portData = tonumber(portHandle:read("*a"))
							portHandle:close()

							print("portData: " .. portData)
							return portData
						end,
					},
					{
						type = "node2",
						request = "attach",
						name = "PaymentsBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = function()
							local portHandle = io.popen(
								"docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' nextgen_tao_payments_be"
							)
							local portData = tonumber(portHandle:read("*a"))
							portHandle:close()

							print("portData: " .. portData)
							return portData
						end,
					},
					{
						type = "node2",
						request = "attach",
						name = "PaymentsBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = function()
							local portHandle = io.popen(
								"docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' nextgen_tao_payments_be"
							)
							local portData = tonumber(portHandle:read("*a"))
							portHandle:close()

							print("portData: " .. portData)
							return portData
						end,
					},
					{
						type = "node2",
						request = "attach",
						name = "DatastoreDataPolicyPipeline",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = function()
							local portHandle = io.popen(
								"docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' nextgen_datastore_data_policy_worker"
							)
							local portData = tonumber(portHandle:read("*a"))
							portHandle:close()

							print("portData: " .. portData)
							return portData
						end,
					},
				}
				dap.configurations.typescript = jsDebugger
				dap.configurations.javascript = jsDebugger
				require("mason-nvim-dap").default_setup(config)
			end,
			php = function(config)
				local dap = require("dap")
				-- dap.defaults.fallback.switchbuf = "useopen"
				dap.configurations.php = {
					{
						type = "php",
						request = "launch",
						name = "TAO-CE:lti1p3gateway",
						port = 9003,
						-- stopOnEntry = true,
						pathMappings = {
							["/opt/tao-ce/proctoring/lti1p3-gateway"] = "${workspaceFolder}",
							["/opt/tao-ce/proctoring/lti1p3-gateway/router.php"] = "${workspaceFolder}/../../router.php",
							["/opt/tao-ce/proctoring/lti1p3-gateway/public/router.php"] = "${workspaceFolder}/../../router.php",
						},
					},
					{
						type = "php",
						request = "launch",
						name = "DeliveryBe",
						port = 9003,
						-- stopOnEntry = true,
						-- pathMappings =
						--   ["/var/www/html"] = "${workspaceFolder}/tao-deliver-be",
						--   ["/var/www/router.php"] = "${workspaceFolder}/docker/resources/router.php",
						-- },
						pathMappings = {
							["/var/www/html"] = "${workspaceFolder}",
							["/var/www/router.php"] = "${workspaceFolder}/../docker/resources/router.php",
						},
					},
					{
						type = "php",
						request = "launch",
						name = "ProctoringLtiGaterwayBe",
						port = 9003,
						-- stopOnEntry = true,
						-- pathMappings =
						--   ["/var/www/html"] = "${workspaceFolder}/tao-deliver-be",
						--   ["/var/www/router.php"] = "${workspaceFolder}/docker/resources/router.php",
						-- },
						pathMappings = {
							["/var/www/html"] = "${workspaceFolder}",
							["/var/www/router.php"] = "${workspaceFolder}/../docker/resources/router.php",
						},
					},
					{
						type = "php",
						request = "launch",
						name = "StudioBe",
						port = 9003,
						pathMappings = {
							["/var/www/html"] = "${workspaceFolder}",
							["/var/www/html/var"] = "${workspaceFolder}/../tao-studio-be/var",
							["/var/www/router.php"] = "${workspaceFolder}/../docker/resources/router.php",
						},
					},
				}
				require("mason-nvim-dap").default_setup(config)
			end,
		},
	},
}
