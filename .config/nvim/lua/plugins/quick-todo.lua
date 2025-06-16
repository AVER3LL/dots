local bt = require("config.looks").border_type()
-- Values below are the defaults
return {
    "SyedAsimShah1/quick-todo.nvim",
    config = function()
        require("quick-todo").setup {
            keys = {
                open = "<leader><leader>q",
            },
            window = {
                height = 0.7,
                width = 0.6,
                winblend = 0,
                border = bt,
            },
        }
    end,
}
