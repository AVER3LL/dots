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
                    "bash",
                    "bibtex",
                    "c",
                    "css",
                    "gitignore",
                    "html",
                    "htmldjango",
                    "hyprlang",
                    "java",
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
