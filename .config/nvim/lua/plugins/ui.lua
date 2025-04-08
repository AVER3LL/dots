return {

    -- Greeter
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            return require "configs.alpha-nvim"
        end,
    },

    -- Hide fold level numbers
    {
        "luukvbaal/statuscol.nvim",
        opts = function()
            local builtin = require "statuscol.builtin"
            return {
                setopt = true,
                -- override the default list of segments with:
                -- number-less fold indicator, then signs, then line number & separator
                segments = {
                    { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                    { text = { "%s" }, click = "v:lua.ScSa" },
                    {
                        text = { builtin.lnumfunc, " " },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScLa",
                    },
                },
            }
        end,
    },

    -- {
    --     "echasnovski/mini.icons",
    --     opts = {},
    --     lazy = true,
    --     specs = {
    --         { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    --     },
    --     init = function()
    --         package.preload["nvim-web-devicons"] = function()
    --             require("mini.icons").mock_nvim_web_devicons()
    --             return package.loaded["nvim-web-devicons"]
    --         end
    --     end,
    -- },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            dashboard = { enabled = false },
            indent = { enabled = false, only_current = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            terminal = {
                win = {
                    style = "terminal",
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                },
            },
        },
    },

    -- Tab bar
    {
        "akinsho/bufferline.nvim",
        enabled = false,
        version = "*",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {},
    },

    {
        "b0o/incline.nvim",
        enabled = false,
        event = "BufReadPre",
        config = function()
            require("incline").setup {
                window = {
                    margin = { vertical = 0, horizontal = 0 },
                    placement = {
                        horizontal = "center",
                        vertical = "top",
                    },
                    overlap = {
                        winbar = false,
                    },
                    width = "fit",
                },
                hide = { cursorline = false, only_win = false },

                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                    if vim.bo[props.buf].modified then
                        filename = "[*]" .. filename
                    end

                    local function get_diagnostic_label()
                        local icons = { error = " ", warn = " ", info = " ", hint = "H " }
                        local label = {}

                        for severity, icon in pairs(icons) do
                            local n = #vim.diagnostic.get(
                                props.buf,
                                { severity = vim.diagnostic.severity[string.upper(severity)] }
                            )
                            if n > 0 then
                                table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
                            end
                        end
                        if #label > 0 then
                            table.insert(label, { " " })
                        end
                        return label
                    end

                    local icon, color = require("nvim-web-devicons").get_icon_color(filename)

                    return { { icon, guifg = color }, { " " }, { filename }, { " " }, { get_diagnostic_label() } }
                end,
            }
        end,
    },

    -- Line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function()
            vim.opt.laststatus = 0
            vim.g.lualine_laststatus = 0
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        config = function()
            vim.opt.laststatus = 0
            vim.g.lualine_laststatus = 0
            return require "configs.lualine"
        end,
    },

    -- Sensible buffer delete options
    {
        "famiu/bufdelete.nvim",
        enabled = false,
        event = "VeryLazy",
    },

    -- indentation marks
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        main = "ibl",
        config = function()
            return require "configs.indent-blankline"
        end,
    },

    {
        "shellRaining/hlchunk.nvim",
        enabled = vim.g.show_indent,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local squared_chars = {
                horizontal_line = "─",
                vertical_line = "│",
                left_top = "┌",
                left_bottom = "└",
                right_arrow = "─",
            }
            local rounded_chars = {
                horizontal_line = "─",
                vertical_line = "│",
                left_top = "╭",
                left_bottom = "╰",
                right_arrow = ">",
            }
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                    delay = 0,
                    error_sign = false,
                    chars = require("config.looks").border_type() == "rounded" and rounded_chars or squared_chars,
                },
                indent = { enable = true },
                line_num = { enable = false },
                blank = { enable = false },
            }
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
                vim.keymap.set("n", "s", api.node.open.vertical, opts "Open in vertical split")
                vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
            end
            require("nvim-tree").setup {
                on_attach = my_on_attach,
                filters = { dotfiles = false, exclude = { ".env" } },
                disable_netrw = true,
                hijack_cursor = true,
                sync_root_with_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
                view = {
                    width = 32,
                    preserve_window_proportions = true,
                },
                renderer = {
                    root_folder_label = false,
                    highlight_git = true,
                    indent_markers = { enable = false },
                    icons = {
                        glyphs = {
                            default = "󰈚",
                            folder = {
                                default = "",
                                empty = "",
                                empty_open = "",
                                open = "",
                                symlink = "",
                            },
                            git = { unmerged = "" },
                        },
                    },
                },
            }
        end,
    },

    -- Vertical line
    {
        "lukas-reineke/virt-column.nvim",
        enabled = true,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            char = { "┆" },
            highlight = { "NonText" },
        },
    },

    -- Better ui somehow
    {
        "stevearc/dressing.nvim",
        enabled = false,
        opts = {
            input = {
                relative = "cursor",
                prefered_width = 50,
                win_options = {
                    sidescrolloff = 2,
                },
            },
        },
    },

    -- Lsp percentages and shit
    {
        "j-hui/fidget.nvim",
        enabled = false,
        event = "LspAttach",
        opts = {
            -- options
        },
    },

    -- Colored parenthesis
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
    },

    -- Lsp messages on the top right
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
                scope = "line",
                padding_right = 2,
                enable = function()
                    return not vim.tbl_contains(excluded_filetypes, vim.bo.filetype)
                end,
            }
        end,
    },

    -- css colors highlighting
    {
        "brenoprata10/nvim-highlight-colors",
        enabled = true,
        event = "VeryLazy",
        config = function()
            require("nvim-highlight-colors").setup {
                render = "virtual",
                virtual_symbol_position = "inline",
                -- virtual_symbol = " ",
                virtual_symbol = "󱓻",
                virtual_symbol_prefix = "",
                virtual_symbol_suffix = " ",
                enable_tailwind = true,
                exclude_buftypes = {},
                exclude_filetypes = { "NvimTree", "TelescopePrompt", "TelescopeResults", "lazy", "mason", "neo-tree" },
            }
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        lazy = false,
        enabled = false,
        opts = {
            filetypes = {
                "*", -- Highlight all files, but customize some others.
                css = {
                    names = true,
                    rgb_fn = true, -- CSS rgb() and rgba() functions #FFF
                    hsl_fn = true, -- CSS hsl() and hsla() functions
                    css = true, -- Enable all CSS *features*:
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                },
                html = { names = true },
                javascriptreact = { names = true },
                typescriptreact = { names = true },
            },
            user_default_options = {
                mode = "virtualtext",
                virtualtext = "󱓻",
                virtualtext_inline = "before",
                names = false,
                tailwind = true,
            },
        },
    },

    -- Breadcrumbs
    {
        "utilyre/barbecue.nvim",
        enabled = false,
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        config = function()
            return require "configs.barbecue"
        end,
    },

    {
        "shortcuts/no-neck-pain.nvim",
        cmd = "NoNeckPain",
        version = "*",
        opts = {
            width = 120,
            autocmds = { -- Better autocmd configuration
                enableOnVimEnter = false, -- Enable when Vim starts
                reloadOnColorSchemeChange = true,
            },
        },
    },

    {
        "nvchad/showkeys",
        enabled = false,
        cmd = "ShowkeysToggle",
        opts = {
            timeout = 1,
            maxkeys = 6,
            -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
            position = "bottom-right",
        },
    },

    {
        "kevinhwang91/nvim-ufo",
        enabled = false,
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            require("ufo").setup {
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
            }
        end,
    },
}
