return {

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            dashboard = { enabled = false },
            indent = { enabled = false, only_current = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            terminal = {
                win = {
                    style = "terminal",
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                },
            },
        },
    },
}
