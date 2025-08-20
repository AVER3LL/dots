local api, fn = vim.api, vim.fn

local buffer_utils = require "config.winbar.utils.buffer"
local builder = require "config.winbar.builder"
local components = require "config.winbar.components"
local state_manager = require "config.winbar.state"
local window_utils = require "config.winbar.utils.windows"

local M = {}

--- Update the winbar for current window
--- @param config Config
--- @param is_active boolean
function M.update_winbar(config, is_active)
    local bufnr = api.nvim_get_current_buf()
    local win_state = state_manager.get_or_create_state(bufnr, is_active)

    local filename = fn.expand "%:t"

    -- Early exit conditions
    if
        filename == ""
        or buffer_utils.should_ignore_buffer(config)
        or window_utils.is_window_too_small(config)
        or window_utils.is_popup_or_floating_window()
    then
        vim.wo.winbar = ""
        return
    end

    local win_width = api.nvim_win_get_width(0)

    -- Build components with smart space management
    local component_list = builder.build_components_smart(config, win_state, win_width)

    -- Assemble content
    local final_content, plain_content, content_width = builder.shrink_components(component_list, config, win_width)

    -- Final fallback to just filename if still too wide
    if content_width >= win_width - 4 then
        local minimal_colored, _ = components.filename.get(config, win_state)
        local minimal_plain = fn.expand "%:t"
        local minimal_width = fn.strdisplaywidth(minimal_plain)

        if minimal_width < win_width - 4 then
            local padding = math.max(math.floor((win_width - minimal_width) / 2), 0)
            vim.wo.winbar = string.rep(" ", padding) .. minimal_colored
        else
            vim.wo.winbar = ""
        end
        return
    end

    -- Center the content
    local padding = math.max(math.floor((win_width - content_width) / 2), 0)
    vim.wo.winbar = string.rep(" ", padding) .. final_content
end

--- Update all windows displaying the same buffer
--- @param config Config
--- @param bufnr integer
function M.update_all_windows_for_buffer(config, bufnr)
    local current_win = api.nvim_get_current_win()
    local windows = window_utils.get_windows_for_buffer(bufnr)

    for _, win in ipairs(windows) do
        local is_current = win == current_win
        api.nvim_win_call(win, function()
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                M.update_winbar(config, is_current)
            else
                vim.wo.winbar = ""
            end
        end)
    end
end

--- Update all visible windows
--- @param config Config
function M.update_all_visible_windows(config)
    local current_win = api.nvim_get_current_win()
    local windows = window_utils.get_all_visible_windows()

    for _, win in ipairs(windows) do
        api.nvim_win_call(win, function()
            local is_current = win == current_win
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                M.update_winbar(config, is_current)
            else
                vim.wo.winbar = ""
            end
        end)
    end
end

return M
