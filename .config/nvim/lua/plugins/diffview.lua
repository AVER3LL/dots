return {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        {
            "<leader>gp",
            "<cmd>DiffviewOpen<CR>",
            desc = "Git preview the changes made since the last commit",
        },
        {
            "<leader>gf",
            "<cmd>DiffviewFileHistory %<CR>",
            desc = "Git list all the previous versions of the file",
        },
    },
    opts = {
        keymaps = {
            view = {
                { "n", "q", "<cmd>tabclose<CR>", { desc = "Close diffview tab" } },
            },
            file_panel = {
                { "n", "q", "<cmd>tabclose<CR>", { desc = "Close diffview tab" } },
            },
            file_history_panel = {
                { "n", "q", "<cmd>tabclose<CR>", { desc = "Close diffview tab" } },
            },
        },
    },
}
