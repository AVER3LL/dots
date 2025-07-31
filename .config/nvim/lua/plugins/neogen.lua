return {
    "danymat/neogen",
    version = "*",
    keys = {
        {
            "<leader>dg",
            "<cmd>Neogen<CR>",
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
