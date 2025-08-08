-- Enhanced Route references: route('dashboard') → any PHP file in routes/

local M = {}

-- Fast recursive PHP file search
local function find_route_files(directory)
    if vim.fn.isdirectory(directory) == 0 then
        return {}
    end
    -- `**/*.php` handled internally by Neovim in C
    return vim.fn.glob(directory .. "/**/*.php", true, true)
end

local function extract_route_name(line, cursor_pos)
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
            if cursor_pos >= route_start and cursor_pos <= route_end then
                return route_name
            end
            start_pos = route_end + 1
        end
    end
end

M.resolve = function(line, laravel_root)
    if not (line:match "route%s*%(" or line:match "to_route%s*%(" or line:match "->routeIs%s*%(") then
        return {}
    end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] + 1
    local quoted_content = extract_route_name(line, cursor_pos)
    if not quoted_content then
        return {}
    end

    local escaped_route = vim.pesc(quoted_content)
    local routes_directory = laravel_root .. "/routes"
    local route_files = find_route_files(routes_directory)

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_line_num = vim.api.nvim_win_get_cursor(0)[1]

    -- Precompile route patterns
    -- Find routes with the corresponding ->name() or Route::resource() or Route::view()
    local patterns = {
        "->name%s*%(%s*['\"]" .. escaped_route .. "['\"]",
        "Route::[^%(]*%([^,]*,%s*['\"]" .. escaped_route .. "['\"]",
    }

    local results = {}
    for _, route_file in ipairs(route_files) do
        local line_num = 0
        for file_line in io.lines(route_file) do
            line_num = line_num + 1
            if route_file == current_file and line_num == current_line_num then
                goto continue_line
            end

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
                    goto continue_line
                end
            end

            local resource_name = file_line:match "Route::resource%s*%(%s*['\"]([^'\"]*)['\"]"
            if resource_name then
                local resource_routes = {
                    resource_name .. ".index",
                    resource_name .. ".create",
                    resource_name .. ".store",
                    resource_name .. ".show",
                    resource_name .. ".edit",
                    resource_name .. ".update",
                    resource_name .. ".destroy",
                }
                for _, rn in ipairs(resource_routes) do
                    if rn == quoted_content then
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
                        goto continue_line
                    end
                end
            end

            ::continue_line::
        end
    end

    return results
end

return M
