return {
    {
        "declancm/cinnamon.nvim",
        version = "*", -- use latest release
        config = function()
            local cinnamon = require "cinnamon"

            cinnamon.setup {
                keymaps = {
                    basic = true,
                    extra = false,
                },
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "help", "NvimTree" },
                callback = function()
                    vim.b.cinnamon_disable = true
                end,
            })
        end,
    },
}
