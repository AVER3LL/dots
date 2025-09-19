---@module 'lazy'
---@type LazyPluginSpec
return {
    "ThePrimeagen/refactoring.nvim",
    keys = {
        {
            "<leader>cr",
            function()
                require("refactoring").select_refactor { prefer_ex_cmd = true }
            end,
            mode = { "x", "n" },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
}
