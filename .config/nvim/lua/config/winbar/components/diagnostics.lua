local icons = require("icons").diagnostics
local fn = vim.fn

local M = {}

--- @class diagnostic_configs
--- @field count integer
--- @field icon string
--- @field hl string

--- Format the diagnostics
--- @param diagnostic_configs diagnostic_configs[]
--- @return string, string
local function format_diagnostics(diagnostic_configs)
    local parts = {}
    local plain_parts = {}

    for _, config in ipairs(diagnostic_configs) do
        if config.count > 0 then
            table.insert(parts, ("%%#%s# %s %d %%*"):format(config.hl, config.icon, config.count))
            table.insert(plain_parts, (" %s %d "):format(config.icon, config.count))
        end
    end

    return table.concat(parts), table.concat(plain_parts)
end

--- Get diagnostic counts and build diagnostic_configs
--- @return diagnostic_configs[]
local function get_diagnostic_configs()
    local counts = vim.diagnostic.count(0)

    return {
        { count = counts[vim.diagnostic.severity.ERROR] or 0, icon = icons.ERROR, hl = "WinBarDiagError" },
        { count = counts[vim.diagnostic.severity.WARN] or 0, icon = icons.WARN, hl = "WinBarDiagWarn" },
        { count = counts[vim.diagnostic.severity.INFO] or 0, icon = icons.INFO, hl = "WinBarDiagInfo" },
        { count = counts[vim.diagnostic.severity.HINT] or 0, icon = icons.HINT, hl = "WinBarDiagHint" },
    }
end

--- Calculate the space needed for diagnostics without formatting
--- @param config Config
--- @param state WinBarState
--- @return integer space_needed
M.calculate_space = function(config, state)
    if (not config.show_diagnostics) or state.insert_mode_modified then
        return 0
    end

    local diagnostic_configs = get_diagnostic_configs()
    local parts = {}

    for _, diag_config in ipairs(diagnostic_configs) do
        if diag_config.count > 0 then
            table.insert(parts, (" %s %d "):format(diag_config.icon, diag_config.count))
        end
    end

    if #parts == 0 then
        return 0
    end

    local plain_content = table.concat(parts)
    return fn.strdisplaywidth(plain_content)
end

--- Get diagnostic counts with colors
--- @param config Config
--- @param state WinBarState
--- @return string colored_result, string plain_result
M.get = function(config, state)
    if (not config.show_diagnostics) or state.insert_mode_modified then
        return "", ""
    end

    local counts = vim.diagnostic.count(0)

    if #counts == 0 then
        return "", ""
    end

    local diagnostic_configs = get_diagnostic_configs()
    return format_diagnostics(diagnostic_configs)
end

return M
