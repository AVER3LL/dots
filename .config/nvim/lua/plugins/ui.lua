return {

    {
        "nvim-tree/nvim-web-devicons",
        opts = {},
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

    -- Colored parenthesis
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
    },

    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
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

    -- Lsp messages on the top right like Helix
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
}
