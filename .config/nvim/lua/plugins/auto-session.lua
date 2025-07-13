return {
    {
        "rmagatti/auto-session",
        keys = {
            "<leader>wr",
            "<cmd>SessionRestore<CR>",
            desc = "Session search",
        },
        cmd = { "SessionRestore" },
        opts = {
            auto_restore = false,
            suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
        },
    },
}
