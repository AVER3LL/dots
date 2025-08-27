return {
    {
        "nvim-tree/nvim-web-devicons",
        enabled = true,
        opts = {},
    },

    {
        "echasnovski/mini.icons",
        enabled = false,
        lazy = true,
        -- specs = {
        --     { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        -- },
        -- init = function()
        --     package.preload["nvim-web-devicons"] = function()
        --         require("mini.icons").mock_nvim_web_devicons()
        --         return package.loaded["nvim-web-devicons"]
        --     end
        -- end,
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
        "rachartier/tiny-glimmer.nvim",
        event = "VeryLazy",
        priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
        opts = {
            overwrite = {
                yank = { enabled = false },
                undo = { enabled = true },
                redo = { enabled = true },
            },
        },
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        priority = 1000,
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

    {
        "rachartier/tiny-code-action.nvim",
        event = "LspAttach",
        opts = {
            picker = {
                backend = "vim",
                "buffer",
                opts = {
                    hotkeys = true,
                    winborder = tools.border,
                    -- Use numeric labels.
                    hotkeys_mode = function(titles)
                        return vim.iter(ipairs(titles))
                            :map(function(i)
                                return tostring(i)
                            end)
                            :totable()
                    end,
                },
            },
        },
    },
}
