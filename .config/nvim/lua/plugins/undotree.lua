return {
    {
        "mbbill/undotree",
        keys = {
            {
                "<leader>u",
                vim.cmd.UndotreeToggle,
                desc = "Toggle undo tree",
                mode = "n",
            },
        },
        cmd = "UndotreeToggle",
    },

    {
        "XXiaoA/atone.nvim",
        enabled = false,
        keys = {
            {
                "<leader>u",
                -- vim.cmd.Atone,
                ":Atone toggle<CR>",
                desc = "Toggle undo tree",
                mode = "n",
            },
        },
        cmd = "Atone",
        opts = {}, -- your configuration here
    },
}
