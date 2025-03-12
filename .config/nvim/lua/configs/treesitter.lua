local ts_installed, _ = pcall(require, "nvim-treesitter")

if not ts_installed then
    return
end

local function config_ts()
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

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
end

return config_ts()
