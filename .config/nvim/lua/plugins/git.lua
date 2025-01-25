return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup {
                preview_config = {
                    border = require("config.looks").border_type(),
                },
            }
        end,
    },
}
