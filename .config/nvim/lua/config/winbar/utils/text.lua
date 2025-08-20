local fn = vim.fn

local M = {}

M.truncate = function(text, max_width)
    if fn.strdisplaywidth(text) <= max_width then
        return text
    end

    local ellipsis = require("icons").misc.ellipsis
    local ellipsis_width = fn.strdisplaywidth(ellipsis)
    local target_width = max_width - ellipsis_width

    if target_width <= 0 then
        return ellipsis
    end

    local char_count = fn.strchars(text)
    for i = char_count, 1, -1 do
        local truncated = ellipsis .. fn.strpart(text, char_count - i, i)
        if fn.strdisplaywidth(truncated) <= max_width then
            return truncated
        end
    end
    return ellipsis
end

return M
