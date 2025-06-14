return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
        local util = require "conform.util"

        ---@type conform.setupOpts
        local opts = {
            formatters_by_ft = {
                css = { "prettier" },
                html = { "prettier" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                vue = { "prettier" },
                typescriptreact = { "prettier" },
                markdown = { "doctoc", "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                lua = { "stylua" },
                -- python = { "isort", "black" },
                python = { "ruff_organize_imports", "ruff_format" },
                -- python = { "autopep8" },
                htmldjango = { "djlint" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                toml = { "taplo" },
                sh = { "shfmt" },
                php = { "pint", "php_cs_fixer" },
                java = { "google-java-format" },
                blade = { "blade-formatter" },
                kotlin = { "ktlint" },
                latex = { "latexindent" },
                go = { "goimports-reviser", "gofumpt" },
                rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
                ["_"] = { "trim_whitespace", "trim_newlines" },
            },

            formatters = {
                pint = {
                    meta = {
                        url = "https://github.com/laravel/pint",
                        description = "Laravel Pint is an opinionated PHP code style fixer for minimalists. Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that your code style stays clean and consistent.",
                    },
                    command = util.find_executable({
                        vim.fn.stdpath "data" .. "/mason/bin/pint",
                        "vendor/bin/pint",
                    }, "pint"),
                    args = { "$FILENAME" },
                    stdin = false,
                },
                --python
                black = {
                    prepend_args = {
                        "--fast",
                        "--line-length",
                        "79",
                    },
                },

                ["clang-format"] = {
                    prepend_args = { "--style={IndentWidth: 4, TabWidth: 4, UseTab: Never}" },
                },

                isort = {
                    prepend_args = {
                        "--profile",
                        "black",
                    },
                },

                ruff_format = {
                    inherit = false,
                    command = "ruff",
                    args = {
                        "format",
                        "--quiet",
                        "--force-exclude",
                        -- "--line-length",
                        -- "79",
                        "--stdin-filename",
                        "$FILENAME",
                        "-",
                    },
                    stdin = true,
                    cwd = util.root_file {
                        "pyproject.toml",
                        "ruff.toml",
                        ".ruff.toml",
                    },
                },

                ["google-java-format"] = {
                    inherit = false,
                    command = "google-java-format",
                    args = {
                        "--aosp",
                        "-",
                    },
                    stdin = true,
                },

                prettier = {
                    prepend_args = {
                        "--tab-width",
                        "4",
                        "--print-width",
                        "120",
                        "--single-quote",
                        "--html-whitespace-sensitivity",
                        "ignore",
                        "--single-attribute-per-line",
                        "false",
                    },
                },
            },
        }

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format { async = true, lsp_format = "fallback", range = range }
        end, { range = true })

        return opts
    end,
}
