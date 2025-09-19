return {
    {
        "rmagatti/auto-session",
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            auto_save = true,
            auto_create = true,
            auto_restore = false,
            lazy_support = true,
            bypass_save_filetype = { "alpha" },
            suppressed_dirs = { "~/", "~/Projects/", "~/Downloads", "~/Documents", "~/Desktop/" },
            post_restore_cmds = {
                function()
                    require("config.winbar").refresh_all_windows()
                end,
            },
        },
        config = function(_, opts)
            require("auto-session").setup(opts)

            vim.keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<cr>")
        end,
    },
}
