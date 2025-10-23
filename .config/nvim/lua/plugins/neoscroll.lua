return {
    {
        "declancm/cinnamon.nvim",
        enabled = true,
        version = "*", -- use latest release
        config = function()
            local cinnamon = require "cinnamon"

            cinnamon.setup {
                keymaps = {
                    basic = false,
                    extra = false,
                },
            }

            vim.keymap.set("n", "<C-U>", function()
                cinnamon.scroll "<C-U>zz"
            end)
            vim.keymap.set("n", "<C-D>", function()
                cinnamon.scroll "<C-D>zz"
            end)
            vim.keymap.set("n", "<C-F>", function()
                cinnamon.scroll "<C-F>zz"
            end)
            vim.keymap.set("n", "<C-B>", function()
                cinnamon.scroll "<C-B>zz"
            end)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "NvimTree" },
                callback = function()
                    vim.b.cinnamon_disable = true
                end,
            })
        end,
    },
}
