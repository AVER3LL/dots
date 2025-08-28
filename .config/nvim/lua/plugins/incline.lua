---@module 'lazy'
---@type LazyPluginSpec
return {
    "b0o/incline.nvim",
    enabled = false,
    dependencies = {
        "SmiteshP/nvim-navic",
    },
    config = function()
        require("incline").setup {
            render = require("config.incline-configs").location,

            window = {
                margin = { horizontal = 0 },
                padding = 0,
            },
        }
    end,
}
