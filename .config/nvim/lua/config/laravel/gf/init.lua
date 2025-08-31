-- Enhanced init.lua with improved resolver system and better caching
local helpers = require "config.laravel.gf.helpers"
local snacks = require "snacks"
local utils = require "config.laravel.utils"

local M = {}

-- Global cache for performance optimization
local cache = {
    laravel_root = nil,
    resolvers = nil,
    routes = nil,
    components = nil, -- New: Component cache
    last_cache_build = nil, -- Track when cache was last built
}

-- Lazy load resolvers only once
---@return table
local function get_resolvers()
    if not cache.resolvers then
        cache.resolvers = require "config.laravel.gf.resolvers"
    end
    return cache.resolvers
end

-- Cache Laravel root to avoid repeated filesystem checks
local function get_laravel_root_cached()
    if not cache.laravel_root then
        cache.laravel_root = utils.get_laravel_root()
    end
    return cache.laravel_root
end

--- Builds a cache of all named and resource routes.
function M.build_routes_cache()
    local laravel_root = get_laravel_root_cached()
    if not laravel_root then
        return
    end

    vim.notify("Building Laravel route cache...", vim.log.levels.INFO, { title = "Laravel gf" })

    cache.routes = {}
    local routes_directory = laravel_root .. "/routes"
    local route_files = vim.fn.glob(routes_directory .. "/**/*.php", true, true)

    local name_pattern = "->name%s*%(%s*['\"]([^%']+)['\"]%s*%)"
    local resource_pattern = "Route::resource%s*%(%s*['\"]([^%']*)['\"]"
    local api_resource_pattern = "Route::apiResource%s*%(%s*['\"]([^%']*)['\"]"

    for _, route_file in ipairs(route_files) do
        local line_num = 0
        local file_handle = io.open(route_file, "r")
        if file_handle then
            for file_line in file_handle:lines() do
                line_num = line_num + 1

                -- Find named routes
                local route_name = file_line:match(name_pattern)
                if route_name then
                    cache.routes[route_name] = {
                        file = route_file,
                        line = line_num,
                        description = "Route: " .. route_name .. " (" .. vim.fn.fnamemodify(route_file, ":t") .. ")",
                        type = "route",
                    }
                end

                -- Find resource routes
                local resource_name = file_line:match(resource_pattern)
                if resource_name then
                    local resource_actions = { "index", "create", "store", "show", "edit", "update", "destroy" }
                    for _, action in ipairs(resource_actions) do
                        local full_route_name = resource_name .. "." .. action
                        cache.routes[full_route_name] = {
                            file = route_file,
                            line = line_num,
                            description = "Resource Route: " .. full_route_name .. " (" .. vim.fn.fnamemodify(
                                route_file,
                                ":t"
                            ) .. ")",
                            type = "route",
                        }
                    end
                end

                -- Find API resource routes
                local api_resource_name = file_line:match(api_resource_pattern)
                if api_resource_name then
                    local api_actions = { "index", "store", "show", "update", "destroy" }
                    for _, action in ipairs(api_actions) do
                        local full_route_name = api_resource_name .. "." .. action
                        cache.routes[full_route_name] = {
                            file = route_file,
                            line = line_num,
                            description = "API Resource Route: " .. full_route_name .. " (" .. vim.fn.fnamemodify(
                                route_file,
                                ":t"
                            ) .. ")",
                            type = "api-route",
                        }
                    end
                end
            end
            file_handle:close()
        end
    end

    cache.last_cache_build = vim.fn.localtime()
    vim.notify(
        "Route cache built with " .. vim.tbl_count(cache.routes) .. " routes.",
        vim.log.levels.INFO,
        { title = "Laravel gf" }
    )
end

--- Builds a cache of blade components for faster resolution
function M.build_components_cache()
    local laravel_root = get_laravel_root_cached()
    if not laravel_root then
        return
    end

    vim.notify("Building Laravel component cache...", vim.log.levels.INFO, { title = "Laravel gf" })

    cache.components = {}
    local components_directory = laravel_root .. "/resources/views/components"
    local component_files = vim.fn.glob(components_directory .. "/**/*.blade.php", true, true)

    for _, component_file in ipairs(component_files) do
        local relative_path = component_file:gsub(components_directory .. "/", "")
        local component_name = relative_path:gsub("%.blade%.php$", ""):gsub("/", ".")

        cache.components[component_name] = {
            file = component_file,
            description = "Blade component: x-" .. component_name,
            type = "component",
        }
    end

    vim.notify(
        "Component cache built with " .. vim.tbl_count(cache.components) .. " components.",
        vim.log.levels.INFO,
        { title = "Laravel gf" }
    )
end

--- Gets the routes cache, building it if it doesn't exist or is stale.
---@return table|nil
function M.get_routes_cache()
    local now = vim.fn.localtime()
    local cache_age = cache.last_cache_build and (now - cache.last_cache_build) or math.huge

    -- Rebuild cache if it's older than 5 minutes (300 seconds) or doesn't exist
    if not cache.routes or cache_age > 300 then
        M.build_routes_cache()
    end

    return cache.routes
end

--- Gets the components cache, building it if it doesn't exist.
---@return table|nil
function M.get_components_cache()
    if not cache.components then
        M.build_components_cache()
    end
    return cache.components
end

-- Function to generate all caches upfront
M.generate_all_caches = function()
    cache.laravel_root = utils.get_laravel_root()
    cache.resolvers = require "config.laravel.gf.resolvers"
    M.build_routes_cache()
    M.build_components_cache()
    vim.notify("All Laravel caches generated", vim.log.levels.INFO, { title = "Laravel gf" })
end

-- Function to clear all caches (useful for development)
M.clear_caches = function()
    cache.laravel_root = nil
    cache.resolvers = nil
    cache.routes = nil
    cache.components = nil
    cache.last_cache_build = nil
    vim.notify("Laravel caches cleared", vim.log.levels.INFO, { title = "Laravel gf" })
end

-- Function to rebuild caches
M.rebuild_caches = function()
    M.clear_caches()
    M.generate_all_caches()
end

M.goto_file_under_cursor = function()
    -- If not in a Laravel project, use default gf
    if not utils.is_laravel_project() then
        helpers.default_gf()
        return
    end

    local laravel_root = get_laravel_root_cached()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1

    local quoted_content = helpers.extract_quoted_string(line, col)
    local possible_files = {}
    local resolvers = get_resolvers()

    -- Process resolvers and collect results
    for _, resolver in ipairs(resolvers) do
        -- Use pcall to prevent one resolver from breaking others
        local success, results = pcall(resolver.resolve, line, laravel_root, quoted_content)
        if success and results and #results > 0 then
            vim.list_extend(possible_files, results)
        elseif not success then
            -- Log resolver errors for debugging (only in debug mode)
            if vim.g.laravel_gf_debug then
                vim.notify("Resolver error: " .. tostring(results), vim.log.levels.DEBUG, { title = "Laravel gf" })
            end
        end
    end

    -- If no Laravel-specific files found, fallback to default gf
    if #possible_files == 0 then
        helpers.default_gf()
        return
    end

    -- If only one file found, open it directly (fastest path)
    if #possible_files == 1 then
        local file_info = possible_files[1]
        vim.cmd("edit " .. vim.fn.fnameescape(file_info.file))
        if file_info.line then
            vim.api.nvim_win_set_cursor(0, { file_info.line, 0 })
        end
        return
    end

    -- Multiple files found, show picker with enhanced formatting
    -- Pre-process items for picker to avoid doing it in format function
    for _, file_info in ipairs(possible_files) do
        file_info.text = file_info.description
        file_info.search_key = file_info.description
    end

    snacks.picker.pick {
        name = "Laravel Files for: " .. (quoted_content or helpers.extract_component_from_cursor(line, col) or ""),
        layout = "vscode",
        items = possible_files,
        format = function(item)
            local type_config = {
                route = { icon = "󰑴", color = "SnacksPickerFile" },
                ["api-route"] = { icon = "", color = "Function" },
                component = { icon = "󰅴", color = "Function" },
                ["component-class"] = { icon = "", color = "Structure" },
                ["volt-layout"] = { icon = "󰃃", color = "Type" },
                view = { icon = "󰈙", color = "String" },
                livewire = { icon = "⚡", color = "Keyword" },
                ["livewire-class"] = { icon = "⚡", color = "Structure" },
                ["livewire-view"] = { icon = "⚡", color = "String" },
                config = { icon = "", color = "Constant" },
                env = { icon = "", color = "PreProc" },
                asset = { icon = "󰈔", color = "Directory" },
                model = { icon = "󰆼", color = "Type" },
                translation = { icon = "󰗊", color = "String" },
                storage = { icon = "󰉋", color = "Directory" },
                storage_url = { icon = "󰉋", color = "Directory" },
                controller = { icon = "", color = "Structure" },
                ["controller-action"] = { icon = "", color = "Function" },
                ["resource-controller"] = { icon = "", color = "Structure" },
                ["api-resource-controller"] = { icon = "", color = "Structure" },
                middleware = { icon = "󰫙", color = "Operator" },
                ["middleware-alias"] = { icon = "󰫙", color = "Comment" },
                policy = { icon = "", color = "Conditional" },
                event = { icon = "󰐃", color = "Exception" },
                listener = { icon = "", color = "Function" },
                factory = { icon = "󰘦", color = "Number" },
                seeder = { icon = "󰰮", color = "Number" },
                job = { icon = "󰜎", color = "Keyword" },
                inertia = { icon = "󰜈", color = "Function" },
                volt = { icon = "⚡", color = "Type" },
            }

            local config = type_config[item.type] or { icon = "󰈔", color = "SnacksPickerFile" }

            return {
                { config.icon .. " ", config.color },
                { item.description, config.color },
                { " [" .. item.type .. "]", "Comment" },
            }
        end,
        confirm = function(picker, item)
            if item then
                picker:close()
                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                if item.line then
                    vim.api.nvim_win_set_cursor(0, { item.line, 0 })
                end
            end
        end,
    }
end

return M
