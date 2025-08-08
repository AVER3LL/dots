-- Inertia references: Inertia::render('Dashboard') → resources/js/Pages/Dashboard.tsx

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "Inertia::render%s*%(" or line:match "inertia%s*%(" then
        local inertia_extensions = { ".tsx", ".jsx", ".vue", ".js", ".ts" }
        local inertia_path = quoted_content:gsub("%.", "/")

        for _, ext in ipairs(inertia_extensions) do
            local inertia_file = laravel_root .. "/resources/js/pages/" .. inertia_path .. ext
            if vim.fn.filereadable(inertia_file) == 1 then
                table.insert(results, {
                    file = inertia_file,
                    description = "Inertia page: " .. quoted_content,
                    type = "inertia",
                })
                break
            end
        end
    end

    return results
end

return M
