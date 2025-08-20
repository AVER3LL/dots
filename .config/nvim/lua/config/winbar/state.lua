local M = {}

--- @class WinBarState
--- @field is_active boolean
--- @field insert_mode_modified boolean
--- @field available_space integer

--- @type table<integer, WinBarState>
local state = {}

--- Create new state for a buffer/window
--- @param is_active boolean
--- @return WinBarState
function M.new_state(is_active)
    return {
        is_active = is_active or true,
        insert_mode_modified = false,
        available_space = 0,
    }
end

--- Get or create state for a buffer
--- @param bufnr integer
--- @param is_active boolean
--- @return WinBarState
function M.get_or_create_state(bufnr, is_active)
    if not state[bufnr] then
        state[bufnr] = M.new_state(is_active)
    end
    state[bufnr].is_active = is_active
    return state[bufnr]
end

--- Update state for a buffer
--- @param bufnr integer
--- @param updates table
function M.update_state(bufnr, updates)
    if state[bufnr] then
        for key, value in pairs(updates) do
            state[bufnr][key] = value
        end
    end
end

--- Clean up state for a buffer/window
--- @param id integer
function M.cleanup_state(id)
    state[id] = nil
end

--- Get state for a buffer (may be nil)
--- @param bufnr integer
--- @return WinBarState|nil
function M.get_state(bufnr)
    return state[bufnr]
end

return M
