local icons = require("icons").diagnostics

--- @class CustomWinBar
--- @field config Config
--- @field update_winbar fun(is_active: boolean)
--- @field setup fun(user_config: Config|nil)
--- @field clear_caches fun()

-- Custom minimal centered winbar
local M = {}

-- Constants
local CONSTANTS = {
    DEBOUNCE_MS = 50,
    DEFAULT_PADDING = 2,
    CACHE_SIZE_LIMIT = 100, -- Prevent unlimited cache growth
    MIN_WINDOW_WIDTH = 30, -- Increased minimum window width
}

--- @class Config
--- @field show_diagnostics boolean
--- @field show_modified boolean
--- @field show_path_when_inactive boolean
--- @field min_padding integer
--- @field modified_icon string
--- @field ignore_filetypes string[]
--- @field ignore_buftypes string[]
--- @field cache_size_limit integer
--- @field min_window_width integer

--- @type Config
M.config = {
    show_diagnostics = true,
    show_modified = true,
    show_path_when_inactive = false,

    -- modified_icon = "✱",
    modified_icon = require("icons").misc.bullet,

    min_padding = CONSTANTS.DEFAULT_PADDING,
    cache_size_limit = CONSTANTS.CACHE_SIZE_LIMIT,
    min_window_width = CONSTANTS.MIN_WINDOW_WIDTH,

    ignore_filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "TelescopePrompt",
        "TelescopeResults",
        "telescope",
    },
    ignore_buftypes = {
        "nofile",
        "terminal",
        "help",
        "quickfix",
        "prompt",
    },
}

-- Caches
local icon_cache = {}
local highlight_cache = {}
local update_timer = nil

-- Store original highlight state to restore later
local original_highlights = {}

local function cleanup_window_highlights(win_id)
    local hl_name = "WinBarFileIcon" .. win_id
    if highlight_cache[hl_name] then
        -- Properly clear the highlight group
        vim.api.nvim_set_hl(0, hl_name, {})
        highlight_cache[hl_name] = nil
        original_highlights[hl_name] = nil
    end
end

-- Utility functions
local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

local function manage_cache_size(cache, limit)
    local count = 0
    for _ in pairs(cache) do
        count = count + 1
    end

    if count > limit then
        -- Clear oldest entries (simple approach - clear half the cache)
        local to_remove = {}
        local removed_count = 0
        local target_remove = math.floor(count / 2)

        for key in pairs(cache) do
            table.insert(to_remove, key)
            removed_count = removed_count + 1
            if removed_count >= target_remove then
                break
            end
        end

        for _, key in ipairs(to_remove) do
            cache[key] = nil
        end
    end
end

-- Function to check if current buffer should be ignored
local function should_ignore_buffer()
    local filetype = vim.bo.filetype
    local buftype = vim.bo.buftype

    return contains(M.config.ignore_filetypes, filetype) or contains(M.config.ignore_buftypes, buftype)
end

-- Function to check if window is too small for winbar
local function is_window_too_small()
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)

    -- Skip very small windows (like popups, input dialogs, etc.)
    return win_width < M.config.min_window_width or win_height < 3
end

-- Function to check if we're in a popup or floating window
local function is_popup_or_floating_window()
    local win_config = vim.api.nvim_win_get_config(0)
    return win_config.relative ~= ""
end

-- Function to get file icon and color using nvim-web-devicons with caching
local function get_file_icon()
    local bufnr = vim.api.nvim_get_current_buf()

    if icon_cache[bufnr] then
        return unpack(icon_cache[bufnr])
    end

    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        icon_cache[bufnr] = { "", "" }
        return "", ""
    end

    local filename = vim.fn.expand "%:t"
    local extension = vim.fn.expand "%:e"

    -- Try multiple methods to get icon and color
    local icon, color

    -- Method 1: Try with filename
    if filename ~= "" then
        icon, color = devicons.get_icon_color(filename, extension)
    end

    -- Method 2: If that fails, try with extension only
    if (not icon or not color) and extension ~= "" then
        icon, color = devicons.get_icon_color("file." .. extension, extension)
    end

    -- Method 3: Try the get_icon method as fallback
    if not icon and filename ~= "" then
        icon = devicons.get_icon(filename, extension)
    end

    -- Method 4: Try to get color from extension if we have icon but no color
    if icon and not color and extension ~= "" then
        local _, ext_color = devicons.get_icon_color("." .. extension, extension)
        color = ext_color
    end

    -- Ensure we have valid strings
    icon = icon or ""
    color = color or ""

    -- Final fallback: if we still don't have a color but have an icon,
    -- use the normal text color
    if icon ~= "" and color == "" then
        local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
        color = normal_hl.fg and string.format("#%06x", normal_hl.fg) or "#FFFFFF"
    end

    local result = { icon, color }
    icon_cache[bufnr] = result

    -- Manage cache size
    manage_cache_size(icon_cache, M.config.cache_size_limit)

    return unpack(result)
end

-- Function to get diagnostic counts with colors (optimized)
local function get_diagnostics()
    if not M.config.show_diagnostics then
        return "", ""
    end

    -- Get all diagnostics once
    local all_diagnostics = vim.diagnostic.get(0)
    local counts = { errors = 0, warnings = 0, info = 0, hints = 0 }

    -- Count each severity level
    for _, diagnostic in ipairs(all_diagnostics) do
        local severity = diagnostic.severity
        if severity == vim.diagnostic.severity.ERROR then
            counts.errors = counts.errors + 1
        elseif severity == vim.diagnostic.severity.WARN then
            counts.warnings = counts.warnings + 1
        elseif severity == vim.diagnostic.severity.INFO then
            counts.info = counts.info + 1
        elseif severity == vim.diagnostic.severity.HINT then
            counts.hints = counts.hints + 1
        end
    end

    local result, plain_result = "", ""
    local diagnostic_configs = {
        { count = counts.errors, icon = icons.ERROR, hl = "WinBarDiagError" },
        { count = counts.warnings, icon = icons.WARN, hl = "WinBarDiagWarn" },
        { count = counts.info, icon = icons.INFO, hl = "WinBarDiagInfo" },
        { count = counts.hints, icon = icons.HINT, hl = "WinBarDiagHint" },
    }

    for _, config in ipairs(diagnostic_configs) do
        if config.count > 0 then
            result = result .. ("%%#%s# %s %d %%*"):format(config.hl, config.icon, config.count)
            plain_result = plain_result .. (" %s %d "):format(config.icon, config.count)
        end
    end

    return result, plain_result
end

-- Function to get modified status
local function get_modified_status()
    if not M.config.show_modified or not vim.bo.modified then
        return "", ""
    end

    local colored = ("%%#WinBarModified#%s%%*"):format(M.config.modified_icon)
    return colored, M.config.modified_icon
end

-- Function to get relative file path
local function get_file_path()
    local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    return (filepath == "." or filepath == "") and "" or filepath
end

-- Function to truncate text with ellipsis
local function truncate_text(text, max_width)
    if vim.fn.strdisplaywidth(text) <= max_width then
        return text
    end

    local ellipsis = require("icons").misc.ellipsis
    local ellipsis_width = vim.fn.strdisplaywidth(ellipsis)
    local target_width = max_width - ellipsis_width

    if target_width <= 0 then
        return ellipsis
    end

    local char_count = vim.fn.strchars(text)
    for i = char_count, 1, -1 do
        local truncated = ellipsis .. vim.fn.strpart(text, char_count - i, i)
        if vim.fn.strdisplaywidth(truncated) <= max_width then
            return truncated
        end
    end
    return ellipsis
end

-- Debounced update function
local function debounced_update(is_active)
    if update_timer then
        update_timer:stop()
    end
    update_timer = vim.uv.new_timer()
    update_timer:start(
        CONSTANTS.DEBOUNCE_MS,
        0,
        vim.schedule_wrap(function()
            M.update_winbar(is_active)
        end)
    )
end

-- Create window-specific icon highlight with better handling
local function create_icon_highlight(win_id, icon_color, force_refresh)
    -- Don't create highlight if no color or if color is invalid
    if not icon_color or icon_color == "" or not icon_color:match "^#[0-9a-fA-F]+$" then
        return ""
    end

    local icon_hl_name = "WinBarFileIcon" .. win_id

    -- Force refresh highlights if needed (e.g., after popup closes)
    if force_refresh or not highlight_cache[icon_hl_name] or highlight_cache[icon_hl_name] ~= icon_color then
        -- Store original if not already stored
        if not original_highlights[icon_hl_name] then
            original_highlights[icon_hl_name] = icon_color
        end

        -- Safely set highlight with error handling
        local ok = pcall(vim.api.nvim_set_hl, 0, icon_hl_name, { fg = icon_color })
        if ok then
            highlight_cache[icon_hl_name] = icon_color
        else
            -- If setting highlight fails, clear the cache and return empty
            highlight_cache[icon_hl_name] = nil
            original_highlights[icon_hl_name] = nil
            return ""
        end
    end

    return icon_hl_name
end

-- Restore highlight groups (called when popups close)
local function restore_highlights()
    for hl_name, color in pairs(original_highlights) do
        if highlight_cache[hl_name] then
            vim.api.nvim_set_hl(0, hl_name, { fg = color })
        end
    end
end

-- Calculate available space for components
local function calculate_available_space(win_width, filename, icon)
    local base_content = icon .. " " .. filename
    local base_width = vim.fn.strdisplaywidth(base_content)
    local padding = M.config.min_padding * 2
    local available_space = win_width - base_width - padding * 2

    return math.max(available_space, 0)
end

-- Build winbar components with better space management
local function build_components(
    is_active,
    win_width,
    filename,
    file_path,
    icon,
    icon_color,
    diagnostics,
    plain_diagnostics,
    modified,
    plain_modified,
    force_refresh
)
    local win_id = vim.api.nvim_get_current_win()
    local icon_hl_name = create_icon_highlight(win_id, icon_color, force_refresh)
    local colored_icon = (icon_hl_name ~= "") and ("%#" .. icon_hl_name .. "#" .. icon .. "%*") or icon

    -- Calculate available space
    local available_space = calculate_available_space(win_width, filename, icon)

    -- Handle path component with better space management
    local path_component, path_for_width = "", ""
    if (is_active or M.config.show_path_when_inactive) and file_path ~= "" and available_space > 10 then
        -- Reserve space for diagnostics and modified indicator
        local reserved_space = 0
        if plain_diagnostics ~= "" then
            reserved_space = reserved_space + vim.fn.strdisplaywidth(plain_diagnostics)
        end
        if plain_modified ~= "" then
            reserved_space = reserved_space + vim.fn.strdisplaywidth(plain_modified)
        end

        local path_space = available_space - reserved_space - (M.config.min_padding * 2)
        if path_space > 5 then -- Minimum space for meaningful path
            local truncated_path = truncate_text(file_path, path_space)
            if vim.fn.strdisplaywidth(truncated_path) > 0 then
                path_component = ("%%#WinBarPath#%s%%*"):format(truncated_path)
                path_for_width = truncated_path
            end
        end
    end

    -- Only show diagnostics if there's space
    local diag_component, diag_plain = "", ""
    if diagnostics ~= "" and available_space > 15 then
        diag_component = diagnostics
        diag_plain = plain_diagnostics
    end

    -- Only show modified if there's space
    local mod_component, mod_plain = "", ""
    if modified ~= "" and available_space > 5 then
        mod_component = modified
        mod_plain = plain_modified
    end

    return {
        { content = colored_icon .. " " .. filename, plain = icon .. " " .. filename },
        { content = mod_component, plain = mod_plain },
        { content = path_component, plain = path_for_width },
        { content = diag_component, plain = diag_plain },
    }
end

-- Update the winbar
function M.update_winbar(is_active, force_refresh)
    local filename = vim.fn.expand "%:t"

    -- Early exit for ignored buffers, small windows, or popups
    if filename == "" or should_ignore_buffer() or is_window_too_small() or is_popup_or_floating_window() then
        vim.wo.winbar = ""
        return
    end

    -- Get all required data
    local file_path = get_file_path()
    local icon, icon_color = get_file_icon()
    local diagnostics, plain_diagnostics = get_diagnostics()
    local modified, plain_modified = get_modified_status()
    local win_width = vim.api.nvim_win_get_width(0)

    -- Build components
    local components = build_components(
        is_active,
        win_width,
        filename,
        file_path,
        icon,
        icon_color,
        diagnostics,
        plain_diagnostics,
        modified,
        plain_modified,
        force_refresh
    )

    -- Build final content
    local content_parts, plain_parts = {}, {}
    for _, comp in ipairs(components) do
        if comp.content and comp.content ~= "" then
            if #content_parts > 0 then
                local spacing = string.rep(" ", M.config.min_padding)
                table.insert(content_parts, spacing)
                table.insert(plain_parts, spacing)
            end
            table.insert(content_parts, comp.content)
            table.insert(plain_parts, comp.plain or "")
        end
    end

    local final_content = table.concat(content_parts)
    local plain_content = table.concat(plain_parts)

    -- Calculate padding and set winbar with safety checks
    local content_width = vim.fn.strdisplaywidth(plain_content)

    -- If content is still too wide, show minimal version
    if content_width >= win_width - 4 then
        -- Try to show just the filename with icon
        local minimal_content = icon .. " " .. filename
        local minimal_width = vim.fn.strdisplaywidth(minimal_content)

        if minimal_width < win_width - 4 then
            local icon_hl_name = create_icon_highlight(vim.api.nvim_get_current_win(), icon_color, force_refresh)
            local colored_minimal = (icon_hl_name ~= "") and ("%#" .. icon_hl_name .. "#" .. icon .. "%*") or icon
            colored_minimal = colored_minimal .. " " .. filename

            local padding = math.max(math.floor((win_width - minimal_width) / 2), 0)
            vim.wo.winbar = string.rep(" ", padding) .. colored_minimal
        else
            -- Even minimal doesn't fit, hide winbar
            vim.wo.winbar = ""
        end
        return
    end

    -- Normal case: content fits with padding
    local padding = math.max(math.floor((win_width - content_width) / 2), 0)
    vim.wo.winbar = string.rep(" ", padding) .. final_content
end

-- Clear caches with better cleanup
local function clear_icon_cache(bufnr)
    if bufnr and icon_cache[bufnr] then
        icon_cache[bufnr] = nil
    end

    -- Also clear any related highlights for this buffer
    if bufnr then
        for win_id, _ in pairs(vim.api.nvim_list_wins()) do
            cleanup_window_highlights(win_id)
        end
    end
end

-- Set up highlight groups
local function set_highlights()
    local sethl = vim.api.nvim_set_hl
    local gethl = vim.api.nvim_get_hl

    -- Get diagnostic colors with fallbacks
    local colors = {
        error = gethl(0, { name = "DiagnosticError" }).fg or "#FF6B6B",
        warn = gethl(0, { name = "DiagnosticWarn" }).fg or "#FFD93D",
        info = gethl(0, { name = "DiagnosticInfo" }).fg or "#6BCF7F",
        hint = gethl(0, { name = "DiagnosticHint" }).fg or "#A8A8A8",
        pmenu = gethl(0, { name = "Pmenu" }).fg or "#FFFFFF",
    }

    -- Set highlight groups
    sethl(0, "WinBarDiagError", { fg = colors.error, bold = true })
    sethl(0, "WinBarDiagWarn", { fg = colors.warn, bold = true })
    sethl(0, "WinBarDiagInfo", { fg = colors.info, bold = true })
    sethl(0, "WinBarDiagHint", { fg = colors.hint })
    sethl(0, "WinBarPath", { fg = "#888888", italic = true })
    sethl(0, "WinBarModified", { fg = colors.error, bold = true })

    -- Restore any cached highlights
    restore_highlights()
end

-- Setup function
--- @param user_config? Config
function M.setup(user_config)
    -- Merge user config with defaults
    if user_config then
        M.config = vim.tbl_deep_extend("force", M.config, user_config)
    end

    local autocmd = vim.api.nvim_create_autocmd
    local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })

    -- Cache management with better cleanup
    autocmd({ "BufDelete", "BufFilePost", "BufWritePost" }, {
        group = group,
        callback = function(args)
            clear_icon_cache(args.buf)
        end,
    })

    -- Also clear cache when file is renamed or moved
    autocmd("BufFilePost", {
        group = group,
        callback = function(_)
            -- Clear all caches since filename/extension might have changed
            icon_cache = {}
        end,
    })

    -- Colorscheme updates
    autocmd("ColorScheme", {
        group = group,
        callback = function()
            highlight_cache = {} -- Clear highlight cache on colorscheme change
            original_highlights = {} -- Clear original highlights
            set_highlights()
        end,
    })

    -- Window cleanup
    autocmd("WinClosed", {
        group = group,
        callback = function(args)
            local win_id = tonumber(args.match)
            if win_id then
                cleanup_window_highlights(win_id)
            end
        end,
    })

    -- Handle popup/telescope closing - restore highlights
    autocmd("BufLeave", {
        group = group,
        pattern = "*",
        callback = function()
            local ft = vim.bo.filetype
            -- Check if we're leaving a telescope or popup buffer
            if ft == "TelescopePrompt" or ft == "TelescopeResults" or ft == "telescope" then
                vim.schedule(function()
                    -- Restore highlights after popup closes
                    restore_highlights()
                    -- Force refresh all visible winbars
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_is_valid(win) then
                            local bufnr = vim.api.nvim_win_get_buf(win)
                            if vim.api.nvim_buf_is_valid(bufnr) then
                                vim.api.nvim_win_call(win, function()
                                    if
                                        not should_ignore_buffer()
                                        and not is_window_too_small()
                                        and not is_popup_or_floating_window()
                                    then
                                        M.update_winbar(vim.api.nvim_get_current_win() == win, true)
                                    end
                                end)
                            end
                        end
                    end
                end)
            end
        end,
    })

    -- Debounced updates for frequent events
    autocmd({ "TextChanged", "InsertEnter", "InsertLeave" }, {
        group = group,
        callback = function()
            if not should_ignore_buffer() and not is_window_too_small() and not is_popup_or_floating_window() then
                debounced_update(true)
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
        "DiagnosticChanged",
        "VimResized",
        "WinEnter",
        "WinResized",
    }, {
        group = group,
        callback = function()
            if not should_ignore_buffer() and not is_window_too_small() and not is_popup_or_floating_window() then
                M.update_winbar(true)
            else
                vim.wo.winbar = ""
            end
        end,
    })

    -- Update when inactive
    autocmd("WinLeave", {
        group = group,
        callback = function()
            if not should_ignore_buffer() and not is_window_too_small() and not is_popup_or_floating_window() then
                M.update_winbar(false)
            else
                vim.wo.winbar = ""
            end
        end,
    })

    -- Initialize highlights
    set_highlights()
end

-- Clear all caches
function M.clear_caches()
    icon_cache = {}
    highlight_cache = {}
    original_highlights = {}
    if update_timer then
        update_timer:stop()
        update_timer = nil
    end
end

--- @module 'custom-winbar'
--- @type CustomWinBar
return M
