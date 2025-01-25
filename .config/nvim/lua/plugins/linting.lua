return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require "lint"

        lint.linters_by_ft = {

            python = {
                -- "ruff",
                "mypy",
            },

            php = { "phpstan" },

            htmldjango = { "djlint" },

            -- java = { "checkstyle" },

            -- lua = { "luacheck" },
            -- c = { "cpplint" },
            -- cpp = { "cpplint" },
            -- javascript = { "eslint" },
            -- typescript = { "eslint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
