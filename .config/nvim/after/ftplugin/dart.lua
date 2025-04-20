local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>fe", ":FlutterEmulators<CR>", { desc = "Flutter show emulators" })
map("n", "<leader>fd", ":FlutterDevices<CR>", { desc = "Flutter show devices" })
map("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter quit" })
map("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter run" })
map("n", "<leader>fl", ":FlutterLogToggle<CR>", { desc = "Flutter toggle logs" })
