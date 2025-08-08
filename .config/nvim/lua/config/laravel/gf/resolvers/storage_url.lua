local M = {}

M.resolve_storage_url = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content or not line:match "Storage::url%s*%(" then
        return results
    end

    -- Map Storage::url() → storage/app/public/
    local physical_path = laravel_root .. "/storage/app/public/" .. quoted_content

    if vim.fn.filereadable(physical_path) == 1 then
        table.insert(results, {
            file = physical_path,
            description = "Storage::url → " .. physical_path,
            type = "storage_url",
        })
    end

    return results
end

return M
