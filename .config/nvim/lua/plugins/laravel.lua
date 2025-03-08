return {
    {
        "ricardoramirezr/blade-nav.nvim",
        enabled = false,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        ft = { "blade", "php" },
    },

    {
        "adalessa/laravel.nvim",
        dependencies = {
            "tpope/vim-dotenv",
            "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
            "kevinhwang91/promise-async",
        },
        cmd = { "Laravel" },
        keys = {
            { "<leader>la", ":Laravel artisan<cr>" },
            { "<leader>lr", ":Laravel routes<cr>" },
            { "<leader>lm", ":Laravel related<cr>" },
            {
                "gf",
                function()
                    if require("laravel").app("gf").cursor_on_resource() then
                        return "<cmd>Laravel gf<CR>"
                    else
                        return "gf"
                    end
                end,
                noremap = false,
                expr = true,
            },
        },
        opts = {
            lsp_server = "intelephense",
        },
    },
}
