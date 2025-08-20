local api = vim.api

local M = {}

--- Check if window is too small for winbar
--- @param config Config
--- @return boolean
function M.is_window_too_small(config)
    local win_width = api.nvim_win_get_width(0)
    local win_height = api.nvim_win_get_height(0)
    return win_width < config.min_window_width or win_height < 3
end

--- Check if we're in a popup or floating window
--- @return boolean
function M.is_popup_or_floating_window()
    local win_config = api.nvim_win_get_config(0)
    return win_config.relative ~= ""
end

--- Get current window dimensions
--- @return integer width, integer height
function M.get_window_dimensions()
    return api.nvim_win_get_width(0), api.nvim_win_get_height(0)
end

--- Calculate available space for components
--- @param win_width integer
--- @param filename string
--- @param icon string
--- @param config Config
--- @return integer
function M.calculate_available_space(win_width, filename, icon, config)
    local base_content = icon .. " " .. filename
    local base_width = vim.fn.strdisplaywidth(base_content)
    local padding = config.min_padding * 2
    local available_space = win_width - base_width - padding * 2
    return math.max(available_space, 0)
end

--- Get all windows displaying a specific buffer
--- @param bufnr integer
--- @return integer[]
function M.get_windows_for_buffer(bufnr)
    local windows = {}
    for _, win in ipairs(api.nvim_list_wins()) do
        if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == bufnr then
            table.insert(windows, win)
        end
    end
    return windows
end

--- Get all valid visible windows
--- @return integer[]
function M.get_all_visible_windows()
    local windows = {}
    for _, win in ipairs(api.nvim_list_wins()) do
        if api.nvim_win_is_valid(win) then
            local bufnr = api.nvim_win_get_buf(win)
            if api.nvim_buf_is_valid(bufnr) then
                table.insert(windows, win)
            end
        end
    end
    return windows
end

return M
