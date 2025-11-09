local api = vim.api

local buffer_utils = require "config.winbar.utils.buffer"
local cache = require "config.winbar.cache"
local config_module = require "config.winbar.config"
local state_manager = require "config.winbar.state"
local updater = require "config.winbar.updater"
local window_utils = require "config.winbar.utils.windows"

local M = {}

-- Global debounce timer
local update_timer = nil

--- Debounced update function
--- @param config Config
--- @param is_active boolean
local function debounced_update(config, is_active)
    if update_timer then
        update_timer:stop()
    end
    update_timer = vim.uv.new_timer()
    ---@diagnostic disable-next-line: need-check-nil
    update_timer:start(
        config_module.CONSTANTS.DEBOUNCE_MS,
        0,
        vim.schedule_wrap(function()
            updater.update_winbar(config, is_active)
        end)
    )
end

--- Set up highlight groups
local function set_highlights()
    local sethl = api.nvim_set_hl
    local gethl = api.nvim_get_hl

    -- Get diagnostic colors with fallbacks
    local colors = {
        error = gethl(0, { name = "DiagnosticError" }).fg or 0xFF6B6B,
        warn = gethl(0, { name = "DiagnosticWarn" }).fg or 0xE0AF68,
        info = gethl(0, { name = "DiagnosticInfo" }).fg or 0x6BCF7F,
        hint = gethl(0, { name = "DiagnosticHint" }).fg or 0xA8A8A8,
        path = 0x888888,
    }

    -- Set highlight groups
    sethl(0, "WinBarDiagError", { fg = colors.error, bold = true })
    sethl(0, "WinBarDiagWarn", { fg = colors.warn, bold = true })
    sethl(0, "WinBarDiagInfo", { fg = colors.info, bold = true })
    sethl(0, "WinBarDiagHint", { fg = colors.hint })
    sethl(0, "WinBarPath", { fg = colors.path, italic = true })
    sethl(0, "WinBarReadonly", { fg = colors.path, bold = true })
    -- sethl(0, "WinBarModified", { fg = colors.path, bold = true })
end

--- Setup all autocommands
--- @param config Config
function M.setup_autocmds(config)
    local autocmd = api.nvim_create_autocmd
    local group = api.nvim_create_augroup("CustomWinBar", { clear = true })

    -- Window cleanup
    autocmd("WinClosed", {
        group = group,
        callback = function(args)
            local win_id = tonumber(args.match)
            if win_id then
                pcall(api.nvim_set_hl, 0, "WinBarFileIcon" .. win_id, {})
                state_manager.cleanup_state(win_id)
            end
        end,
    })

    -- Buffer cache cleanup
    autocmd("BufWipeout", {
        group = group,
        pattern = "*",
        callback = function(args)
            cache.cleanup_buf_cache(args.buf)
        end,
    })

    -- Colorscheme updates
    autocmd("ColorScheme", {
        group = group,
        callback = set_highlights,
    })

    -- Handle popup/telescope closing
    autocmd("BufLeave", {
        group = group,
        pattern = "*",
        callback = function()
            local ft = buffer_utils.get_filetype()
            if
                ft == "TelescopePrompt"
                or ft == "TelescopeResults"
                or ft == "telescope"
                or ft == "snacks_picker_input"
                or ft == "snacks_input"
            then
                vim.schedule(function()
                    updater.update_all_visible_windows(config)
                end)
            end
        end,
    })

    -- Special handling for DiagnosticChanged to update all windows with the same buffer
    autocmd("DiagnosticChanged", {
        group = group,
        callback = function(args)
            local bufnr = args.buf
            if bufnr and api.nvim_buf_is_valid(bufnr) then
                cache.invalidate_diagnostics(bufnr)
                updater.update_all_windows_for_buffer(config, bufnr)
            end
        end,
    })

    -- Insert mode text change tracking
    autocmd("TextChangedI", {
        group = group,
        callback = function()
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                local win_id = api.nvim_get_current_win()
                state_manager.update_state(win_id, { insert_mode_modified = true })
                debounced_update(config, true)
                -- Check if buffer modified state changed and update all windows if so
                local bufnr = api.nvim_get_current_buf()
                if cache.modified_changed(bufnr) then
                    vim.schedule(function()
                        updater.update_all_windows_for_buffer(config, bufnr)
                    end)
                end
            end
        end,
    })

    -- Reset insert mode flag
    autocmd("InsertLeave", {
        group = group,
        callback = function()
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                local win_id = api.nvim_get_current_win()
                state_manager.update_state(win_id, { insert_mode_modified = false })
                debounced_update(config, true)
            else
                vim.wo.winbar = ""
            end
        end,
    })

    autocmd("InsertEnter", {
        group = group,
        callback = function()
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                local win_id = api.nvim_get_current_win()
                state_manager.update_state(win_id, { insert_mode_modified = false })
                debounced_update(config, true)
            end
        end,
    })

    -- Debounced updates for frequent events
    autocmd("TextChanged", {
        group = group,
        callback = function()
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                debounced_update(config, true)
                -- Check if buffer modified state changed and update all windows if so
                local bufnr = api.nvim_get_current_buf()
                if cache.modified_changed(bufnr) then
                    vim.schedule(function()
                        updater.update_all_windows_for_buffer(config, bufnr)
                    end)
                end
            else
                vim.wo.winbar = ""
            end
        end,
    })

    -- Immediate updates for other events
    autocmd({
        "BufEnter",
        "BufFilePost",
        "BufWinEnter",
        "BufWritePost",
        "ColorScheme",
        "WinEnter",
        "WinResized",
    }, {
        group = group,
        callback = function(args)
            if args.event == "BufWritePost" then
                cache.invalidate_all_for_buf(args.buf)
                -- Update all windows showing this buffer since modified state changed
                updater.update_all_windows_for_buffer(config, args.buf)
                return
            end
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                updater.update_winbar(config, true)
            else
                vim.wo.winbar = ""
            end
        end,
    })

    autocmd("VimResized", {
        group = group,
        callback = function()
            updater.update_all_visible_windows(config)
        end,
    })

    -- Update when inactive
    autocmd("WinLeave", {
        group = group,
        callback = function()
            if
                not buffer_utils.should_ignore_buffer(config)
                and not window_utils.is_window_too_small(config)
                and not window_utils.is_popup_or_floating_window()
            then
                updater.update_winbar(config, false)
            else
                vim.wo.winbar = ""
            end
        end,
    })

    -- NvimTree specific handling
    autocmd("FileType", {
        group = group,
        pattern = "NvimTree",
        callback = function()
            local tree_group = api.nvim_create_augroup("CustomWinBarNvimTree", { clear = false })
            autocmd({ "BufEnter", "BufLeave" }, {
                group = tree_group,
                buffer = 0,
                callback = function()
                    vim.schedule(function()
                        updater.update_all_visible_windows(config)
                    end)
                end,
            })
        end,
    })

    -- Initialize highlights
    set_highlights()
end

return M
