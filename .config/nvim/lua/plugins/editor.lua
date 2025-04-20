return {
    -- Better comments somehow
    {
        "numToStr/Comment.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            local comment = require "Comment"
            local ts_context_commentstring = require "ts_context_commentstring.integrations.comment_nvim"
            ---@diagnostic disable-next-line: missing-fields
            comment.setup {
                pre_hook = ts_context_commentstring.create_pre_hook(),
            }
        end,
    },

    -- Colored comments because monke brain
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = true,
            keywords = {
                TWEAK = { icon = "󰖷", color = "info" },
            },
        },
    },

}
