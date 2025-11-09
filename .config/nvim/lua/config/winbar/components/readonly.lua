local M = {}

--- Get the readonly indicator of the current file
--- @param config Config
--- @param state WinBarState
--- @return string colored_result, string plain_result
M.get = function(config, state)
    if not config.show_readonly or not vim.bo.readonly then
        return "", ""
    end

    local colored = ("%%#%s#%s%%*"):format("WinBarReadonly", config.readonly_icon)

    return colored, config.readonly_icon
end

return M