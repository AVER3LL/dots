local M = {}

M.border_square = function(hl_name)
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

M.border_kanagawa = function(hl_name)
    return {
        { "🭽", hl_name },
        { "▔", hl_name },
        { "🭾", hl_name },
        { "▕", hl_name },
        { "🭿", hl_name },
        { "▁", hl_name },
        { "🭼", hl_name },
        { "▏", hl_name },
    }
end

M.border_rounded = function(hl_name)
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

-- Options are border_square, border_rounded and border_kanagawa
M.current_border = M.border_rounded

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
    if M.current_border == M.border_rounded then
        return "rounded"
    else
        return "single"
    end
end

return M
