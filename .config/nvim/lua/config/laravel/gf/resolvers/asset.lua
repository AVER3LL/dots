-- Asset references: asset('js/flowbite.js') → public/js/flowbite.js

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "asset%s*%(" then
        local asset_file = laravel_root .. "/public/" .. quoted_content

        if vim.fn.filereadable(asset_file) == 1 then
            table.insert(results, {
                file = asset_file,
                description = "Asset: " .. quoted_content,
                type = "asset",
            })
        end
    end

    return results
end

return M
