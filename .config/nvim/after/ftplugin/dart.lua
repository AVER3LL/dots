local map = tools.map

map("n", "<leader>fe", ":FlutterEmulators<CR>", { desc = "Flutter show emulators" })
map("n", "<leader>fd", ":FlutterDevices<CR>", { desc = "Flutter show devices" })
map("n", "<leader>fq", ":FlutterQuit<CR>", { desc = "Flutter quit" })
map("n", "<leader>fr", ":FlutterRun<CR>", { desc = "Flutter run" })
map("n", "<leader>fl", ":FlutterLogToggle<CR>", { desc = "Flutter toggle logs" })
