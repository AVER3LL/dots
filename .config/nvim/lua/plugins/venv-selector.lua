return {
    "linux-cultist/venv-selector.nvim",
    -- event = "VeryLazy",
    ft = "python",
    dependencies = {
        "neovim/nvim-lspconfig",
        { "mfussenegger/nvim-dap" },
        { "mfussenegger/nvim-dap-python" }, --optional
        { "nvim-telescope/telescope.nvim" },
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
