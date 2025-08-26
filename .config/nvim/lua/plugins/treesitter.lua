-- Highlight, edit, and navigate code

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    opts = {
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

        auto_install = true,

        highlight = {
            enable = true,
            -- disable = { "latex" },
            disable = function(_, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = { "ruby" },
        },

        indent = { enable = true, disable = { "ruby" } },

        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                scope_incremental = false,
                node_decremental = "<Backspace>",
            },
        },
    },
}
