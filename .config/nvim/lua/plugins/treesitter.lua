-- Highlight, edit, and navigate code.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "fish",
                "gitcommit",
                "go",
                "graphql",
                "html",
                "hyprlang",
                "java",
                "javascript",
                "json",
                "json5",
                "jsonc",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "rasi",
                "regex",
                "rust",
                "scss",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
            highlight = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<cr>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            indent = {
                enable = true,
                -- Treesitter unindents Yaml lists for some reason.
                disable = { "yaml" },
            },
        },
        config = function(_, opts)
            local toggle_inc_selection_group =
                vim.api.nvim_create_augroup("mariasolos/toggle_inc_selection", { clear = true })
            vim.api.nvim_create_autocmd("CmdwinEnter", {
                desc = "Disable incremental selection when entering the cmdline window",
                group = toggle_inc_selection_group,
                command = "TSBufDisable incremental_selection",
            })
            vim.api.nvim_create_autocmd("CmdwinLeave", {
                desc = "Enable incremental selection when leaving the cmdline window",
                group = toggle_inc_selection_group,
                command = "TSBufEnable incremental_selection",
            })

            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
