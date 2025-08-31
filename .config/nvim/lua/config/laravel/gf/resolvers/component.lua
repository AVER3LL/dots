-- Component references: <x-button> → resources/views/components/button.blade.php
local M = {}

-- Helper function to extract component name from various contexts
local function extract_component_name(line, cursor_pos)
    -- Pattern 1: <x-component-name with cursor position awareness
    local start_pos = 1
    while true do
        local match_start, match_end, component_name = line:find("<x%-([%w%-%.]+)", start_pos)
        if not match_start then
            break
        end

        -- Find the actual end of the component tag (could be self-closing or have attributes)
        local tag_end = line:find("[/>]", match_end) or match_end

        -- Check if cursor is within this component tag
        if cursor_pos >= match_start and cursor_pos <= tag_end then
            return component_name
        end
        start_pos = match_end + 1
    end

    return nil
end

-- Helper function to extract layout from Volt #[Layout()] attribute
local function extract_volt_layout(line, cursor_pos)
    local layout_pattern = "#%[Layout%(%s*['\"]([^'\"]+)['\"]%s*%)]"
    local layout_start, layout_end, layout_name = line:find(layout_pattern)

    if layout_start and cursor_pos >= layout_start and cursor_pos <= layout_end then
        return layout_name
    end

    return nil
end

M.resolve = function(line, laravel_root, _)
    local results = {}
    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] + 1

    -- Check for Volt layout pattern first
    local volt_layout = extract_volt_layout(line, cursor_pos)
    if volt_layout then
        -- Convert layout path to actual file path
        -- 'components.layouts.frontend' -> resources/views/components/layouts/frontend.blade.php
        local layout_path = volt_layout:gsub("%.", "/") .. ".blade.php"
        local layout_file = laravel_root .. "/resources/views/" .. layout_path

        if vim.fn.filereadable(layout_file) == 1 then
            table.insert(results, {
                file = layout_file,
                description = "Volt Layout: " .. volt_layout,
                type = "volt-layout",
            })
        end
        return results
    end

    -- Extract component name considering cursor position
    local component_name = extract_component_name(line, cursor_pos)

    if not component_name then
        return results
    end

    -- Convert component name to file path
    -- frontend.section -> frontend/section
    -- button-group -> button-group
    local component_path = component_name:gsub("%.", "/")

    -- Check multiple possible locations for components
    local component_locations = {
        laravel_root .. "/resources/views/components/" .. component_path .. ".blade.php",
        laravel_root .. "/resources/views/components/" .. component_path .. "/index.blade.php",
        -- Anonymous components in subdirectories
        laravel_root
            .. "/resources/views/components/"
            .. component_name
            .. ".blade.php",
    }

    for _, component_file in ipairs(component_locations) do
        if vim.fn.filereadable(component_file) == 1 then
            table.insert(results, {
                file = component_file,
                description = "Blade component: x-" .. component_name,
                type = "component",
            })
            break -- Only add the first match to avoid duplicates
        end
    end

    -- Also check for class-based components (only if no blade component found)
    if #results == 0 then
        local class_name = component_name:gsub("%-", ""):gsub("%.", "/")
        local class_component_parts = vim.split(class_name, "/")
        local formatted_class_name = ""

        for i, part in ipairs(class_component_parts) do
            -- Convert to PascalCase
            local pascal_part = part:gsub("^%l", string.upper)
            if i == 1 then
                formatted_class_name = pascal_part
            else
                formatted_class_name = formatted_class_name .. "/" .. pascal_part
            end
        end

        local class_component_file = laravel_root .. "/app/View/Components/" .. formatted_class_name .. ".php"
        if vim.fn.filereadable(class_component_file) == 1 then
            table.insert(results, {
                file = class_component_file,
                description = "Component class: " .. formatted_class_name,
                type = "component-class",
            })
        end
    end

    return results
end

return M
