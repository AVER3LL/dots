return {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
        local map = vim.keymap.set

        map("i", "<C-o>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true })
    end,
}
