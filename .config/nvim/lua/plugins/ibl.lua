return {

    -- indentation marks
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = true,
        event = "VeryLazy",
        dependencies = "tpope/vim-sleuth",
        main = "ibl",
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
            indent = { char = "│", smart_indent_cap = true },
            scope = { enabled = false, char = "│", show_start = false, show_end = false },
        },
    },
}
