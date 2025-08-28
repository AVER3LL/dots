return {
    -- Better comments somehow
    {
        "nvim-mini/mini.comment",
        event = { "BufReadPre", "BufNewFile" },
        version = false,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            -- disable the autocommand from ts-context-commentstring
            require("ts_context_commentstring").setup {
                enable_autocmd = false,
            }

            require("mini.comment").setup {
                -- tsx, jsx, html , svelte comment support
                options = {
                    custom_commentstring = function()
                        return require("ts_context_commentstring.internal").calculate_commentstring {
                            key = "commentstring",
                        } or vim.bo.commentstring
                    end,
                },
            }
        end,
    },

    -- Colored comments because monke brain
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>ft",
                function()
                    ---@diagnostic disable-next-line: undefined-field
                    Snacks.picker.todo_comments { keywords = { "TODO", "FIX", "FIXME", "NOTE" } }
                end,
                desc = "Todo/Fix/Fixme",
            },
        },
        opts = {
            signs = true,
            keywords = {
                TWEAK = { icon = "󰖷", color = "info" },
            },
        },
    },
}
