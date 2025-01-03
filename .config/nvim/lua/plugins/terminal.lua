local looks_found, looks = pcall(require, "config.looks")
local bt = looks_found and looks.border_type() or "single"

return {
    "akinsho/toggleterm.nvim",
    enabled = false,
    version = "*",
    event = "VeryLazy",
    config = function()
        require("toggleterm").setup {
            open_mapping = [[<A-i>]],
            shade_terminals = true,
            direction = "float",
            start_in_insert = true,
            close_on_exit = true,
            border = "single",
            persist_mode = true,
            float_opts = {
                border = bt, -- 'single' | 'double' | 'shadow' | 'curved' |
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
                width = 130,
                height = 30,
            },
        }
    end,
}
