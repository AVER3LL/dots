return {
    "nvim-flutter/flutter-tools.nvim",
    ft ="dart",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = function()
        require("flutter-tools").setup {
            widget_guides = {
                enabled = true,
            },
            lsp = {
                color = {
                    enabled = true,
                    background = false,
                    virtual_text = false, -- show the highlight using virtual text
                    virtual_text_str = "󱓻", -- the virtual text character to highlight
                },
            },
        }
        require("telescope").load_extension "flutter"
    end,
}
