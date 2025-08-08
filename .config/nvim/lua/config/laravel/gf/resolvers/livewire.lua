local M = {}

-- Convert component name to class name format
-- create-post -> CreatePost
-- partials.promotions -> Partials/Promotions
local function to_class_name(name)
    local parts = vim.split(name, ".", { plain = true })
    local class_parts = {}

    for _, part in ipairs(parts) do
        -- Convert kebab-case to PascalCase
        local pascal_part = part:gsub("%-(%w)", string.upper):gsub("^%w", string.upper)
        table.insert(class_parts, pascal_part)
    end

    return table.concat(class_parts, "/")
end

-- Convert component name to view path format
-- create-post -> create-post
-- partials.promotions -> partials/promotions
local function to_view_path(name)
    return name:gsub("%.", "/")
end

M.resolve = function(line, laravel_root)
    local results = {}

    -- Match Livewire component tags: <livewire:component-name /> or <livewire:folder.component />
    local component_name = line:match "<livewire:([%w%-%.]+)"

    if not component_name then
        return results
    end

    local class_name = to_class_name(component_name)
    local view_path = to_view_path(component_name)

    -- Check for Livewire class file
    local class_file = laravel_root .. "/app/Livewire/" .. class_name .. ".php"
    if vim.fn.filereadable(class_file) == 1 then
        table.insert(results, {
            file = class_file,
            description = "Livewire class: " .. component_name,
            type = "livewire-class",
        })
    end

    -- Check for Livewire blade view
    local view_file = laravel_root .. "/resources/views/livewire/" .. view_path .. ".blade.php"
    if vim.fn.filereadable(view_file) == 1 then
        table.insert(results, {
            file = view_file,
            description = "Livewire view: " .. component_name,
            type = "livewire-view",
        })
    end

    return results
end

return M
