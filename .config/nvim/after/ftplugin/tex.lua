tools.map("n", "<leader>fr", ":VimtexCompile<CR>", { desc = "Compile the file" })
-- map("n", "<leader>o", function()
--     vim.cmd "normal! 1z="
--     -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "n", true)
-- end, { desc = "Show word suggestions " })
vim.opt.spell = true
vim.opt.spelllang = { "fr" }
