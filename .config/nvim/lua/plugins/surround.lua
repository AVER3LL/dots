return {

    {
        "NStefan002/visual-surround.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            surround_chars = { "{", "}", "[", "]", "(", ")", "'", '"', "`" },
        },
    },
}
