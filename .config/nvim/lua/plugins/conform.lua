return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format {
                        async = true,
                        lsp_format = "fallback",
                        timeout_ms = 1000,
                    }
                end,
                mode = { "n", "v" },
                desc = "Format buffer",
            },
        },
        opts = function()
            local util = require "conform.util"

            ---@type conform.setupOpts
            local opts = {
                notify_on_error = false,
                formatters_by_ft = {
                    css = { "biome" },
                    html = { "biome" },
                    javascript = { "biome" },
                    javascriptreact = { "biome" },
                    typescript = { "biome" },
                    vue = { "prettierd" },
                    typescriptreact = { "biome" },
                    markdown = { "doctoc", "prettierd" },
                    json = { "prettierd" },
                    jsonc = { "prettierd" },
                    lua = { "stylua" },
                    python = {
                        "ruff_fix",
                        "ruff_format",
                        "ruff_organize_imports",
                    },
                    htmldjango = { "djlint" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    toml = { "taplo" },
                    sh = { "shfmt" },
                    php = { "pint" },
                    java = { "google-java-format" },
                    blade = { "blade-formatter" },
                    kotlin = { "ktlint" },
                    latex = { "latexindent" },
                    go = { "goimports-reviser", "gofumpt" },
                    rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
                    haskell = { "ormolu" },
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

                    doctoc = {
                        condition = function(_, ctx)
                            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                                if line:find "<!-- toc -->" then
                                    return true
                                end
                            end

                            return false
                        end,
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

                    shfmt = {
                        prepend_args = { "-i", "4" },
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

                    biome = {
                        append_args = {
                            "--indent-style",
                            "space",
                            "--indent-width",
                            "4",
                        },
                    },

                    prettier = {
                        prepend_args = {
                            "--tab-width",
                            "4",
                            "--single-quote",
                            "--use-tabs",
                            "false",
                            "--html-whitespace-sensitivity",
                            "strict",
                            "--single-attribute-per-line",
                            "true",
                            "--bracket-same-line",
                            "false",
                        },
                    },
                },
            }

            require "mason-conform"

            return opts
        end,
    },

    {
        "zapling/mason-conform.nvim",
        lazy = true,
        opts = {},
    },
}
