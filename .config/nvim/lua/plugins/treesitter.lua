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
                    "regex",
                    "bibtex",
                    "java",
                    "php",
                    "phpdoc",
                    "java",
                    "json",
                    "jsonc",
                    "javascript",
                    "jsdoc",
                    "typescript",
                    "yaml",
                    "toml",
                    "html",
                    "printf",
                    "css",
                    "htmldjango",
                    "python",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "lua",
                    "luadoc",
                    "vim",
                    "vimdoc",
                    "gitignore",
                    "hyprlang",
                    "query",
                    "c",
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
