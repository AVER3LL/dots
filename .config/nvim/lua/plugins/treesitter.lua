return {
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            local treesitter = require "nvim-treesitter.configs"

            -- Attempt to fix blade syntax highlighting being broken
            -- local parsers = require("nvim-treesitter.parsers").get_parser_configs()
            -- vim.print(parsers.php)
            -- parsers.php = {
            --     install_info = {
            --         url = "https://github.com/tree-sitter/tree-sitter-php",
            --         files = { "src/parser.c", "src/scanner.c" },
            --         location = "php",
            --         branch = "master",
            --         revision = "f3a19ab3217a6e838870fc7142fa492d1fd7a7c9",
            --     },
            --     filetype = "php",
            -- }

            -- configure treesitter
            treesitter.setup {
                -- enable syntax highlighting
                highlight = {
                    enable = true,
                    use_languagetree = true,
                    disable = { "latex" },
                },
                ignore_install = {
                    -- "dart",
                },
                modules = {},
                auto_install = true,
                sync_install = false,
                -- enable indentation
                indent = {
                    enable = true,
                    -- disable = {
                    --     "dart",
                    -- },
                },
                -- ensure these language parsers are installed
                ensure_installed = {
                    "bash",
                    "bibtex",
                    "blade",
                    "c",
                    "css",
                    "gitignore",
                    "html",
                    "htmldjango",
                    "hyprlang",
                    "java",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "norg",
                    "php",
                    "phpdoc",
                    "printf",
                    "python",
                    "query",
                    "regex",
                    "scss",
                    "svelte",
                    "toml",
                    "typescript",
                    "typst",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
            }
        end,
    },
}
