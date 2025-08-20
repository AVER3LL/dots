return {

    -- Helps manage keymaps
    {
        "folke/which-key.nvim",
        -- event = "VeryLazy",
        opts = {
            -- classic, modern, helix
            preset = "helix",
            delay = 100,
            win = {
                border = tools.border,
            },
        },
    },
}
