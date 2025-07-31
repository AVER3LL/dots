return {
    {
        "rmagatti/auto-session",
        event = "VeryLazy",
        keys = {
            "<leader>wr",
            "<cmd>SessionRestore<CR>",
            desc = "Session search",
        },
        opts = {
            auto_save = true,
            auto_create = true,
            auto_restore = false,
            lazy_support = true,
            suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
        },
    },
}
