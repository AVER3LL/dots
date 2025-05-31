return {

    {
        "shortcuts/no-neck-pain.nvim",
        -- cmd = "NoNeckPain",
        version = "*",
        opts = {
            width = 120,
            autocmds = { -- Better autocmd configuration
                enableOnVimEnter = true, -- Enable when Vim starts
                reloadOnColorSchemeChange = true,
                skipEnteringNoNeckPainBuffer = false,
            },
            integrations = {
                dashboard = { enabled = true },
            },
        },
    },
}
