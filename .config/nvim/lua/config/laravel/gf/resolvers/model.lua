-- Model references: App\Models\User → app/Models/User.php

local M = {}

M.resolve = function(line, laravel_root, _)
    local results = {}

    if line:match "App\\Models\\" or line:match "App\\\\Models\\\\" then
        local model_match = line:match "App\\?\\?Models\\?\\?([%w\\]+)" or line:match "App\\Models\\([%w\\]+)"
        if model_match then
            local model_path = model_match:gsub("\\", "/")
            local model_file = laravel_root .. "/app/Models/" .. model_path .. ".php"

            if vim.fn.filereadable(model_file) == 1 then
                table.insert(results, {
                    file = model_file,
                    description = "Model: " .. model_match,
                    type = "model",
                })
            end
        end
    end

    return results
end

return M
