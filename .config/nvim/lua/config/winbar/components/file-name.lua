local file = require "config.winbar.utils.file"
local api, fn = vim.api, vim.fn

local M = {}

--- Create window-specific icon highlight
--- @param win_id integer
--- @param icon_color string
--- @return string highlight_name
local function create_icon_highlight(win_id, icon_color)
    if not icon_color or icon_color == "" or not icon_color:match "^#[0-9a-fA-F]+$" then
        return ""
    end

    local icon_hl_name = "WinBarFileIcon" .. win_id
    pcall(api.nvim_set_hl, 0, icon_hl_name, { fg = icon_color })
    return icon_hl_name
end

--- Get the file name and icon of the current file
--- @param config Config
--- @param state WinBarState
--- @return string colored_result, string plain_result
M.get = function(config, state)
    local filename = fn.expand "%:t"

    -- Return empty if no filename
    if filename == "" then
        return "", ""
    end

    local icon, icon_color = file.icon()

    -- Handle icon coloring
    local colored_icon = icon
    if icon ~= "" then
        local win_id = api.nvim_get_current_win()
        local icon_hl_name = create_icon_highlight(win_id, icon_color)

        if icon_hl_name ~= "" then
            colored_icon = ("%%#%s#%s%%*"):format(icon_hl_name, icon)
        end
    end

    local colored_result = colored_icon .. (icon ~= "" and " " or "") .. filename
    local plain_result = icon .. (icon ~= "" and " " or "") .. filename

    return colored_result, plain_result
end

return M
