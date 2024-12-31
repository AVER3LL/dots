return {

    -- Greeter
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            return require "configs.alpha-nvim"
        end,
    },

    -- Tab bar
    {
        "akinsho/bufferline.nvim",
        -- enabled = false,
        version = "*",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            return require "configs.bufferline-nvim"
        end,
    },

    -- Line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        -- enabled = false,
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            return require "configs.lualine"
        end,
    },

    -- Sensible buffer delete options
    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy",
    },

    -- indentation marks
    {
        "lukas-reineke/indent-blankline.nvim",
        -- enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        main = "ibl",
        config = function()
            return require "configs.indent-blankline"
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            return require "configs.nvim-tree"
        end,
    },

    -- Vertical line
    {
        "lukas-reineke/virt-column.nvim",
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
        event = "LspAttach",
        enabled = true,
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
        config = function()
            require("nvim-highlight-colors").setup {
                -- render = "virtual",
                virtual_symbol_position = "eow",
                virtual_symbol = " ",
                virtual_symbol_prefix = " ",
                virtual_symbol_suffix = "",
                exclude_buftypes = {},
                exclude_filetypes = { "NvimTree", "TelescopePrompt", "TelescopeResults", "lazy", "mason" },
            }
        end,
    },

    -- Breadcrumbs
    {
        "utilyre/barbecue.nvim",
        -- enabled = false,
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
        "Wansmer/symbol-usage.nvim",
        enabled = false,
        event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
        config = function()
            return require "configs.symbol-usage"
        end,
    },

    {
        "VidocqH/lsp-lens.nvim",
        enabled = false,
        event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
        opts = {},
    },

    {
        "nvchad/showkeys",
        cmd = "ShowkeysToggle",
        opts = {
            timeout = 1,
            maxkeys = 6,
            -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
            position = "bottom-right",
        },
    },
}
