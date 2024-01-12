return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-phpunit",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-phpunit" {
          root_files = { "composer.json", "phpunit.xml", "phpunit.xml.dist", ".github" },
          filter_dirs = { "vendor" },
          env = {
            REMOTE_PHPUNIT_BIN = "bin/phpunit",
          },
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
