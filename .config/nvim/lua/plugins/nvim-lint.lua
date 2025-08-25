return {

    ---@module 'lazy'
    ---@type LazySpec
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require "lint"

            lint.linters_by_ft = {

                -- lua = { "luacheck" },

                -- python = { "mypy" },

                php = { "phpstan" },

                vue = { "biomejs" },
                javascript = { "biomejs" },
                typescript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescriptreact = { "biomejs" },

                kotlin = { "ktlint" },

                htmldjango = { "djlint" },
            }

            -- https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/luacheck.lua
            -- Only added the vim global in the luacheck args table
            local pattern = "[^:]+:(%d+):(%d+)-(%d+): %((%a)(%d+)%) (.*)"
            local groups = { "lnum", "col", "end_col", "severity", "code", "message" }
            local severities = {
                W = vim.diagnostic.severity.WARN,
                E = vim.diagnostic.severity.ERROR,
            }

            ---@diagnostic disable-next-line: missing-fields
            lint.linters.luacheck = {
                cmd = "luacheck",
                stdin = true,
                args = { "--globals", "vim", "Snacks", "tools", "--formatter", "plain", "--codes", "--ranges", "-" },
                ignore_exitcode = true,
                parser = require("lint.parser").from_pattern(
                    pattern,
                    groups,
                    severities,
                    { ["source"] = "luacheck" },
                    { end_col_offset = 0 }
                ),
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    if vim.bo.modifiable then
                        lint.try_lint()
                    end
                end,
            })

            vim.keymap.set("n", "<leader>lt", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })

            require "mason-nvim-lint"
        end,
    },

    ---@module 'lazy'
    ---@type LazySpec
    {
        "rshkarin/mason-nvim-lint",
        lazy = true,
        opts = {
            ignore_install = { "biomejs", "ktlint" },
        },
    },
}
