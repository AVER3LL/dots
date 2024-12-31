return {
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },

    {
        "mikavilpas/yazi.nvim",
        cmd = "Yazi",
        opts = {},
    },

    -- Lua
    {
        "folke/zen-mode.nvim",
        enabled = false,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    {
        "MunsMan/kitty-navigator.nvim",
        build = {
            "cp navigate_kitty.py ~/.config/kitty",
            "cp pass_keys.py ~/.config/kitty",
        },
        keys = {
            {
                "<C-h>",
                function()
                    require("kitty-navigator").navigateLeft()
                end,
                desc = "Move left a Split",
                mode = { "n" },
            },
            {
                "<C-j>",
                function()
                    require("kitty-navigator").navigateDown()
                end,
                desc = "Move down a Split",
                mode = { "n" },
            },
            {
                "<C-k>",
                function()
                    require("kitty-navigator").navigateUp()
                end,
                desc = "Move up a Split",
                mode = { "n" },
            },
            {
                "<C-l>",
                function()
                    require("kitty-navigator").navigateRight()
                end,
                desc = "Move right a Split",
                mode = { "n" },
            },
        },
    },

    {
        "m4xshen/hardtime.nvim",
        enabled = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
    },
}
