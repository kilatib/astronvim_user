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
		local function find_upward(name, file)
			if not file or file == "" then
				return nil
			end

			local start = vim.fs.dirname(file)
			local found = vim.fs.find(name, { upward = true, path = start })[1]
			return found
		end

		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = function(file)
						return require("neotest-jest.jest-util").getJestCommand(file) .. " --detectOpenHandles --watchman=false"
					end,
					env = { CI = "true", TZ = "UTC", NODE_ENV = "test" },
					cwd = function(file)
						local package_json = find_upward("package.json", file)
						if package_json then
							return vim.fs.dirname(package_json)
						end

						return file and vim.fs.dirname(file) or vim.fn.getcwd()
					end,
					jest_test_discovery = false,
					discovery = {
						enabled = false,
					},
					isTestFile = function(file)
						return file ~= nil and file:match("%.spec%.[jt]sx?$") ~= nil
					end,
					jestConfigFile = function(file)
						local config = find_upward("jest.config.js", file)
						if config then
							return config
						end

						return vim.fn.getcwd() .. "/jest.config.js"
					end,
				}),
				require("neotest-vitest")({
					filter_dir = function(name, rel_path, root)
						return name ~= "node_modules"
					end,
					is_test_file = function(file)
						return file ~= nil and file:match("%.test%.[jt]sx?$") ~= nil
					end,
				}),
				require("neotest-phpunit")({
					root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist", ".github" },
					filter_dirs = { "src", "vendor" },
					env = {
						XDEBUG_CONFIG = "idekey=neotest",
					},
					dap = require("dap").configurations.php[1],
					phpunit_cmd = function()
						return "/usr/local/bin/dphpunit"
					end,
				}),
			},
		})
	end,
}
