return {

    {
        "echasnovski/mini.surround",
        opts = {},
    },

    {
        "echasnovski/mini.trailspace",
        opts = {},
    },

    {
        "echasnovski/mini.statusline",
        enabled = false,
        opts = {},
    },

    {
        "echasnovski/mini.misc",
        version = "*",
        config = function()
            require("mini.misc").setup()
            require("mini.misc").setup_termbg_sync()
            require("mini.misc").setup_restore_cursor()
        end,
    },

    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        opts = function()
            local miniai = require "mini.ai"
            return {
                n_lines = 300,
                custom_textobjects = {
                    f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    d = { "%f[%d]%d+" }, -- digits
                    i = miniai.gen_spec.treesitter { a = "@conditional.outer", i = "@conditional.inner" },
                    l = miniai.gen_spec.treesitter { a = "@loop.outer", i = "@loop.inner" },
                },
                -- Disable error feedback.
                silent = true,
                -- Don't use the previous or next text object.
                search_method = "cover",
                mappings = {
                    around = "a",
                    inside = "i",
                    around_next = "an",
                    inside_next = "in",
                    around_last = "al",
                    inside_last = "il",
                    goto_left = "[",
                    goto_right = "]",
                },
            }
        end,
    },
}
