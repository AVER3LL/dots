return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup {
                preview_config = {
                    border = require("config.looks").border_type(),
                },
            }
        end,
    },
    {
        "NeogitOrg/neogit",
        enabled = false,
        cmd = { "Neogit" },
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed.
            "nvim-telescope/telescope.nvim", -- optional
            -- "ibhagwan/fzf-lua", -- optional
            -- "echasnovski/mini.pick", -- optional
        },
        config = true,
    },
}
