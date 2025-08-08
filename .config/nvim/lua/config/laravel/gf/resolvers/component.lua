-- Component references: <x-button> → resources/views/components/button.blade.php
local M = {}

M.resolve = function(line, laravel_root, _)
    local results = {}

    -- Match blade component tags: <x-component-name> with optional attributes
    -- This pattern captures the component name between <x- and the first space or >
    local component_match = line:match "<x%-([%w%-%.]+)[%s/>]"

    if component_match then
        -- Convert component name to file path
        -- button.link -> button/link
        -- go-back -> go-back
        local component_path = component_match:gsub("%.", "/")
        local component_file = laravel_root .. "/resources/views/components/" .. component_path .. ".blade.php"

        if vim.fn.filereadable(component_file) == 1 then
            table.insert(results, {
                file = component_file,
                description = "Blade component: x-" .. component_match,
                type = "component",
            })
        end
    end

    return results
end

return M
