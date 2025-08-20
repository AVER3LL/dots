return {
    "danymat/neogen",
    version = "*",
    keys = {
        {
            "<leader>dg",
            vim.cmd.Neogen,
            desc = "Generate Documentation",
            mode = "n",
        },
    },
    cmd = "Neogen",
    opts = {
        snippet_engine = "luasnip",
        languages = {
            python = {
                template = {
                    annotation_convention = "reST",
                },
            },
        },
    },
}
