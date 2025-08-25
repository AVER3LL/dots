local fn, api = vim.fn, vim.api

local M = {}

--- Function to compute file icon and color for a given buffer
--- @param bufnr integer
--- @return string, string
function M.compute_icon_for_buf(bufnr)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return "", ""
    end

    local filename = vim.fn.bufname(bufnr)
    local basename = fn.fnamemodify(filename, ":t")
    local extension = fn.fnamemodify(filename, ":e")
    local icon, color

    -- Try multiple methods to get icon and color
    if basename ~= "" then
        icon, color = devicons.get_icon_color(basename, extension)
    end

    if (not icon or not color) and extension ~= "" then
        icon, color = devicons.get_icon_color("file." .. extension, extension)
    end

    if not icon and basename ~= "" then
        icon = devicons.get_icon(basename, extension)
    end

    if icon and not color and extension ~= "" then
        local _, ext_color = devicons.get_icon_color("." .. extension, extension)
        color = ext_color
    end

    icon = icon or ""
    color = color or ""

    -- Final fallback: use normal text color if needed
    if icon ~= "" and color == "" then
        local normal_hl = api.nvim_get_hl(0, { name = "Normal" })
        color = normal_hl.fg and string.format("#%06x", normal_hl.fg) or "#FFFFFF"
    end

    return icon, color
end

-- Function to get file icon and color using the cache
M.icon = function()
    local cache = require("config.winbar.cache")
    local bufnr = api.nvim_get_current_buf()
    return cache.get_file_icon(bufnr)
end

M.path = function()
    local filepath = fn.fnamemodify(fn.expand "%", ":~:.:h")
    return (filepath == "." or filepath == "") and "" or filepath
end

return M
