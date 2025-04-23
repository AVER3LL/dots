return {
    {
        "Exafunction/codeium.vim",
        enabled = false,
        event = "BufEnter",
        config = function()
            vim.keymap.set("i", "<C-o>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })
        end,
    },

    {
        "supermaven-inc/supermaven-nvim",
        enabled = false,
        config = function()
            require("supermaven-nvim").setup {
                keymaps = {
                    accept_suggestion = "<C-o>",
                    clear_suggestion = "<C-]>",
                    accept_word = "<C-e>",
                },
            }
        end,
    },
}
