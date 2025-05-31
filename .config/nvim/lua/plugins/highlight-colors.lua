return {

    -- css colors highlighting
    {
        "brenoprata10/nvim-highlight-colors",
        enabled = true,
        event = "VeryLazy",
        config = function()
            require("nvim-highlight-colors").setup {
                render = "background",
                virtual_symbol_position = "inline",
                -- virtual_symbol = " ",
                virtual_symbol = "󱓻",
                virtual_symbol_prefix = "",
                virtual_symbol_suffix = " ",
                enable_tailwind = true,
                exclude_buftypes = { "terminal" },
                exclude_filetypes = { "NvimTree", "TelescopePrompt", "TelescopeResults", "lazy", "mason", "neo-tree" },
            }
        end,
    },
}
