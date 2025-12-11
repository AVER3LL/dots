return {
    {
        "nvim-tree/nvim-web-devicons",
        enabled = true,
        opts = {},
    },

    -- Colored parenthesis
    {
        "HiPhish/rainbow-delimiters.nvim",
        -- event = "VeryLazy",
    },

    {
        "dgagn/diagflow.nvim",
        enabled = false,
        event = "LspAttach", -- This is what I use personnally and it works great
        config = function()
            local excluded_filetypes = {
                "lazy",
                "mason",
            }
            require("diagflow").setup {
                scope = "cursor", -- or line
                padding_top = 0,
                padding_right = 2,
                show_sign = false,
                toggle_event = { "InsertEnter", "InsertLeave" },
                show_borders = false,
                format = function(diagnostic)
                    local icon = require("icons").diagnostics[diagnostic.severity]

                    -- the space is somehow not taking effect
                    return (icon and icon .. "   " .. diagnostic.message) or diagnostic.message
                end,
                enable = function()
                    return not vim.tbl_contains(excluded_filetypes, vim.bo.filetype)
                end,
            }
        end,
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        enabled = true,
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
