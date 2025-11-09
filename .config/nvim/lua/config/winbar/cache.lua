local M = {}

local file_icon_cache = {} -- bufnr -> {icon, color}
local diagnostics_cache = {} -- bufnr -> {counts table}
local modified_cache = {} -- bufnr -> boolean

--- Get file icon from cache or compute and cache it
--- @param bufnr integer
--- @return string icon, string color
function M.get_file_icon(bufnr)
    if file_icon_cache[bufnr] then
        return file_icon_cache[bufnr].icon, file_icon_cache[bufnr].color
    end

    local icon, color = require("config.winbar.utils.file").compute_icon_for_buf(bufnr)
    file_icon_cache[bufnr] = { icon = icon, color = color }
    return icon, color
end

--- Get diagnostics from cache or compute and cache them
--- @param bufnr integer
--- @return table counts
function M.get_diagnostics(bufnr)
    if diagnostics_cache[bufnr] then
        return diagnostics_cache[bufnr]
    end

    local counts = vim.diagnostic.count(bufnr)
    diagnostics_cache[bufnr] = counts
    return counts
end

--- Invalidate diagnostics cache for a buffer
--- @param bufnr integer
function M.invalidate_diagnostics(bufnr)
    diagnostics_cache[bufnr] = nil
end

--- Invalidate all caches for a buffer
--- @param bufnr integer
function M.invalidate_all_for_buf(bufnr)
    diagnostics_cache[bufnr] = nil
    file_icon_cache[bufnr] = nil
end

--- Get modified state from cache
--- @param bufnr integer
--- @return boolean
function M.get_modified(bufnr)
    return modified_cache[bufnr] or false
end

--- Set modified state in cache
--- @param bufnr integer
--- @param modified boolean
function M.set_modified(bufnr, modified)
    modified_cache[bufnr] = modified
end

--- Check if modified state changed and update cache
--- @param bufnr integer
--- @return boolean changed
function M.modified_changed(bufnr)
    local current = vim.bo[bufnr].modified
    local previous = modified_cache[bufnr]
    if previous == nil then
        -- Initialize
        modified_cache[bufnr] = current
        return false
    elseif current ~= previous then
        modified_cache[bufnr] = current
        return true
    end
    return false
end

--- Cleanup caches for a buffer
--- @param bufnr integer
function M.cleanup_buf_cache(bufnr)
    file_icon_cache[bufnr] = nil
    diagnostics_cache[bufnr] = nil
    modified_cache[bufnr] = nil
end

return M
