---@type LazySpec
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-phpunit",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-vitest")({
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
				}),
				require("neotest-jest")({
					-- jestCommand = "npm test --",
					jestCommand = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand("%:p:h"))
						.. " --detectOpenHandles",
					-- jestConfigFile = "jest.config.js",
					env = { CI = true, TZ = UTC, NODE_ENV = test },
					cwd = function(file)
						return vim.fn.fnamemodify(file, ":h")
					end,
					jest_test_discovery = false,
					discovery = {
						enabled = false,
					},
					jestConfigFile = function(file)
						if file:find("/") then
							local match = file:match("(.*/[^/]+/)src")

							if match then
								return match .. "jest.config.js"
							end
						end

						return vim.fn.getcwd() .. "/jest.config.js"
					end,
				}),
				require("neotest-phpunit")({
					root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist", ".github" },
					filter_dirs = { "src", "vendor" },
					env = {
						REMOTE_PHPUNIT_BIN = "bin/phpunit",
						XDEBUG_CONFIG = "idekey=neotest",
					},
					dap = require("dap").configurations.php[1],
					phpunit_cmd = function()
						return "/usr/local/bin/dphpunit"
						-- return {
						--   "docker",
						--   "exec",
						--   "-it",
						--   "-e XDEBUG_MODE=off",
						--   "nextgen_tao_deliver_be",
						--   "bin/phpunit",
						-- }
					end,
				}),
			},
		})
	end,
}
