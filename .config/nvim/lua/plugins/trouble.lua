return {
    "folke/trouble.nvim",
    enabled = true,
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
        "<leader>da",
        "<cmd>Trouble diagnostics<CR>",
        desc = "Show all diagnostics",
    },
}
