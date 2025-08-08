-- Enhanced Route references: route('dashboard') → any PHP file in routes/

local M = {}

local function find_route_files(directory)
    local files = {}
    if vim.fn.isdirectory(directory) == 0 then
        return files
    end

    local entries = vim.fn.readdir(directory)
    for _, entry in ipairs(entries) do
        local full_path = directory .. "/" .. entry
        ---@diagnostic disable-next-line: undefined-field
        local stat = vim.loop.fs_stat(full_path)

        if stat then
            if stat.type == "directory" then
                -- Recursively search subdirectories
                vim.list_extend(files, find_route_files(full_path))
            elseif stat.type == "file" and entry:match "%.php$" then
                -- Add PHP files
                table.insert(files, full_path)
            end
        end
    end

    return files
end

-- Helper function to extract route name from route() calls
local function extract_route_name(line, cursor_pos)
    -- Find route() calls and extract the quoted content
    local route_patterns = {
        "route%s*%(%s*['\"]([^'\"]*)['\"]",
        "to_route%s*%(%s*['\"]([^'\"]*)['\"]",
        "->routeIs%s*%(%s*['\"]([^'\"]*)['\"]",
    }

    for _, pattern in ipairs(route_patterns) do
        local start_pos = 1
        while true do
            local route_start, route_end, route_name = line:find(pattern, start_pos)
            if not route_start then
                break
            end

            -- Check if cursor is within this route() call
            if cursor_pos >= route_start and cursor_pos <= route_end then
                return route_name
            end
            start_pos = route_end + 1
        end
    end

    return nil
end

M.resolve = function(line, laravel_root)
    local results = {}

    if not (line:match "route%s*%(" or line:match "to_route%s*%(" or line:match "->routeIs%s*%(") then
        return results
    end

    -- Extract the route name from the current cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] + 1
    local quoted_content = extract_route_name(line, cursor_pos)

    if not quoted_content then
        return results
    end

    local routes_directory = laravel_root .. "/routes"
    local route_files = find_route_files(routes_directory)
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_line_num = vim.api.nvim_win_get_cursor(0)[1]

    for _, route_file in ipairs(route_files) do
        -- Search for the route name in the file
        local content = vim.fn.readfile(route_file)
        for line_num, file_line in ipairs(content) do
            -- Skip if this is the current file and current line (avoid suggesting the same line we're on)
            if route_file == current_file and line_num == current_line_num then
                goto next_file_line
            end

            -- Enhanced patterns to match various route definitions
            local patterns = {
                -- Standard named routes: ->name('route.name')
                "->name%s*%(%s*['\"]"
                    .. vim.pesc(quoted_content)
                    .. "['\"]",
                -- Route with name as second parameter: Route::get('/path', 'route.name')
                "Route::[^%(]*%([^,]*,%s*['\"]"
                    .. vim.pesc(quoted_content)
                    .. "['\"]",
            }

            for _, pattern in ipairs(patterns) do
                if file_line:match(pattern) then
                    table.insert(results, {
                        file = route_file,
                        line = line_num,
                        description = "Route definition: " .. quoted_content .. " (in " .. vim.fn.fnamemodify(
                            route_file,
                            ":t"
                        ) .. ")",
                        type = "route",
                    })
                    goto next_file_line
                end
            end

            -- Special handling for Route::resource - check if the route name matches a resource pattern
            local resource_name = file_line:match "Route::resource%s*%(%s*['\"]([^'\"]*)['\"]"
            if resource_name then
                -- Check if the quoted_content matches THIS specific resource route pattern
                local resource_routes = {
                    resource_name .. ".index",
                    resource_name .. ".create",
                    resource_name .. ".store",
                    resource_name .. ".show",
                    resource_name .. ".edit",
                    resource_name .. ".update",
                    resource_name .. ".destroy",
                }

                for _, route_name in ipairs(resource_routes) do
                    if route_name == quoted_content then
                        table.insert(results, {
                            file = route_file,
                            line = line_num,
                            description = "Resource route: "
                                .. quoted_content
                                .. " (from "
                                .. resource_name
                                .. " resource in "
                                .. vim.fn.fnamemodify(route_file, ":t")
                                .. ")",
                            type = "route",
                        })
                        goto next_file_line -- Only match the specific resource, then move to next line
                    end
                end
            end

            ::next_file_line::
        end
    end

    return results
end

return M
