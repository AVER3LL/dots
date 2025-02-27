return {
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },

    {
        "isak102/ghostty.nvim",
        ft = "ghostty",
        config = function()
            require("ghostty").setup()
        end,
    },

    {
        "mikavilpas/yazi.nvim",
        enabled = false,
        cmd = "Yazi",
        opts = {},
    },

    {
        "christoomey/vim-tmux-navigator",
        enabled = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
        },
    },
}
