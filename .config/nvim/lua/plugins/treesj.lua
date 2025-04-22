return {
    -- Splits line into multiple ones
    {
        "Wansmer/treesj",
        keys = {
            {
                "<leader>m",
                "<cmd>TSJToggle<CR>",
                desc = "Join Toggle",
                mode = "n",
            },
        },
        cmd = { "TSJToggle" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesj").setup {
                use_default_keymaps = false,
            }
        end,
        version = "*",
    },
}
