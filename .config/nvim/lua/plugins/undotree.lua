return {
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
}
