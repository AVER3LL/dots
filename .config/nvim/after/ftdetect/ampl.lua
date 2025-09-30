--[[
	Filetype detection for config files of `kitty`.
	Language:          ampl
	Maintainer:        Averell D
	Last Change:       30 September, 2025
]]

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.ampl",
    callback = function(event)
        vim.bo[event.buf].filetype = "ampl"
    end,
})
