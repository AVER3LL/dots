-- Leader key setup
local vscode = require "vscode"
vim.notify = vscode.notify

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap helper function
local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- yank to system clipboard
map({ "n", "v" }, "<leader>y", '"+y')

-- paste from system clipboard
map({ "n", "v" }, "<leader>p", '"+p')

-- better indent handling
map("v", "<", "<gv")
map("v", ">", ">gv")

-- show hover duh
map({ "n", "v" }, "<leader>k", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>")

-- Run files
map({ "n", "v" }, "<leader><leader>r", "<cmd>lua require('vscode').action('code-runner.run')<CR>")

-- Format files
map({ "n", "v" }, "<leader>fm", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")

-- Redo
map("n", "U", "<C-r>", { desc = "Redo" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General clear highlights" })
-- Line Movement
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
