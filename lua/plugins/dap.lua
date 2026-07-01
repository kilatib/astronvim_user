return {
	"jay-babu/mason-nvim-dap.nvim",
	-- overrides `require("mason-nvim-dap").setup(...)`
	opts = {
		-- `node2` maps to `node-debug2-adapter`, which is no longer shipped by Mason.
		-- Keep the custom Node attach configs, but skip broken auto-installation on fresh setups.
		ensure_installed = { "php" },
		automatic_installation = { exclude = { "node2" } },
		handlers = {
			function(config)
				require("mason-nvim-dap").default_setup(config)
			end,
			node2 = function(config)
				local dap = require("dap")
				local function docker_port(container)
					return function()
						local portHandle = io.popen(
							"docker inspect -f '{{ (index (index .NetworkSettings.Ports \"9229/tcp\") 1).HostPort }}' " .. container
						)
						if not portHandle then
							return nil
						end
						local portData = vim.trim(portHandle:read("*a") or "")
						portHandle:close()
						return tonumber(portData)
					end
				end

				local jsDebugger = {
					{
						type = "node2",
						request = "attach",
						name = "SynchronizerBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = docker_port("nextgen_tao_synchronizer_be"),
					},
					{
						type = "node2",
						request = "attach",
						name = "TimersBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = docker_port("nextgen_rt_timers"),
					},
					{
						type = "node2",
						request = "attach",
						name = "PaymentsBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = docker_port("nextgen_tao_payments_be"),
					},
					{
						type = "node2",
						request = "attach",
						name = "PortalBe",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = docker_port("nextgen_tao_portal_be"),
					},
					{
						type = "node2",
						request = "attach",
						name = "DatastoreDataPolicyPipeline",
						localRoot = "${workspaceFolder}",
						remoteRoot = "/usr/src/app",
						port = docker_port("nextgen_datastore_data_policy_worker"),
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
						name = "TAO:PHP:DEBUG",
						port = 9003,
						-- stopOnEntry = true,
						pathMappings = {
							["/var/www/html"] = "${workspaceFolder}",
							["/var/www/router.php"] = "${workspaceFolder}/../docker/resources/router.php",
						},
					},
				}
				require("mason-nvim-dap").default_setup(config)
			end,
		},
	},
}
