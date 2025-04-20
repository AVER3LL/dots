local delete = require("icons").misc.delete
local bar = require("icons").misc.thick_bar
local border = require("config.looks").border_type()

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup {
                preview_config = {
                    border = border,
                },
                signs = {
                    add = { text = bar },
                    change = { text = bar },
                    delete = { text = delete },
                    topdelete = { text = delete },
                    changedelete = { text = bar },
                    untracked = { text = bar },
                },
                signs_staged = {
                    add = { text = bar },
                    change = { text = bar },
                    delete = { text = delete },
                    topdelete = { text = delete },
                    changedelete = { text = bar },
                },
            }
        end,
    },
}
