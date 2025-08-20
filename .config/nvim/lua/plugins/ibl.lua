return {

    -- indentation marks
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = true,
        -- event = "VeryLazy",
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
            scope = { enabled = false, char = "│", show_start = false, show_end = false },
        },
    },
}
