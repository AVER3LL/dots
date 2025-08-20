local file = require "config.winbar.utils.file"
local text_utils = require "config.winbar.utils.text"
local fn = vim.fn

local M = {}

--- Get the path of the current file
--- @param config Config
--- @param state WinBarState
--- @return string colored_result, string plain_result
M.get = function(config, state)
    -- Only show path when active or configured to show when inactive
    if not (state.is_active or config.show_path_when_inactive) then
        return "", ""
    end

    local file_path = file.path()

    -- Return empty if no path or not enough space
    if file_path == "" or state.available_space <= 10 then
        return "", ""
    end

    -- Reserve space for other components and padding
    local path_space = state.available_space - (config.min_padding * 2)
    if path_space <= 5 then
        return "", ""
    end

    -- Truncate if necessary
    local truncated_path = text_utils.truncate(file_path, path_space)
    if fn.strdisplaywidth(truncated_path) == 0 then
        return "", ""
    end

    local colored = ("%%#%s#%s%%*"):format("WinBarPath", truncated_path)

    return colored, truncated_path
end

return M
