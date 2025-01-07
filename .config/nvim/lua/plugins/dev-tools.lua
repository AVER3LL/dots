return {
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },

    {
        "mikavilpas/yazi.nvim",
        enabled = false,
        cmd = "Yazi",
        opts = {},
    },

    -- Lua
    -- {
    --     "folke/zen-mode.nvim",
    --     enabled = false,
    --     opts = {},
    -- },

    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
        },
    },

    -- {
    --     "m4xshen/hardtime.nvim",
    --     enabled = false,
    --     dependencies = { "MunifTanjim/nui.nvim" },
    --     opts = {},
    -- },
}
