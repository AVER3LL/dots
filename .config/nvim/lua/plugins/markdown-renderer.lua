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

                -- Hides the icon and the language used for the codeblock
                style = "none",
                language_name = false,

                width = "block",
                border = "thick",
                highlight = "NormalFloat",
            },
            heading = {
                sign = false,
                icons = {},
            },
        },
    },
}
