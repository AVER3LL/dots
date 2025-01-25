return {
    {
        "MeanderingProgrammer/markdown.nvim",
        enabled = true,
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
                border = "thick",
            },
            heading = {
                sign = false,
                icons = {},
            },
        },
    },
}
