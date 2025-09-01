return {

    { -- everforest
        "sainnhe/everforest",
        name = "everforest",
        priority = 1000,
        config = function()
            vim.g.everforest_better_performance = 1
            vim.g.everforest_transparent_background = 0
            vim.g.everforest_background = "dark"
        end,
    },

    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
    },

    {
        "kyza0d/xeno.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local xeno = require "xeno"
            xeno.new_theme("xeno-lillypad", {
                base = "#1E1E1E",
                accent = "#8CBE8C",
                contrast = 0.1,
                transparent = false,
            })
        end,
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = false,
        priority = 1000,
    },

    {
        "tiesen243/vercel.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            theme = "dark",
        },
    },

    {
        "catppuccin/nvim",
        priority = 1000,
        name = "catppuccin",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("catppuccin").setup {
                background = {
                    light = "latte",
                    dark = "mocha",
                },
            }
        end,
    },

    {
        "ribru17/bamboo.nvim",
        priority = 1000,
        opts = {
            style = "multiplex",
        },
    },

    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("onedark").setup {
                style = "darker",
                toggle_style_list = { "light", "darker" },
            }
        end,
    },

    {
        "marko-cerovac/material.nvim",
        enabled = false,
        priority = 1000,
        opts = {},
    },

    -- Jetbrains theme
    {
        "nickkadutskyi/jb.nvim",
        priority = 1000,
        opts = {},
    },

    { -- kanagawa
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        opts = {
            transparent = false,
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
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
        },
    },

    { -- gruvbox-material
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_transparent_background = 0
            vim.g.gruvbox_material_foreground = "mix"
            vim.g.gruvbox_material_background = "medium"
            vim.g.gruvbox_material_ui_contrast = "high"
            vim.g.gruvbox_material_float_style = "bright"
            vim.g.gruvbox_material_statusline_style = "material"
            vim.g.gruvbox_material_cursor = "auto"

            vim.g.gruvbox_material_better_performance = 1
        end,
    },

    {
        "Mofiqul/vscode.nvim",
        priority = 1000,
        opts = {},
    },

    { -- tokyonight
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {
            -- on_colors = function(colors)
            --     colors.comment = "#8c98b3"
            -- end,
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                -- local subtle_color = "#8c98b3"
                -- hl.LineNr = { fg = subtle_color }
                -- hl.LineNrAbove = { fg = subtle_color }
                -- hl.LineNrBelow = { fg = subtle_color }

                hl.Visual = { bg = "#445b9b" }
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
            plugins = {
                all = package.loaded.lazy == nil,
                auto = true,
            },
        },
    },
}
