return {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "olimorris/neotest-phpunit",
        "nvim-neotest/neotest-jest",
    },
    config = function()
        require("neotest").setup {
            require "neotest-jest" {
                jestCommand = "npm test --",
                jestConfigFile = "jest.config.ts",
                env = { CI = true, TZ = UTC },
                cwd = function(path) return vim.fn.getcwd() end,
                jest_test_discovery = false,
                discovery = {
                    enabled = false,
                },
            },
            adapters = {
                require "neotest-phpunit" {
                    root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist", ".github" },
                    filter_dirs = { "vendor" },
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
                },
            },
        }
    end,
}
