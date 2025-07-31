return {
    -- Splits line into multiple ones
    {
        "Wansmer/treesj",
        version = "*",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = { "TSJToggle" },
        keys = {
            {
                "<leader>m",
                "<cmd>TSJToggle<CR>",
                desc = "Join Toggle",
                mode = "n",
            },
        },
        config = function()
            require("treesj").setup {
                use_default_keymaps = false,
            }
        end,
    },
}
