---@module 'lazy'
---@type LazyPluginSpec
return {
    "ibhagwan/fzf-lua",
    enabled = false,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        winopts = {
            border = tools.border,
            backdrop = 100,
        },
    },
}
