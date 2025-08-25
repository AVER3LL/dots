local M = {}

--- @class WinBarState
--- @field is_active boolean
--- @field insert_mode_modified boolean
--- @field available_space integer

--- @type table<integer, WinBarState>
local state = {} -- keyed by win_id

--- Create new state for a window
--- @param is_active boolean
--- @return WinBarState
function M.new_state(is_active)
    return {
        is_active = is_active or true,
        insert_mode_modified = false,
        available_space = 0,
    }
end

--- Get or create state for a window
--- @param win_id integer
--- @param is_active boolean
--- @return WinBarState
function M.get_or_create_state(win_id, is_active)
    if not state[win_id] then
        state[win_id] = M.new_state(is_active)
    end
    state[win_id].is_active = is_active
    return state[win_id]
end

--- Update state for a window
--- @param win_id integer
--- @param updates table
function M.update_state(win_id, updates)
    if state[win_id] then
        for key, value in pairs(updates) do
            state[win_id][key] = value
        end
    end
end

--- Clean up state for a window
--- @param win_id integer
function M.cleanup_state(win_id)
    state[win_id] = nil
end

--- Get state for a window (may be nil)
--- @param win_id integer
--- @return WinBarState|nil
function M.get_state(win_id)
    return state[win_id]
end

return M
