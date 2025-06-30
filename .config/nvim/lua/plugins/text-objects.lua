return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            local map = require("utils").map
            require("nvim-treesitter.configs").setup {
                textobjects = {
                    select = {
                        enable = false,

                        lookahead = true,

                        keymaps = {
                            ["al"] = { query = "@loop.outer", desc = "Around loop" },
                            ["il"] = { query = "@loop.inner", desc = "Inside loop" },
                        },
                    },
                    move = {
                        enable = false,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = { query = "@function.outer", desc = "Next function start" },
                            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                            ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                        },
                        goto_next_end = {
                            ["]F"] = { query = "@function.outer", desc = "Next function end" },
                            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                            ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                        },
                        goto_previous_start = {
                            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                            ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
                            ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
                        },
                        goto_previous_end = {
                            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                            ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
                            ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
                        },
                    },
                },
            }
            local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

            -- Repeat movement with ; and ,
            -- ensure ; goes forward and , goes backward regardless of the last direction
            -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

            -- vim way: ; goes to the direction you were moving.
            map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
            map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

            -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
            map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
}
