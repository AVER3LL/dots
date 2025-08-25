-- Enhanced Route references: route('dashboard') → any PHP file in routes/
-- This resolver now uses a cache for performance, with a fallback to live scanning.

local M = {}

-- Extracts the route name from inside route(...) functions
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

-- The original, on-the-fly scanning logic to be used as a fallback.
local function scan_files_for_route(laravel_root, route_name_to_find)
    local routes_directory = laravel_root .. "/routes"
    local route_files = vim.fn.glob(routes_directory .. "/**/*.php", true, true)
    if not route_files or #route_files == 0 then
        return {}
    end

    local results = {}
    local escaped_route = vim.pesc(route_name_to_find)

    -- Re-create original patterns from the old resolver
    local patterns = {
        "->name%s*%(%s*['\"]" .. escaped_route .. "['\"]",
        "Route::[^%(]*%([^,]*,%s*['\"]" .. escaped_route .. "['\"]",
    }
    local resource_pattern = "Route::resource%s*%(%s*['\"]([^'\"]*)['\"]"

    for _, route_file in ipairs(route_files) do
        local line_num = 0
        local file_handle = io.open(route_file, "r")
        if file_handle then
            for file_line in file_handle:lines() do
                line_num = line_num + 1

                -- Check for direct name match
                for _, pattern in ipairs(patterns) do
                    if file_line:match(pattern) then
                        table.insert(results, {
                            file = route_file,
                            line = line_num,
                            description = "Route: " .. route_name_to_find .. " (in " .. vim.fn.fnamemodify(
                                route_file,
                                ":t"
                            ) .. ")",
                            type = "route",
                        })
                        goto next_file -- Found it, no need to check rest of this file
                    end
                end

                -- Check for resource route match
                local resource_name = file_line:match(resource_pattern)
                if resource_name then
                    local resource_actions = { "index", "create", "store", "show", "edit", "update", "destroy" }
                    for _, action in ipairs(resource_actions) do
                        if resource_name .. "." .. action == route_name_to_find then
                            table.insert(results, {
                                file = route_file,
                                line = line_num,
                                description = "Resource Route: "
                                    .. route_name_to_find
                                    .. " (from "
                                    .. resource_name
                                    .. " in "
                                    .. vim.fn.fnamemodify(route_file, ":t")
                                    .. ")",
                                type = "route",
                            })
                            goto next_file -- Found it
                        end
                    end
                end
            end
            file_handle:close()
        end
        ::next_file::
    end
    return results
end

M.resolve = function(line, laravel_root, _)
    if not (line:match "route%s*%(" or line:match "to_route%s*%(" or line:match "->routeIs%s*%((") then
        return {}
    end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] + 1
    local route_name = extract_route_name(line, cursor_pos)
    if not route_name then
        return {}
    end

    -- Step 1: Try the fast cache first
    local gf_init = require "config.laravel.gf"
    local routes_cache = gf_init.get_routes_cache() -- This will build if it doesn't exist
    if routes_cache and routes_cache[route_name] then
        return { routes_cache[route_name] }
    end

    -- Step 2: If not in cache, fall back to the old, slower file scan.
    vim.notify(
        "Route not found in cache, performing live scan... (This might be slow)",
        vim.log.levels.INFO,
        { title = "Laravel gf" }
    )
    return scan_files_for_route(laravel_root, route_name)
end

return M
