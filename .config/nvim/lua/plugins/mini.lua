return {

    {
        "echasnovski/mini.surround",
        opts = {},
    },

    {
        "echasnovski/mini.trailspace",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            only_in_normal_buffers = true,
        },
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
        event = "BufReadPre",
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        opts = function()
            local miniai = require "mini.ai"
            return {
                n_lines = 300,
                custom_textobjects = {
                    f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    d = { "%f[%d]%d+" }, -- digits
                    i = miniai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
                    l = miniai.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }, {}),
                    g = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line "$",
                            col = math.max(vim.fn.getline("$"):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
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
