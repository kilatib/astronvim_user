return {
 "nvim-telescope/telescope-dap.nvim",
  name = "TelescopeDap",
  event = "VeryLazy",
  opts = {},  -- automatically calls `require("lazydocker").setup()`
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("telescope").load_extension("dap")
  end,
}
