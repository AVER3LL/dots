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

-- Enhanced quoted string extraction with better cursor position awareness
M.extract_quoted_string = function(text, pos)
    -- Find the quote that contains or is nearest to the cursor position
    local quote_patterns = {
        "'([^']*)'",
        '"([^"]*)"',
        "`([^`]*)`", -- Added support for backticks
    }

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

-- New: Extract component name from blade components considering cursor position
M.extract_component_from_cursor = function(text, pos)
    local component_pattern = "<x%-([%w%-%.]+)"
    local start_pos = 1

    while true do
        local comp_start, comp_end, component_name = text:find(component_pattern, start_pos)
        if not comp_start then
            break
        end

        -- Find the end of the component tag
        local tag_end = text:find("[/>]", comp_end) or comp_end

        -- Check if cursor is within this component tag
        if pos >= comp_start and pos <= tag_end then
            return component_name
        end
        start_pos = comp_end + 1
    end

    return nil
end

-- New: Extract class name from use statements or full class references
M.extract_class_reference = function(text, pos)
    local class_patterns = {
        "use%s+([%w\\]+)",
        "App\\([%w\\]+)",
        "([%w\\]+)::",
        "new%s+([%w\\]+)%s*%(",
    }

    for _, pattern in ipairs(class_patterns) do
        local start_pos = 1
        while true do
            local match_start, match_end, class_name = text:find(pattern, start_pos)
            if not match_start then
                break
            end

            -- Check if cursor is within this class reference
            if pos >= match_start and pos <= match_end then
                return class_name
            end
            start_pos = match_end + 1
        end
    end

    return nil
end

-- New: Better file existence checking with multiple possibilities
M.find_file_variants = function(base_path, possible_extensions)
    possible_extensions = possible_extensions or { "" }

    for _, ext in ipairs(possible_extensions) do
        local file_path = base_path .. ext
        if vim.fn.filereadable(file_path) == 1 then
            return file_path
        end
    end

    return nil
end

return M
