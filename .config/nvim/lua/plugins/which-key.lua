local bt = require("config.looks").border_type()
return {

    -- Helps manage keymaps
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- classic, modern, helix
            preset = "helix",
            win = {
                border = bt,
            },
        },
    },
}
