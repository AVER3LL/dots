return {

    -- Lsp percentages and shit
    {
        "j-hui/fidget.nvim",
        enabled = true,
        event = "LspAttach",
        opts = {
            integration = {
                ["nvim-tree"] = {
                    enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
                },
            },
        },
    },
}
