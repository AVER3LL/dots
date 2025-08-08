-- View references: view('users.index') → resources/views/users/index.blade.php

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "view%s*%(" or line:match "@extends%s*%(" or line:match "@include%s*%(" then
        local view_path = quoted_content:gsub("%.", "/") .. ".blade.php"
        local view_file = laravel_root .. "/resources/views/" .. view_path

        if vim.fn.filereadable(view_file) == 1 then
            table.insert(results, {
                file = view_file,
                description = "Blade view: " .. quoted_content,
                type = "view",
            })
        end
    end

    return results
end

return M
