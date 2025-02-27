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
            dashboard = { enabled = false },
            indent = { enabled = false, only_current = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
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
        config = function()
            require("core.mappings").bufferline()
            return require "configs.bufferline-nvim"
        end,
    },

    {
        "b0o/incline.nvim",
        event = "BufReadPre",
        config = function()
            require("incline").setup {
                highlight = {
                    groups = {
                        InclineNormal = { guibg = "#303270", guifg = "#a9b1d6" },
                        InclineNormalNC = { guibg = "none", guifg = "#a9b1d6" },
                    },
                },
                window = { margin = { vertical = 0, horizontal = 1 } },
                hide = { cursorline = true, only_win = true },
                render = function(props)
                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                    if vim.bo[props.buf].modified then
                        filename = "[*]" .. filename
                    end

                    local icon, color = require("nvim-web-devicons").get_icon_color(filename)

                    return { { icon, guifg = color }, { " " }, { filename } }
                end,
            }
        end,
    },

    -- Line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        -- enabled = false,
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        config = function()
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

    -- File explorer
    -- (switched because nvim-tree decided to hide .env files)
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            return require "configs.neo-tree"
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
        enabled = true,
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
        enabled = false,
        event = "VeryLazy",
        config = function()
            require("nvim-highlight-colors").setup {
                -- render = "virtual",
                virtual_symbol_position = "eow",
                virtual_symbol = " ",
                virtual_symbol_prefix = " ",
                virtual_symbol_suffix = "",
                exclude_buftypes = {},
                exclude_filetypes = { "NvimTree", "TelescopePrompt", "TelescopeResults", "lazy", "mason", "neo-tree" },
            }
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        lazy = false,
        opts = {
            filetypes = {
                "*", -- Highlight all files, but customize some others.
                css = { names = true },
                html = { names = true },
                javascriptreact = { names = true },
                typescriptreact = { names = true },
            },
            user_default_options = {
                names = false,
                tailwind = true,
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS *features*:
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
            width = 115,
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
}
