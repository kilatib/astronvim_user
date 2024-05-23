return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          ["<leader>lc"] = { ":Copilot panel<cr>", desc = "Copilot" }, -- change description but the same command
          ["<leader>lce"] = { ":Copilot enable<cr>", desc = "Copilot Enable" }, -- change description but the same command
          ["<leader>gR"] = { ":OpenInGHRepo<cr>", desc = "Open github repository" }, -- change description but the same command
          ["<leader>gf"] = { ":OpenInGHFile<cr>", desc = "Open file on github" }, -- change description but the same command
          ["<leader>bD"] = {
            function()
              require("astronvim.utils.status").heirline.buffer_picker(
                function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- tables with the `name` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<leader>T"] = { name = "Unit Tests" },
          ["<leader>Tl"] = {
            desc = "List",
            function() require("neotest").summary.open() end,
          },
          ["<leader>Tr"] = {
            desc = "Run last",
            function() require("neotest").run.run_last() end,
          },
          ["<leader>Tm"] = {
            desc = "Run marked",
            function() require("neotest").summary.run_marked() end,
          },
          ["<leader>r"] = {
            name = "Rest Requests",
          },
          ["<leader>rr"] = {
            desc = "Run request under cursor",
            "<cmd>Rest run<cr>",
          },
          ["<leader>rl"] = {
            desc = "Run last request",
            "<cmd>Rest run last<cr>",
          },
        },
        t = {},
      },
    },
  },
}
