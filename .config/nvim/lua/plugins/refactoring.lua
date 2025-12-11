---@module 'lazy'
---@type LazyPluginSpec
return {
    "ThePrimeagen/refactoring.nvim",
    keys = {
        {
            "<leader>rf",
            function()
                require("refactoring").select_refactor { prefer_ex_cmd = true }
            end,
            mode = { "x", "n" },
            desc = "Refactor",
        },
        {
            "<leader>ref",
            function()
                require("refactoring").refactor "Extract Function"
            end,
            mode = { "x" },
            desc = "Refactor: Extract Function",
            expr = true,
        },
        {
            "<leader>rif",
            function()
                require("refactoring").refactor "Inline Function"
            end,
            mode = { "x", "n" },
            desc = "Refactor: Inline Function",
            expr = true,
        },
        {
            "<leader>riv",
            function()
                require("refactoring").refactor "Inline Variable"
            end,
            mode = { "x", "n" },
            desc = "Refactor: Inline Variable",
            expr = true,
        },
        {
            "<leader>rev",
            function()
                require("refactoring").refactor "Extract Variable"
            end,
            mode = { "x", "n" },
            desc = "Refactor: Extract Variable",
            expr = true,
        },
        {
            "<leader>reF",
            function()
                require("refactoring").refactor "Extract Function To File"
            end,
            mode = { "x", "n" },
            desc = "Refactor: Extract Function to File",
            expr = true,
        },
        {
            "<leader>reb",
            function()
                require("refactoring").refactor "Extract Block"
            end,
            mode = { "x", "n" },
            desc = "Refactor: Extract Block",
            expr = true,
        },
        {
            "<leader>reB",
            function()
                require("refactoring").refactor "Extract Block To File"
            end,
            mode = { "x", "n" },
            desc = "Refactor: Extract Block to File",
            expr = true,
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
}
