-- Optimized init.lua preserving the original clean resolver architecture
local helpers = require "config.laravel.gf.helpers"
local snacks = require "snacks"
local utils = require "config.laravel.utils"

local M = {}

-- Global cache for performance optimization
local cache = {
    laravel_root = nil,
    resolvers = nil,
}

-- Lazy load resolvers only once
---@return table
local function get_resolvers()
    if not cache.resolvers then
        cache.resolvers = require "config.laravel.gf.resolvers"
    end
    return cache.resolvers
end

-- Function to generate all caches upfront
M.generate_all_caches = function()
    cache.laravel_root = utils.get_laravel_root()
    cache.resolvers = require "config.laravel.gf.resolvers"

    vim.notify("Cache generated", vim.log.levels.INFO)
end

-- Cache Laravel root to avoid repeated filesystem checks
local function get_laravel_root_cached()
    if not cache.laravel_root then
        cache.laravel_root = utils.get_laravel_root()
    end
    return cache.laravel_root
end

M.goto_file_under_cursor = function()
    -- If not in a Laravel project, use default gf
    if not utils.is_laravel_project() then
        helpers.default_gf()
        return
    end

    local laravel_root = get_laravel_root_cached()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1

    local quoted_content = helpers.extract_quoted_string(line, col)
    local possible_files = {}
    local resolvers = get_resolvers()

    -- Process resolvers and collect results
    for _, resolver in ipairs(resolvers) do
        -- Use pcall to prevent one resolver from breaking others
        local success, results = pcall(resolver.resolve, line, laravel_root, quoted_content)
        if success and results and #results > 0 then
            vim.list_extend(possible_files, results)
        end
    end

    -- If no Laravel-specific files found, fallback to default gf
    if #possible_files == 0 then
        helpers.default_gf()
        return
    end

    -- If only one file found, open it directly (fastest path)
    if #possible_files == 1 then
        local file_info = possible_files[1]
        vim.cmd("edit " .. file_info.file)
        if file_info.line then
            vim.api.nvim_win_set_cursor(0, { file_info.line, 0 })
        end
        return
    end

    -- Multiple files found, show picker
    -- Pre-process items for picker to avoid doing it in format function
    for _, file_info in ipairs(possible_files) do
        file_info.text = file_info.description
        file_info.search_key = file_info.description
    end

    snacks.picker.pick {
        -- name = "Laravel Files" .. (quoted_content and (": " .. quoted_content) or ""),
        name = "Laravel Files for: " .. quoted_content,
        layout = "vscode",
        items = possible_files,
        format = function(item)
            return {
                { item.description, "SnacksPickerFile" },
                { " [" .. item.type .. "]", "Comment" },
            }
        end,
        confirm = function(picker, item)
            if item then
                picker:close()
                vim.cmd("edit " .. item.file)
                if item.line then
                    vim.api.nvim_win_set_cursor(0, { item.line, 0 })
                end
            end
        end,
    }
end

return M
