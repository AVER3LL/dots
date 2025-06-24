return {

    { -- theme switcher
        "gagbo/circadian.nvim",
        config = function()
            local dark_themes = { "tokyonight-night", "moonfly", "gruvbox-material" }
            local light_themes = { "palenight", "sonokai", "kanagawa", "monokai-pro-octagon" }
            math.randomseed(os.time())
            local selected_light_theme = light_themes[math.random(#light_themes)]
            local selected_dark_theme = dark_themes[math.random(#dark_themes)]
            require("circadian").setup {
                lat = 6.390192,
                lon = 2.270412,
                day = { background = "dark", colorscheme = selected_light_theme },
                night = { background = "dark", colorscheme = selected_dark_theme },
            }
        end,
    },

    {
        "baliestri/aura-theme",
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
        end,
    },

    {
        "rose-pine/neovim",
        priority = 1000,
        name = "rose-pine",
        opts = {
            variant = "auto", -- auto, main, moon, or dawn
            dark_variant = "moon", -- main, moon, or dawn
            dim_inactive_windows = false,

            styles = {
                bold = true,
                italic = false,
                transparency = false,
            },

            -- Breaks borderless telescope if set to true
            --
            -- I think.
            extend_background_behind_borders = false,

            highlight_groups = {
                StatusLine = { fg = "love", bg = "love", blend = 10 },
                StatusLineNC = { fg = "subtle", bg = "surface" },

                -- Borderless Snacks picker
                SnacksPickerBorder = { fg = "overlay", bg = "overlay" },
                SnacksPicker = { fg = "subtle", bg = "overlay" },
                SnacksPickerInput = { fg = "text", bg = "surface" },
                -- SnacksPickerInputTitle = { fg = "base", bg = "pine" },
                -- SnacksPickerPreviewTitle = { fg = "base", bg = "iris" },
                SnacksPickerInputBorder = { fg = "surface", bg = "surface" },
                SnacksPickerListCursorLine = { fg = "text", bg = "highlight_med" },
                SnacksPickerPreviewTitle = { fg = "overlay", bg = "overlay" },
                SnacksPickerListTitle = { fg = "overlay", bg = "overlay" },
                SnacksPickerInputTitle = { fg = "surface", bg = "surface" },
                SnacksPickerToggle = { fg = "surface", bg = "surface" },

                TelescopeBorder = { fg = "overlay", bg = "overlay" },
                TelescopeNormal = { fg = "subtle", bg = "overlay" },
                TelescopeSelection = { fg = "text", bg = "highlight_med" },
                TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
                TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

                TelescopeTitle = { fg = "base", bg = "love" },
                TelescopePromptTitle = { fg = "base", bg = "pine" },
                TelescopePreviewTitle = { fg = "base", bg = "iris" },

                TelescopePromptNormal = { fg = "text", bg = "surface" },
                TelescopePromptBorder = { fg = "surface", bg = "surface" },
            },
        },
    },

    {
        "loctvl842/monokai-pro.nvim",
        lazy = false,
        priority = 1000,
        opts = { },
    },

    {
        "nyoom-engineering/oxocarbon.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
    },

    {
        "scottmckendry/cyberdream.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {
            overrides = function(colors)
                -- Example:
                return {
                    -- Comment = { fg = colors.green, bg = "NONE", italic = true },
                    -- ["@property"] = { fg = colors.magenta, bold = true },
                    TelescopeBorder = { fg = colors.bg_alt, bg = colors.bg_alt },
                    TelescopeNormal = { bg = colors.bg_alt },
                    TelescopePreviewBorder = { fg = colors.bg_alt, bg = colors.bg_alt },
                    TelescopePreviewNormal = { bg = colors.bg_alt },
                    TelescopePreviewTitle = { fg = colors.bg_alt, bg = colors.green, bold = true },
                    TelescopeResultsBorder = { fg = colors.bg_alt, bg = colors.bg_alt },
                    TelescopeResultsNormal = { bg = colors.bg_alt },
                    TelescopePromptPrefix = { fg = colors.blue, bg = colors.bg_alt },
                    TelescopePromptCounter = { fg = colors.cyan, bg = colors.bg_alt },
                    TelescopePromptTitle = { fg = colors.bg_alt, bg = colors.blue, bold = true },
                    TelescopeResultsTitle = { fg = colors.blue, bg = colors.bg_alt, bold = true },
                }
            end,
        },
    },

    { -- nightfly
        "bluz71/vim-nightfly-colors",
        name = "nightfly",
        lazy = false,
        priority = 1000,
    },

    {
        "sponkurtus2/angelic.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    { -- poimandres
        "olivercederborg/poimandres.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            bold_vert_split = true, -- use bold vertical separators
        },
    },

    { -- nordic
        "AlexvZyl/nordic.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            telescope = {
                -- Available styles: `classic`, `flat`.
                style = "flat",
            },
        },
    },

    { -- gruvbox
        "ellisonleao/gruvbox.nvim",
        enabled = false,
        priority = 1000,
        config = true,
        opts = {},
    },

    { -- eldritch
        "eldritch-theme/eldritch.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    { -- moonfly
        "bluz71/vim-moonfly-colors",
        lazy = false,
        priority = 1000,
    },

    { -- solarized-osaka
        "craftzdog/solarized-osaka.nvim",
        priority = 1000,
        opts = {
            transparent = false,
        },
    },

    { -- ayu
        "Shatur/neovim-ayu",
        priority = 1000,
        opts = {},
        config = function()
            require("ayu").setup {
                mirage = true,
                terminal = false,
                overrides = {
                    CursorLineNr = { bg = "None" },
                },
            }
        end,
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
                    SnacksPickerListTitle = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    SnacksPickerTitle = { fg = theme.ui.bg_p1, bold = true },
                    SnacksPickerInput = { bg = theme.ui.bg_p1 },
                    SnacksPickerInputTitle = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    SnacksPickerInputBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    SnacksPickerList = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    SnacksPickerListBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    SnacksPickerPreview = { bg = theme.ui.bg_dim },
                    SnacksPickerPreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    SnacksPickerPreviewTitle = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
                    SnacksPickerToggle = { bg = theme.ui.bg_p1, fg = theme.ui.bg_p1 },

                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },

                    DiagnosticFloatingError = { fg = theme.diag.error, bg = "NONE" },
                    DiagnosticFloatingWarn = { fg = theme.diag.warning, bg = "NONE" },
                    DiagnosticFloatingInfo = { fg = theme.diag.info, bg = "NONE" },
                    DiagnosticFloatingHint = { fg = theme.diag.hint, bg = "NONE" },
                    DiagnosticFloatingOk = { fg = theme.diag.ok, bg = "NONE" },

                    DiagnosticUnderlineWarn = { sp = theme.diag.warning, undercurl = true },
                    DiagnosticUnderlineError = { sp = theme.diag.error, undercurl = true },
                    DiagnosticUnderlineHint = { sp = theme.diag.hint, undercurl = true },
                    DiagnosticUnderlineInfo = { sp = theme.diag.info, undercurl = true },
                }
            end,
        },
    },

    { -- everforest
        "sainnhe/everforest",
        name = "everforest",
        priority = 1000,
        config = function()
            vim.g.everforest_better_performance = 1
            vim.g.everforest_transparent_background = 0
        end,
    },

    { -- sonokai
        "sainnhe/sonokai",
        priority = 1000,
        config = function()
            --- @type "default"|"atlantis"|"andromeda"|"shusia"|"maia"|"espresso"
            vim.g.sonokai_style = "shusia"
        end,
    },

    { -- catppuccin
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup {
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                color_overrides = {},
                transparent_background = false,
                default_integrations = true,
                highlight_overrides = {
                    all = function(colors)
                        return {
                            -- Borderless telescope
                            TelescopeBorder = {
                                fg = colors.mantle,
                                bg = colors.mantle,
                            },
                            TelescopeMatching = { fg = colors.blue },
                            TelescopeNormal = {
                                bg = colors.mantle,
                            },
                            TelescopePromptBorder = {
                                fg = colors.surface0,
                                bg = colors.surface0,
                            },
                            TelescopePromptNormal = {
                                fg = colors.text,
                                bg = colors.surface0,
                            },
                            TelescopePromptPrefix = {
                                fg = colors.flamingo,
                                bg = colors.surface0,
                            },
                            TelescopePreviewTitle = {
                                fg = colors.base,
                                bg = colors.green,
                            },
                            TelescopePromptTitle = {
                                fg = colors.base,
                                bg = colors.red,
                            },
                            TelescopeResultsTitle = {
                                fg = colors.mantle,
                                bg = colors.lavender,
                            },
                            TelescopeSelection = {
                                fg = colors.text,
                                bg = colors.surface0,
                                style = { "bold" },
                            },
                            TelescopeSelectioncolorsaret = { fg = colors.flamingo },

                            -- Borderless Snacks picker
                            SnacksPickerBorder = {
                                fg = colors.mantle,
                                bg = colors.mantle,
                            },
                            SnacksPicker = {
                                bg = colors.mantle,
                            },
                            SnacksPickerInput = {
                                fg = colors.text,
                                bg = colors.surface0,
                            },
                            SnacksPickerInputBorder = {
                                fg = colors.surface0,
                                bg = colors.surface0,
                            },
                            SnacksPickerListCursorLine = {
                                fg = colors.text,
                                bg = colors.surface0,
                            },
                            SnacksPickerToggle = {
                                fg = colors.surface0,
                                bg = colors.surface0,
                            },

                            -- Titles
                            -- SnacksPickerPreviewTitle = {
                            --     fg = colors.base,
                            --     bg = colors.green,
                            -- },
                            -- SnacksPickerInputTitle = {
                            --     fg = colors.base,
                            --     bg = colors.red,
                            -- },
                            -- SnacksPickerListTitle = {
                            --     fg = colors.mantle,
                            --     bg = colors.lavender,
                            -- },

                            SnacksPickerPreviewTitle = {
                                fg = colors.mantle,
                                bg = colors.mantle,
                            },
                            SnacksPickerInputTitle = {
                                fg = colors.surface0,
                                bg = colors.surface0,
                            },
                            SnacksPickerListTitle = {
                                fg = colors.mantle,
                                bg = colors.mantle,
                            },
                        }
                    end,
                },
            }
        end,
    },

    {
        "killitar/obscure.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    {
        "alexmozaidze/palenight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    { -- gruvbox-material
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_transparent_background = 0
            vim.g.gruvbox_material_foreground = "mix"
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_ui_contrast = "high"
            vim.g.gruvbox_material_float_style = "bright"
            vim.g.gruvbox_material_statusline_style = "material"
            vim.g.gruvbox_material_cursor = "auto"
        end,
    },

    { -- vscode
        "Mofiqul/vscode.nvim",
        name = "vscode-theme",
        priority = 1000,
        config = function()
            require("vscode").setup {
                disable_nvimtree_bg = true,
                transparent = false,
            }
        end,
    },

    { -- tokyonight
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
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

                -- Snacks picker
                hl.SnacksPicker = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.SnacksPickerBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.SnacksPickerInput = {
                    bg = prompt,
                }
                hl.SnacksPickerInputBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.SnacksPickerInputTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.SnacksPickerPreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.SnacksPickerListTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.SnacksPickerToggle = {
                    bg = prompt,
                    fg = prompt,
                }
            end,
            plugins = {
                all = package.loaded.lazy == nil,
                auto = true,
            },
        },
    },
}
