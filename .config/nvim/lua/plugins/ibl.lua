return {

    {
        "saghen/blink.indent",
        enabled = false,
        --- @module 'blink.indent'
        --- @type blink.indent.Config
        opts = {
            scope = { enabled = false, highlights = { "BlinkIndent" } },
            static = { enabled = true },
        },
    },

    -- indentation marks
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = true,
        event = "VeryLazy",
        -- dependencies = "tpope/vim-sleuth",
        main = "ibl",
        keys = {
            {
                mode = { "n", "v" },
                "<leader><leader>i",
                "<cmd>IBLToggle<cr>",
                desc = "Toggle indent lines",
            },
        },
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            exclude = {
                filetypes = {
                    "help",
                    "lazy",
                    "mason",
                    "notify",
                    "oil",
                    "lazy",
                    "NvimTree",
                    "terminal",
                    "lspinfo",
                    "TelescopePrompt",
                    "TelescopeResults",
                    "Trouble",
                    "trouble",
                    "toggleterm",
                    "alpha",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                    "prompt",
                },
            },
            -- Toggling it with a keybinding if need be
            enabled = false,
            indent = { char = "│", smart_indent_cap = true },
            scope = { enabled = true, char = "│", show_start = true, show_end = true },
        },
    },
}
