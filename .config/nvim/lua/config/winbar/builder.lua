local fn = vim.fn
local components = require "config.winbar.components"

local M = {}

--- Build winbar components with space-aware logic
--- @param config Config
--- @param win_state WinBarState
--- @param win_width integer
--- @return table components
function M.build_components_smart(config, win_state, win_width)
    local results = {}

    -- Precompute special values
    local filename_colored, filename_plain = components.filename.get(config, win_state)
    local filename_width = fn.strdisplaywidth(filename_plain or "")

    local diagnostics_space = components.diagnostics.calculate_space
            and components.diagnostics.calculate_space(config, win_state)
        or 0

    local base_padding = config.min_padding * 4
    local remaining_space = win_width - filename_width - diagnostics_space - base_padding
    win_state.available_space = math.max(remaining_space, 0)

    for _, spec in ipairs(config.component_order) do
        local comp = components[spec.name]
        if not comp then
            goto continue
        end

        local colored, plain = comp.get(config, win_state)

        -- handle path being space-aware
        if spec.name == "path" and remaining_space <= 10 then
            goto continue
        end

        if colored ~= "" then
            table.insert(results, {
                content = colored,
                plain = plain,
                priority = spec.priority,
            })
        end

        ::continue::
    end

    return results
end

--- Try to shrink component list by dropping lowest-priority items
--- @param component_list table
--- @param config Config
--- @param win_width integer
--- @return string final_content, string plain_content, integer content_width
M.shrink_components = function(component_list, config, win_width)
    local final, plain, width = M.assemble_content(config, component_list)

    if width >= win_width - 4 then
        table.sort(component_list, function(a, b)
            return a.priority < b.priority -- lowest priority last
        end)

        while #component_list > 1 and width >= win_width - 4 do
            table.remove(component_list) -- drop lowest priority
            final, plain, width = M.assemble_content(config, component_list)
        end
    end

    return final, plain, width
end

--- Assemble final winbar content from components
--- @param config Config
--- @param component_list table
--- @return string final_content, string plain_content, integer content_width
function M.assemble_content(config, component_list)
    local content_parts = {}
    local plain_parts = {}

    for i, comp in ipairs(component_list) do
        if comp.content and comp.content ~= "" then
            if i > 1 then
                local spacing = string.rep(" ", config.min_padding)
                table.insert(content_parts, spacing)
                table.insert(plain_parts, spacing)
            end
            table.insert(content_parts, comp.content)
            table.insert(plain_parts, comp.plain or "")
        end
    end

    local final_content = table.concat(content_parts)
    local plain_content = table.concat(plain_parts)
    local content_width = fn.strdisplaywidth(plain_content)

    return final_content, plain_content, content_width
end

return M
