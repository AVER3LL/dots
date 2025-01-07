return {
    {
        "rmagatti/auto-session",
        enabled = false,
        -- event = "VeryLazy",
        config = function()
            local auto_session = require "auto-session"

            auto_session.setup {
                auto_restore = false,
                suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
            }
        end,
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        config = function()
            require("persistence").setup()
            vim.keymap.set("n", "<leader>wr", function()
                require("persistence").load()
            end)
        end,
    },
}
