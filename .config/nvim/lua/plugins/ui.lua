return {
    {
        "echasnovski/mini.icons",
        lazy = true,
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        opts = {
            default = {
                file = { glyph = "󰈚" },
            },
            extension = {
                js = { glyph = "" },
                ts = { glyph = "󰛦" },
            },
        },
    },

    -- Colored parenthesis
    {
        "HiPhish/rainbow-delimiters.nvim",
        -- event = "VeryLazy",
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        -- event = "VeryLazy",
        priority = 1000, -- needs to be loaded in first
        opts = {
            preset = "simple",
            hi = {
                background = "NONE",
            },
            options = {
                multilines = {
                    enabled = false,
                    always_show = false,
                },
            },
        },
    },
}
