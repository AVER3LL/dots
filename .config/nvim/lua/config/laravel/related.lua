-- related.lua - Clean implementation following the established patterns
local snacks = require "snacks"
local utils = require "config.laravel.utils"

local M = {}

-- File type patterns with their corresponding Laravel structure
local FILE_PATTERNS = {
    {
        type = "model",
        label = "Model",
        patterns = {
            "app/Models/**/{name}.php",
        },
    },
    {
        type = "controller",
        label = "Controller",
        patterns = { "app/Http/Controllers/**/{name}Controller.php" },
    },
    {
        type = "migration",
        label = "Migration",
        patterns = {
            "database/migrations/**/*create_{name}s_table.php",
            "database/migrations/**/*create_{name}_table.php",
            "database/migrations/**/*add_*_to_{name}s_table.php",
            "database/migrations/**/*add_*_to_{name}_table.php",
            "database/migrations/**/*modify_{name}s_table.php",
            "database/migrations/**/*modify_{name}_table.php",
            "database/migrations/**/*alter_{name}s_table.php",
            "database/migrations/**/*alter_{name}_table.php",
        },
    },
    {
        type = "factory",
        label = "Factory",
        patterns = { "database/factories/**/{name}Factory.php" },
    },
    {
        type = "seeder",
        label = "Seeder",
        patterns = {
            "database/seeders/**/{name}Seeder.php",
            "database/seeders/**/{name}sSeeder.php",
        },
    },
    {
        type = "request",
        label = "Request",
        patterns = {
            "app/Http/Requests/**/{name}Request.php",
            "app/Http/Requests/**/Store{name}Request.php",
            "app/Http/Requests/**/Update{name}Request.php",
        },
    },
    {
        type = "resource",
        label = "Resource",
        patterns = { "app/Http/Resources/**/{name}Resource.php" },
    },
    {
        type = "policy",
        label = "Policy",
        patterns = { "app/Policies/**/{name}Policy.php" },
    },
    {
        type = "test",
        label = "Test",
        patterns = {
            "tests/Unit/**/{name}Test.php",
            "tests/Feature/**/{name}Test.php",
        },
    },
    {
        type = "job",
        label = "Job",
        patterns = { "app/Jobs/**/{name}Job.php" },
    },
    {
        type = "event",
        label = "Event",
        patterns = { "app/Events/**/{name}Event.php" },
    },
    {
        type = "listener",
        label = "Listener",
        patterns = { "app/Listeners/**/{name}Listener.php" },
    },
    {
        type = "middleware",
        label = "Middleware",
        patterns = { "app/Http/Middleware/**/{name}Middleware.php" },
    },
}

-- Extract base name from filename by removing common Laravel suffixes
local function extract_base_name(filename)
    local base = filename:gsub("%.php$", "")

    -- Remove migration timestamp prefixes
    base = base:gsub("^%d+_%d+_%d+_%d+_", "")
    base = base:gsub("^create_", ""):gsub("^add_", ""):gsub("^update_", "")
    base = base:gsub("_table$", "")

    -- Remove common Laravel suffixes
    local suffixes = {
        "Controller",
        "Model",
        "Migration",
        "Seeder",
        "Factory",
        "Request",
        "Resource",
        "Job",
        "Event",
        "Listener",
        "Policy",
        "Provider",
        "Test",
        "Command",
        "Middleware",
    }

    for _, suffix in ipairs(suffixes) do
        base = base:gsub(suffix .. "$", "")
    end

    -- Convert plural to singular for better matching
    if base:match "s$" and #base > 1 then
        base = base:gsub("s$", "")
    end

    return base
end

-- Determine file type based on path
local function get_file_type(relative_path)
    local type_patterns = {
        { pattern = "^app/Http/Controllers/", type = "controller" },
        { pattern = "^app/Models/", type = "model" },
        { pattern = "^app/[^/]+%.php$", type = "model" },
        { pattern = "^database/migrations/", type = "migration" },
        { pattern = "^database/factories/", type = "factory" },
        { pattern = "^database/seeders/", type = "seeder" },
        { pattern = "^app/Http/Requests/", type = "request" },
        { pattern = "^app/Http/Resources/", type = "resource" },
        { pattern = "^app/Policies/", type = "policy" },
        { pattern = "^tests/", type = "test" },
        { pattern = "^app/Jobs/", type = "job" },
        { pattern = "^app/Events/", type = "event" },
        { pattern = "^app/Listeners/", type = "listener" },
        { pattern = "^app/Http/Middleware/", type = "middleware" },
    }

    for _, type_config in ipairs(type_patterns) do
        if relative_path:match(type_config.pattern) then
            return type_config.type
        end
    end

    return "unknown"
end

-- Get current file information
local function get_current_file_info()
    local current_file = vim.fn.expand "%:p"
    local filename = vim.fn.expand "%:t:r"
    local relative_path = vim.fn.expand "%:."

    return {
        current_file = current_file,
        filename = filename,
        relative_path = relative_path,
        file_type = get_file_type(relative_path),
        base_name = extract_base_name(filename),
    }
end

-- Find related files based on base name
local function find_related_files(base_name, current_file_type, laravel_root)
    local related_files = {}
    local capitalized_name = base_name:gsub("^%l", string.upper)
    local lowercase_name = base_name:lower()

    for _, pattern_config in ipairs(FILE_PATTERNS) do
        -- Skip current file type to avoid showing the same file
        if pattern_config.type ~= current_file_type then
            for _, pattern in ipairs(pattern_config.patterns) do
                -- Replace placeholder with appropriate name format
                local search_pattern = pattern
                if pattern_config.type == "migration" then
                    -- Migrations use lowercase names
                    search_pattern = pattern:gsub("{name}", lowercase_name)
                else
                    -- Most other types use capitalized names
                    search_pattern = pattern:gsub("{name}", capitalized_name)
                end

                -- Ensure we're searching recursively with **
                if not search_pattern:match "%*%*/" and pattern_config.type ~= "migration" then
                    -- Add /** for recursive search if not already present
                    local base_path = search_pattern:match "^([^*]+)/"
                    if base_path then
                        search_pattern = search_pattern:gsub("^" .. vim.pesc(base_path) .. "/", base_path .. "/**/")
                    end
                end

                local matched_files = vim.fn.globpath(laravel_root, search_pattern, true, true)

                for _, file in ipairs(matched_files) do
                    table.insert(related_files, {
                        file = file,
                        name = vim.fn.fnamemodify(file, ":t:r"),
                        text = pattern_config.label .. ": " .. vim.fn.fnamemodify(file, ":t:r"),
                        type = pattern_config.type,
                        sort_key = pattern_config.label,
                    })
                end
            end
        end
    end

    return related_files
end

-- Main function to find and display related files
M.find_related = function()
    if not utils.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local file_info = get_current_file_info()

    if file_info.base_name == "" then
        vim.notify("Could not determine base name for current file", vim.log.levels.WARN)
        return
    end

    local laravel_root = utils.get_laravel_root()
    local related_files = find_related_files(file_info.base_name, file_info.file_type, laravel_root)

    if #related_files == 0 then
        vim.notify("No related files found for: " .. file_info.base_name, vim.log.levels.INFO)
        return
    end

    -- Sort files by type for better organization
    table.sort(related_files, function(a, b)
        return a.sort_key < b.sort_key
    end)

    snacks.picker.pick {
        name = "Related Files: " .. file_info.base_name,
        layout = "vscode",
        items = related_files,
        format = function(item)
            local type_label, name = item.text:match "^(.-):%s(.+)$"
            if type_label and name then
                return {
                    { type_label .. ":", "Comment" },
                    { " " .. name, "SnacksPickerFile" },
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
