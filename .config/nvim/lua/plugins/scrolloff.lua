---@module 'lazy'
---@type LazyPluginSpec
return {
    "Aasim-A/scrollEOF.nvim",
    enabled = false,
    event = { "CursorMoved", "WinScrolled" },
    config = function()
        require("scrollEOF").setup {
            floating = false,
        }
    end,
}
