return {
    {
        "rmagatti/auto-session",
        keys = {
            { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Session search" },
        },
        config = function()
            local auto_session = require "auto-session"

            auto_session.setup {
                auto_restore = false,
                suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
            }
        end,
    },
}
