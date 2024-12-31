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
            -- disable = { "latex" },
        },
        ignore_install = {},
        modules = {},
        auto_install = true,
        sync_install = false,
        -- enable indentation
        indent = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
            "regex",
            "java",
            "php",
            "java",
            "json",
            "jsonc",
            "javascript",
            "typescript",
            "tsx",
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
    parser_config.blade = {
        install_info = {
            url = "https://github.com/EmranMR/tree-sitter-blade",
            files = { "src/parser.c" },
            branch = "main",
        },
        filetype = "blade",
    }
end

return config_ts()
