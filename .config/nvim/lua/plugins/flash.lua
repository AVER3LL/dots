return {
    "folke/flash.nvim",
    enabled = false,
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            char = { enabled = false },
        },
    },
  -- stylua: ignore
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
}
