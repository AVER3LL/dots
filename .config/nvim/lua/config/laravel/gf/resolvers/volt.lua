-- Volt route references: Volt::route('categories/', 'categories.index') → resources/views/livewire/categories/index.blade.php

local M = {}

M.resolve = function(line, laravel_root, _)
    local results = {}

    if line:match "Volt::route%s*%(" then
        -- Extract the second parameter which is the component path
        local volt_patterns = {
            "Volt::route%s*%([^,]*,%s*['\"]([^'\"]*)['\"]",
            "Volt::route%s*%([^,]*,%s*['\"]([^'\"]*)['\"]",
        }

        for _, pattern in ipairs(volt_patterns) do
            local volt_component = line:match(pattern)
            if volt_component then
                local volt_path = volt_component:gsub("%.", "/") .. ".blade.php"
                local volt_file = laravel_root .. "/resources/views/livewire/" .. volt_path

                if vim.fn.filereadable(volt_file) == 1 then
                    table.insert(results, {
                        file = volt_file,
                        description = "Volt component: " .. volt_component,
                        type = "volt",
                    })
                end
                break
            end
        end
    end

    return results
end

return M
