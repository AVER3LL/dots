-- Storage references: storage_path('framework/cache/data/.gitignore') → storage/framework/cache/data/.gitignore

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "storage_path%s*%(" then
        local storage_file = laravel_root .. "/storage/" .. quoted_content

        if vim.fn.filereadable(storage_file) == 1 then
            table.insert(results, {
                file = storage_file,
                description = "Storage: " .. quoted_content,
                type = "storage",
            })
        end
    end

    return results
end

return M
