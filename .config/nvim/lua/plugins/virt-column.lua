return {

    -- Vertical line
    {
        "lukas-reineke/virt-column.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            char = { "┆" },
            highlight = { "NonText" },
        },
    },
}
