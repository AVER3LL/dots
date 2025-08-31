local M = {}

M.icons = {
    model = { icon = "󰆼 ", hl = "Type" }, -- models = core data structures
    middleware = { icon = " ", hl = "Macro" }, -- sits in between, like filters
    controller = { icon = "󰺵 ", hl = "Function" }, -- controllers = actions
    migration = { icon = "󰓫 ", hl = "Number" }, -- versioned files, number-ish
    factory = { icon = "󰈏 ", hl = "Constructor" }, -- generates models
    seeder = { icon = " ", hl = "String" }, -- seeds with content
    listener = { icon = "󰟅 ", hl = "Identifier" }, -- listens for events
    resource = { icon = "󰥶 ", hl = "Structure" }, -- resources = API structure
    policy = { icon = "󰒃 ", hl = "Conditional" }, -- allows / denies actions
    test = { icon = "󰙨 ", hl = "Debug" }, -- testing / debugging
    request = { icon = " ", hl = "Keyword" }, -- validation layer
    job = { icon = " ", hl = "Special" }, -- background tasks
    event = { icon = " ", hl = "Constant" }, -- events = constants triggering flow

    -- 🔥 New ones
    lang = { icon = "󰂖 ", hl = "String" }, -- language files (JSON/PHP)
    view = { icon = " ", hl = "LaravelLogo" }, -- Blade templates
    config = { icon = "󰒓 ", hl = "Constant" }, -- config/*.php
    provider = { icon = "󰗚 ", hl = "Type" }, -- service providers
    command = { icon = "󰘳 ", hl = "Function" }, -- artisan commands
    route = { icon = "󰣖 ", hl = "Keyword" }, -- routes/web.php, api.php
}

local snacks = require "snacks"
M.is_laravel_project = function()
    return vim.loop.fs_stat "artisan" ~= nil -- faster than filereadable
end

M.get_laravel_root = function()
    local artisan_path = vim.fn.findfile("artisan", ".;")
    if artisan_path ~= "" then
        return vim.fn.fnamemodify(artisan_path, ":h")
    end
    return vim.fn.getcwd()
end

M.create_picker = function(title, patterns, file_filter, strip_prefix, key)
    if not M.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local laravel_root = M.get_laravel_root()

    -- Combine all patterns into one big glob (less syscalls)
    local all_files = {}
    for _, pattern in ipairs(patterns) do
        local matched = vim.fn.globpath(laravel_root, pattern, true, true)
        for _, file in ipairs(matched) do
            table.insert(all_files, file)
        end
    end

    local files = {}
    local name_to_entries = {}
    local prefix_len = strip_prefix and #strip_prefix or 0

    for _, file in ipairs(all_files) do
        local base = file:match "([^/]+)%.php$"
        if base and (not file_filter or file_filter(base)) then
            local rel_path = file:sub(#laravel_root + 2) -- relative to project root
            local relative_dir = rel_path:match "(.+)/[^/]+$"

            -- Strip prefix quickly
            if strip_prefix and relative_dir and relative_dir:sub(1, prefix_len) == strip_prefix then
                relative_dir = relative_dir:sub(prefix_len + 1)
                if relative_dir:sub(1, 1) == "/" then
                    relative_dir = relative_dir:sub(2)
                end
            end

            if relative_dir == "" then
                relative_dir = nil
            end

            table.insert(files, {
                name = base,
                path = relative_dir,
                file = file,
            })

            name_to_entries[base] = (name_to_entries[base] or 0) + 1
        end
    end

    -- Second pass: formatting & sorting
    for _, item in ipairs(files) do
        if name_to_entries[item.name] > 1 and item.path then
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
        title = title,
        layout = "vscode",
        items = files,
        format = function(item)
            -- look up pretty icon from the key
            local pretty = M.icons[key] or { icon = "", hl = "SnacksPickerFile" }

            local name, path = item.text:match "^(.-)%s%((.+)%)$"
            if name and path then
                return {
                    { pretty.icon .. " ", pretty.hl },
                    { name, "SnacksPickerFile" },
                    { " (" .. path .. ")", "Comment" },
                }
            else
                return {
                    { pretty.icon .. " ", pretty.hl },
                    { item.text, "SnacksPickerFile" },
                }
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
