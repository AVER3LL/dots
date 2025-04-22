local M = {}

M.square = function(hl_name)
    return {
        { "┌", hl_name },
        { "─", hl_name },
        { "┐", hl_name },
        { "│", hl_name },
        { "┘", hl_name },
        { "─", hl_name },
        { "└", hl_name },
        { "│", hl_name },
    }
end


M.rounded = function(hl_name)
    return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end

-- Options are border_square, border_rounded and
M.current_border = M.rounded

M.current_border_telescope = function()
    local formatted = {}
    local mapping = { [2] = 1, [4] = 2, [6] = 3, [8] = 4, [1] = 5, [3] = 6, [5] = 7, [7] = 8 }

    for i, item in ipairs(M.current_border()) do
        if mapping[i] then
            formatted[mapping[i]] = item[1]
        end
    end

    return formatted
end

M.border_type = function()
    if M.current_border == M.rounded then
        return "rounded"
    else
        return "single"
    end
end

return M
