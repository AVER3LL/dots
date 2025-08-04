return {
    {
        "ricardoramirezr/blade-nav.nvim",
        enabled = false,
        dependencies = {
            "saghen/blink.cmp",
        },
        ft = { "blade", "php" },
        opts = {
            close_tag_on_complete = false,
        },
    },

    {
        "adibhanna/laravel.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
        },
        ft = { "blade", "php" },
        config = function()
            require("laravel").setup {
                notifications = false,
                debug = false,
                keymaps = false,
            }

            tools.map("n", "<leader>la", ":LaravelMake<CR>", { desc = "Laravel Make" })
            tools.map("n", "<leader>lc", ":LaravelController<CR>", { desc = "Laravel Controllers" })
            tools.map("n", "<leader>lr", ":LaravelRoute<CR>", { desc = "Laravel Routes" })
            tools.map("n", "<leader>lm", ":LaravelModel<CR>", { desc = "Laravel Models" })
            tools.map("n", "gf", ":LaravelGoto<CR>", { desc = "Laravel Goto" })
        end,
    },
}
