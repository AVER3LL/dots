return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        enabled = false,
        opts = {},
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                opts = {
                    custom_calculation = function(_, language_tree)
                        if
                            vim.bo.filetype == "blade"
                            and language_tree._lang ~= "javascript"
                            and language_tree._lang ~= "php"
                        then
                            return "{{-- %s --}}"
                        end
                    end,
                },
            },
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
                    additional_vim_regex_highlighting = { "ruby" },
                },
                ignore_install = {
                    -- "dart",
                    "ruby",
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
