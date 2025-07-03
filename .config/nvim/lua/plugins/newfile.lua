local bt = require('config.looks').border_type()

return {
    "adibhanna/nvim-newfile.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("nvim-newfile").setup {
            -- Optional configuration
            ui = {
                border_style = bt,
                prompt_text = "File name: ",
                width = 60,
                height = 1,
            },
        }
    end,
}
