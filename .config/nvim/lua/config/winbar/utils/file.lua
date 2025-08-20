local fn, api = vim.fn, vim.api

local M = {}

-- Function to get file icon and color using nvim-web-devicons
M.icon = function()
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return "", ""
    end

    local filename = fn.expand "%:t"
    local extension = fn.expand "%:e"
    local icon, color

    -- Try multiple methods to get icon and color
    if filename ~= "" then
        icon, color = devicons.get_icon_color(filename, extension)
    end

    if (not icon or not color) and extension ~= "" then
        icon, color = devicons.get_icon_color("file." .. extension, extension)
    end

    if not icon and filename ~= "" then
        icon = devicons.get_icon(filename, extension)
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

M.path = function()
    local filepath = fn.fnamemodify(fn.expand "%", ":~:.:h")
    return (filepath == "." or filepath == "") and "" or filepath
end

return M
