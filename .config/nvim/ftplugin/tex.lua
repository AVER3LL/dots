local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>fr", ":VimtexCompile<CR>", { desc = "Compile the file" })
