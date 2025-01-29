local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>fe", ":FlutterEmulators<CR>", { desc = "Flutter Emulators" })
map("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
map("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter Run" })
map("n", "<leader>fl", ":FlutterLogToggle<CR>", { desc = "Flutter Log" })
