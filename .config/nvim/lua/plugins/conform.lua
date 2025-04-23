return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require "conform"
        conform.setup {
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
                -- dart = { "ast-grep" },
                ["_"] = { "trim_whitespace", "trim_newlines" },
            },

            formatters = {
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
                    cwd = require("conform.util").root_file {
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
                        -- "--tab-width",
                        -- "4",
                        -- "--print-width",
                        -- "120",
                        -- "--single-quote",
                        -- "--html-whitespace-sensitivity",
                        -- "ignore",
                        -- "--single-attribute-per-line",
                        -- "false",
                    },
                },
            },

            -- format_on_save = {
            --   -- These options will be passed to conform.format()
            --   timeout_ms = 500,
            --   lsp_fallback = true,
            -- },
        }
    end,
}
