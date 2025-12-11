return {

    { -- everforest
        "sainnhe/everforest",
        enabled = false,
        name = "everforest",
        priority = 1000,
        config = function()
            vim.g.everforest_better_performance = 1
            vim.g.everforest_transparent_background = tools.transparent_background "numeric"
        end,
    },

    {
        "dapovich/anysphere.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = tools.transparent_background "boolean",
            colors = {},
            italics = true,
        },
    },

    {
        "maccoda/irises.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
    },

    {
        "ficcdaf/ashen.nvim",
        enabled = false,
        -- optional but recommended,
        -- pin to the latest stable release:
        lazy = false,
        priority = 1000,
        -- configuration is optional!
        opts = {
            -- your settings here
        },
    },

    {
        "jpwol/thorn.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "projekt0n/github-nvim-theme",
        enabled = false,
        priority = 1000,
        name = "github-theme",
        opts = {
            options = {
                transparent = tools.transparent_background "boolean",
            },
        },
    },

    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {
            transparent_mode = tools.transparent_background "boolean",
        },
    },

    {
        "wnkz/monoglow.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "tiesen243/vercel.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            theme = "dark",
            transparent = tools.transparent_background "boolean",
        },
    },

    {
        "catppuccin/nvim",
        enabled = false,
        priority = 1000,
        name = "catppuccin",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("catppuccin").setup {
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = tools.transparent_background "boolean",
                color_overrides = {
                    mocha = {},
                },
            }
        end,
    },

    {
        "ribru17/bamboo.nvim",
        priority = 1000,
        opts = {
            style = "vulgaris",
            transparent = tools.transparent_background "boolean",
        },
    },

    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            local main_theme = "darker"
            require("onedark").setup {
                style = main_theme,
                transparent = tools.transparent_background "boolean",
                toggle_style_list = { "light", main_theme },
            }
        end,
    },

    { -- kanagawa
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        opts = {
            transparent = tools.transparent_background "boolean",
            theme = "dragon",
            background = {
                dark = "dragon",
                light = "lotus",
            },
            compile = true,
            undercurl = true,

            commentStyle = { italic = true },
            functionStyle = { italic = true },
            keywordStyle = {},
            statementStyle = { italic = true },
            typeStyle = {},

            colors = {
                palette = {
                    winterYellow = "#302e30",
                },
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                        },
                    },
                    wave = {
                        ui = {
                            -- bg = "#181823",
                        },
                    },
                },
            },
            terminalColors = false,
            overrides = function(colors)
                local theme = colors.theme
                local makeDiagnosticColor = function(color)
                    local c = require "kanagawa.lib.color"
                    return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
                end
                return {

                    DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
                    DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
                    DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
                    DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    TelescopeResultsTitle = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    TelescopeTitle = { fg = theme.ui.bg_p1, bold = true },
                    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    TelescopePreviewTitle = { fg = theme.ui.bg_dim },

                    -- Borderless Snacks Picker
                    -- SnacksPickerListTitle = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    -- SnacksPickerTitle = { fg = theme.ui.bg_p1, bold = true },
                    -- SnacksPickerInput = { bg = theme.ui.bg_p1 },
                    -- SnacksPickerInputTitle = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    -- SnacksPickerInputBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    -- SnacksPickerList = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    -- SnacksPickerListBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    -- SnacksPickerPreview = { bg = theme.ui.bg_dim },
                    -- SnacksPickerPreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    -- SnacksPickerPreviewTitle = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
                    -- SnacksPickerToggle = { bg = theme.ui.bg_p1, fg = theme.ui.bg_p1 },

                    -- add `blend = vim.o.pumblend` to enable transparency
                    -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    -- PmenuSbar = { bg = theme.ui.bg_m1 },
                    -- PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
        },
    },

    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        opts = {
            transparent = tools.transparent_background "boolean",
            disable_nvimtree_bg = true,
        },
    },

    { -- tokyonight
        "folke/tokyonight.nvim",
        enabled = false,
        priority = 1000,
        opts = {
            transparent = tools.transparent_background "boolean",
            style = "night",
            -- on_colors = function(colors)
            --     colors.comment = "#8c98b3"
            -- end,
            plugins = {
                all = package.loaded.lazy == nil,
                auto = true,
            },
        },
    },
}
