return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup {
                preview_config = {
                    border = require("config.looks").border_type(),
                },
                signs = {
                    add = { text = " ▎" },
                    change = { text = " ▎" },
                    delete = { text = " " },
                    topdelete = { text = " " },
                    changedelete = { text = " ▎" },
                    untracked = { text = " ▎" },
                },
                signs_staged = {
                    add = { text = " ▎" },
                    change = { text = " ▎" },
                    delete = { text = " " },
                    topdelete = { text = " " },
                    changedelete = { text = " ▎" },
                },
            }
        end,
    },
}
