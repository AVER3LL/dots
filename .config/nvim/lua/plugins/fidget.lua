return {

    -- Lsp percentages and shit
    {
        "j-hui/fidget.nvim",
        enabled = true,
        event = "LspAttach",
        opts = {
            progress = {
                display = {
                    -- Cleans the ui
                    icon_style = "Title",
                    progress_style = "Title",
                },
            },
            integration = {
                ["nvim-tree"] = {
                    enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
                },
            },
        },
    },
}
