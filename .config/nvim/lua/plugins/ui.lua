return {
    {
        "nvim-tree/nvim-web-devicons",
        enabled = true,
        opts = {},
    },

    {
        "ahkohd/buffer-sticks.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>j",
                function()
                    BufferSticks.jump()
                end,
                desc = "Buffer jump mode",
            },
        },
        config = function()
            local sticks = require "buffer-sticks"
            sticks.setup {
                filter = { buftypes = { "terminal" } },
                highlights = {
                    active = { link = "Statement" },
                    inactive = { link = "Whitespace" },
                    active_modified = { link = "Constant" },
                    inactive_modified = { link = "Constant" },
                    label = { link = "Comment" },
                },
            }
            sticks.show()
        end,
    },

    {
        -- Calls `require('slimline').setup({})`
        "sschleemilch/slimline.nvim",
        opts = {
            sep = {
                hide = {
                    first = not tools.border == "rounded", -- hides the first separator of the line
                    last = not tools.border == "rounded", -- hides the last separator of the line
                },
                left = tools.border == "rounded" and "" or " ",
                right = tools.border == "rounded" and "" or " ",
            },
            spaces = {
                components = tools.border == "rounded" and " " or "",
                left = tools.border == "rounded" and " " or "",
                right = tools.border == "rounded" and " " or "",
            },
            components = {
                left = {
                    "mode",
                    "path",
                    "git",
                },
                center = {},
                right = {
                    "diagnostics",
                    "filetype_lsp",
                    "progress",
                },
            },
        },
    },

    {
        "mskelton/termicons.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        build = false,
    },

    {
        "nvim-mini/mini.icons",
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
                paste = { enabled = false },
                undo = { enabled = true },
                redo = {
                    enabled = true,
                    redo_mapping = "U",
                },
            },
        },
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        opts = {
            preset = "simple",
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
