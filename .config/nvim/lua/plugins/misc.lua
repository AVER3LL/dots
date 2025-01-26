return {

    {
        "karb94/neoscroll.nvim",
        -- enabled = not vim.g.neovide,
        enabled = false,
        keys = { "<C-d>", "<C-u>", "<C-e>", "<C-y>", "zz" },
        config = function()
            require("neoscroll").setup {
                stop_eof = true,
                easing_function = "sine",
                hide_cursor = true,
                cursor_scrolls_alone = true,
            }
        end,
    },

    {
        "danymat/neogen",
        cmd = "Neogen",
        config = function()
            require("core.mappings").neogen()
            require("neogen").setup {
                snippet_engine = "luasnip",
                languages = {
                    python = {
                        template = {
                            annotation_convention = "reST",
                        },
                    },
                },
            }
        end,
        version = "*",
    },
}
