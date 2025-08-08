local M = {}
M.default_gf = function()
    -- Save the current isfname setting
    local old_isfname = vim.opt.isfname:get()

    -- Temporarily modify isfname to include common path characters
    vim.opt.isfname:append { ".", "/", "-", "_" }

    -- Execute the default gf command in a protected call
    local success, _ = pcall(function()
        vim.cmd "normal! gf"
    end)

    -- Restore the original isfname setting
    vim.opt.isfname = old_isfname

    if not success then
        vim.notify("File not found under cursor", vim.log.levels.WARN)
    end
end

M.extract_quoted_string = function(text, pos)
    -- Find the quote that contains or is nearest to the cursor position
    local quote_patterns = { "'([^']*)'", '"([^"]*)"' }

    for _, pattern in ipairs(quote_patterns) do
        local start_pos = 1
        while true do
            local quote_start, quote_end, content = text:find(pattern, start_pos)
            if not quote_start then
                break
            end

            -- Check if cursor is within this quoted string
            if pos >= quote_start and pos <= quote_end then
                return content, quote_start, quote_end
            end
            start_pos = quote_end + 1
        end
    end
    return nil
end

return M
