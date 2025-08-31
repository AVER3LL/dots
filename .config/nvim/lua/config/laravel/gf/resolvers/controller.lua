-- Controller references: Focus on Laravel-specific patterns (LSP handles imports)
local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    -- Pattern 1: Route definitions with controller actions (Laravel-specific)
    if line:match "Route::" and quoted_content then
        -- Check if this looks like a controller@action pattern
        if quoted_content:match "@" then
            local controller_name, action = quoted_content:match "([%w]+)@([%w]+)"
            if controller_name then
                local controller_file = laravel_root .. "/app/Http/Controllers/" .. controller_name .. ".php"
                if vim.fn.filereadable(controller_file) == 1 then
                    -- Try to find the specific action method
                    local line_num = nil
                    local content = vim.fn.readfile(controller_file)
                    local method_pattern = "function%s+" .. action .. "%s*%("

                    for i, file_line in ipairs(content) do
                        if file_line:match(method_pattern) then
                            line_num = i
                            break
                        end
                    end

                    table.insert(results, {
                        file = controller_file,
                        line = line_num,
                        description = "Controller: " .. controller_name .. " (method: " .. action .. ")",
                        type = "controller-action",
                    })
                end
            end
        end
    end

    -- Pattern 2: Resource controller inference from routes
    if line:match "Route::resource" and quoted_content then
        -- Infer controller name from resource name
        local resource_parts = vim.split(quoted_content, "/")
        local last_part = resource_parts[#resource_parts]
        local controller_name = last_part:gsub("^%l", string.upper) .. "Controller"

        local controller_file = laravel_root .. "/app/Http/Controllers/" .. controller_name .. ".php"
        if vim.fn.filereadable(controller_file) == 1 then
            table.insert(results, {
                file = controller_file,
                description = "Resource Controller: " .. controller_name,
                type = "resource-controller",
            })
        end
    end

    -- Pattern 3: API Resource controller inference
    if line:match "Route::apiResource" and quoted_content then
        local resource_parts = vim.split(quoted_content, "/")
        local last_part = resource_parts[#resource_parts]
        local controller_name = last_part:gsub("^%l", string.upper) .. "Controller"

        local controller_file = laravel_root .. "/app/Http/Controllers/" .. controller_name .. ".php"
        if vim.fn.filereadable(controller_file) == 1 then
            table.insert(results, {
                file = controller_file,
                description = "API Resource Controller: " .. controller_name,
                type = "api-resource-controller",
            })
        end
    end

    return results
end

return M
