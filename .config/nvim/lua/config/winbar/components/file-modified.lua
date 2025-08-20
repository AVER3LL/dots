local M = {}

--- Get the modified indicator of the current file
--- @param config Config
--- @param state WinBarState
--- @return string colored_result, string plain_result
M.get = function(config, state)
    if not config.show_modified or not vim.bo.modified then
        return "", ""
    end

    local colored = ("%%#%s#%s%%*"):format("WinBarModified", config.modified_icon)

    return colored, config.modified_icon
end

return M
