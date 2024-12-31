return {
    "linux-cultist/venv-selector.nvim",
    -- event = "VeryLazy",
    ft = "python",
    dependencies = {
        "neovim/nvim-lspconfig",
        { "mfussenegger/nvim-dap", lazy = true },
        { "mfussenegger/nvim-dap-python", lazy = true }, --optional
        { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function()
        require("venv-selector").setup {
            settings = {
                search = {
                    -- Keep the default searches
                    -- Add our custom search
                    custom_search = {
                        command = [[fd '(python|python3)$' . .. ../.. -H --full-path --color never]],
                    },
                },
                options = {
                    -- Enable this to see debug information
                    debug = true,
                },
            },
        }
    end,
}
