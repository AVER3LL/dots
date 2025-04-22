return {

    -- Renaming accross files. Might switch to inc-rename
    {
        "nvim-pack/nvim-spectre",
        keys = {
            {
                "<leader>ra",
                "<cmd>lua require('spectre').toggle()<CR>",
                desc = "Rename all",
                mode = "n",
            },
        },
        cmd = "Spectre",
        opts = {},
    },
}
