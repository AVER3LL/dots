local snacks = require "snacks"
local utils = require "config.laravel.utils"

local helpers = require "config.laravel.gf.helpers"

local M = {}

-- Helper function to execute default gf behavior

M.goto_file_under_cursor = function()
    -- If not in a Laravel project, use default gf
    if not utils.is_laravel_project() then
        helpers.default_gf()
        return
    end

    local laravel_root = utils.get_laravel_root()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1

    local quoted_content = helpers.extract_quoted_string(line, col)

    -- If no quoted string found, try default gf
    -- if not quoted_content then
    --     helpers.default_gf()
    --     return
    -- end

    local possible_files = {}

    local resolvers = require "config.laravel.gf.resolvers"

    for _, resolver in ipairs(resolvers) do
        local results = resolver.resolve(line, laravel_root, quoted_content)
        vim.list_extend(possible_files, results)
    end

    -- If no Laravel-specific files found, fallback to default gf
    if #possible_files == 0 then
        helpers.default_gf()
        return
    end

    -- If only one file found, open it directly
    if #possible_files == 1 then
        local file_info = possible_files[1]
        vim.cmd("edit " .. file_info.file)
        if file_info.line then
            vim.api.nvim_win_set_cursor(0, { file_info.line, 0 })
        end
        -- vim.notify("Opened: " .. file_info.description, vim.log.levels.INFO)
        return
    end

    -- Multiple files found, show picker
    for _, file_info in ipairs(possible_files) do
        file_info.text = file_info.description
        file_info.search_key = file_info.description
    end

    snacks.picker.pick {
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
