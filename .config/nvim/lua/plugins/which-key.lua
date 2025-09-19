return {

    -- Helps manage keymaps
    {
        "folke/which-key.nvim",
        enabled = true,
        -- event = "VeryLazy",
        opts = {
            -- classic, modern, helix
            preset = "helix",
            delay = 10,
            win = {
                border = tools.border,
            },
        },
    },
}
