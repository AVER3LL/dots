local M = {}

local snacks = require "snacks"
M.is_laravel_project = function()
    return vim.fn.filereadable "artisan" == 1
end

M.get_laravel_root = function()
    local artisan_path = vim.fn.findfile("artisan", ".;")
    if artisan_path ~= "" then
        return vim.fn.fnamemodify(artisan_path, ":h")
    end
    return vim.fn.getcwd()
end

M.create_picker = function(title, patterns, file_filter, strip_prefix)
    if not M.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local laravel_root = M.get_laravel_root()
    local files = {}
    local name_to_entries = {}

    for _, pattern in ipairs(patterns) do
        local full_pattern = laravel_root .. "/" .. pattern
        local matched = vim.fn.glob(full_pattern, false, true)
        for _, file in ipairs(matched) do
            local base = vim.fn.fnamemodify(file, ":t:r")
            local rel_path = vim.fn.fnamemodify(file, ":~:.")
            local relative_dir = vim.fn.fnamemodify(rel_path, ":h")

            -- Strip prefix from relative_dir
            if strip_prefix and relative_dir:find(strip_prefix, 1, true) == 1 then
                relative_dir = relative_dir:sub(#strip_prefix + 1)
                if relative_dir:sub(1, 1) == "/" then
                    relative_dir = relative_dir:sub(2)
                end
            end

            if relative_dir == "" or relative_dir == "." then
                relative_dir = nil
            end

            if not file_filter or file_filter(base) then
                table.insert(files, {
                    name = base,
                    path = relative_dir,
                    file = file,
                })

                name_to_entries[base] = (name_to_entries[base] or 0) + 1
            end
        end
    end

    -- Add formatted text and sort key
    for _, item in ipairs(files) do
        local needs_disambiguation = name_to_entries[item.name] > 1
        if needs_disambiguation and item.path then
            item.text = item.name .. " (" .. item.path .. ")"
        else
            item.text = item.name
        end
        item.search_key = item.name
        item.sort_key = item.name
    end

    table.sort(files, function(a, b)
        return a.sort_key < b.sort_key
    end)

    if #files == 0 then
        vim.notify("No matching files found in " .. title, vim.log.levels.WARN)
        return
    end

    snacks.picker.pick {
        name = title,
        layout = "vscode",
        items = files,
        format = function(item)
            local name, path = string.match(item.text, "^(.-)%s%((.+)%)$")
            if name and path then
                return {
                    { name, "SnacksPickerFile" },
                    { " (" .. path .. ")", "Comment" },
                }
            else
                return { { item.text, "SnacksPickerFile" } }
            end
        end,
        confirm = function(picker, item)
            if item then
                picker:close()
                vim.cmd("edit " .. item.file)
            end
        end,
    }
end

return M
