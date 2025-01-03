return {
    {
        "MeanderingProgrammer/markdown.nvim",
        enabled = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        }, -- if you prefer nvim-web-devicons
        version = "*",
        ft = { "markdown", "norg", "rmd", "org" },
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
        },
    },
}
