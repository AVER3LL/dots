local icons = require("icons").diagnostics
local api, fn, bo = vim.api, vim.fn, vim.bo

--- @class CustomWinBar
--- @field config Config
--- @field update_winbar fun(is_active: boolean)
--- @field setup fun(user_config: Config|nil)

-- Custom minimal centered winbar
local M = {}

-- Constants
local CONSTANTS = {
    DEBOUNCE_MS = 50,
    DEFAULT_PADDING = 2,
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
--- @field min_window_width integer

--- @type Config
M.config = {
    show_diagnostics = true,
    show_modified = true,
    show_path_when_inactive = false,
    modified_icon = require("icons").misc.dot,
    min_padding = CONSTANTS.DEFAULT_PADDING,
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
        "snacks_dashboard",
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

local update_timer = nil

-- Utility functions
local function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Function to check if current buffer should be ignored
local function should_ignore_buffer()
    local filetype = bo.filetype
    local buftype = bo.buftype
    return contains(M.config.ignore_filetypes, filetype) or contains(M.config.ignore_buftypes, buftype)
end

-- Function to check if window is too small for winbar
local function is_window_too_small()
    local win_width = api.nvim_win_get_width(0)
    local win_height = api.nvim_win_get_height(0)
    return win_width < M.config.min_window_width or win_height < 3
end

-- Function to check if we're in a popup or floating window
local function is_popup_or_floating_window()
    local win_config = api.nvim_win_get_config(0)
    return win_config.relative ~= ""
end

-- Function to get file icon and color using nvim-web-devicons
local function get_file_icon()
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
        return "", ""
    end

    local filename = fn.expand "%:t"
    local extension = fn.expand "%:e"
    local icon, color

    -- Try multiple methods to get icon and color
    if filename ~= "" then
        icon, color = devicons.get_icon_color(filename, extension)
    end

    if (not icon or not color) and extension ~= "" then
        icon, color = devicons.get_icon_color("file." .. extension, extension)
    end

    if not icon and filename ~= "" then
        icon = devicons.get_icon(filename, extension)
    end

    if icon and not color and extension ~= "" then
        local _, ext_color = devicons.get_icon_color("." .. extension, extension)
        color = ext_color
    end

    icon = icon or ""
    color = color or ""

    -- Final fallback: use normal text color if needed
    if icon ~= "" and color == "" then
        local normal_hl = api.nvim_get_hl(0, { name = "Normal" })
        color = normal_hl.fg and string.format("#%06x", normal_hl.fg) or "#FFFFFF"
    end

    return icon, color
end

-- Function to get diagnostic counts with colors
local function get_diagnostics()
    if not M.config.show_diagnostics then
        return "", ""
    end

    local all_diagnostics = vim.diagnostic.get(0)
    local counts = { errors = 0, warnings = 0, info = 0, hints = 0 }

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
    if not M.config.show_modified or not bo.modified then
        return "", ""
    end
    local colored = ("%%#WinBarModified#%s%%*"):format(M.config.modified_icon)
    return colored, M.config.modified_icon
end

-- Function to get relative file path
local function get_file_path()
    local filepath = fn.fnamemodify(fn.expand "%", ":~:.:h")
    return (filepath == "." or filepath == "") and "" or filepath
end

-- Function to truncate text with ellipsis
local function truncate_text(text, max_width)
    if fn.strdisplaywidth(text) <= max_width then
        return text
    end

    local ellipsis = require("icons").misc.ellipsis
    local ellipsis_width = fn.strdisplaywidth(ellipsis)
    local target_width = max_width - ellipsis_width

    if target_width <= 0 then
        return ellipsis
    end

    local char_count = fn.strchars(text)
    for i = char_count, 1, -1 do
        local truncated = ellipsis .. fn.strpart(text, char_count - i, i)
        if fn.strdisplaywidth(truncated) <= max_width then
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

-- Create window-specific icon highlight
local function create_icon_highlight(win_id, icon_color)
    if not icon_color or icon_color == "" or not icon_color:match "^#[0-9a-fA-F]+$" then
        return ""
    end

    local icon_hl_name = "WinBarFileIcon" .. win_id
    pcall(api.nvim_set_hl, 0, icon_hl_name, { fg = icon_color })
    return icon_hl_name
end

-- Calculate available space for components
local function calculate_available_space(win_width, filename, icon)
    local base_content = icon .. " " .. filename
    local base_width = fn.strdisplaywidth(base_content)
    local padding = M.config.min_padding * 2
    local available_space = win_width - base_width - padding * 2
    return math.max(available_space, 0)
end

-- Build winbar components
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
    plain_modified
)
    local win_id = api.nvim_get_current_win()
    local icon_hl_name = create_icon_highlight(win_id, icon_color)
    local colored_icon = (icon_hl_name ~= "") and ("%#" .. icon_hl_name .. "#" .. icon .. "%*") or icon

    -- Calculate available space
    local available_space = calculate_available_space(win_width, filename, icon)

    -- Handle path component
    local path_component, path_for_width = "", ""
    if (is_active or M.config.show_path_when_inactive) and file_path ~= "" and available_space > 10 then
        local reserved_space = 0
        if plain_diagnostics ~= "" then
            reserved_space = reserved_space + fn.strdisplaywidth(plain_diagnostics)
        end
        if plain_modified ~= "" then
            reserved_space = reserved_space + fn.strdisplaywidth(plain_modified)
        end

        local path_space = available_space - reserved_space - (M.config.min_padding * 2)
        if path_space > 5 then
            local truncated_path = truncate_text(file_path, path_space)
            if fn.strdisplaywidth(truncated_path) > 0 then
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
function M.update_winbar(is_active)
    local filename = fn.expand "%:t"

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
    local win_width = api.nvim_win_get_width(0)

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
        plain_modified
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

    -- Calculate padding and set winbar
    local content_width = fn.strdisplaywidth(plain_content)
    if content_width >= win_width - 4 then
        local minimal_content = icon .. " " .. filename
        local minimal_width = fn.strdisplaywidth(minimal_content)
        if minimal_width < win_width - 4 then
            local icon_hl_name = create_icon_highlight(api.nvim_get_current_win(), icon_color)
            local colored_minimal = (icon_hl_name ~= "") and ("%#" .. icon_hl_name .. "#" .. icon .. "%*") or icon
            colored_minimal = colored_minimal .. " " .. filename
            local padding = math.max(math.floor((win_width - minimal_width) / 2), 0)
            vim.wo.winbar = string.rep(" ", padding) .. colored_minimal
        else
            vim.wo.winbar = ""
        end
        return
    end

    local padding = math.max(math.floor((win_width - content_width) / 2), 0)
    vim.wo.winbar = string.rep(" ", padding) .. final_content
end

-- Set up highlight groups
local function set_highlights()
    local sethl = api.nvim_set_hl
    local gethl = api.nvim_get_hl

    -- Get diagnostic colors with fallbacks
    local colors = {
        error = gethl(0, { name = "DiagnosticError" }).fg or "#FF6B6B",
        warn = gethl(0, { name = "DiagnosticWarn" }).fg or "#FFD93D",
        info = gethl(0, { name = "DiagnosticInfo" }).fg or "#6BCF7F",
        hint = gethl(0, { name = "DiagnosticHint" }).fg or "#A8A8A8",

        path = "#888888",
    }

    -- Set highlight groups
    sethl(0, "WinBarDiagError", { fg = colors.error, bold = true })
    sethl(0, "WinBarDiagWarn", { fg = colors.warn, bold = true })
    sethl(0, "WinBarDiagInfo", { fg = colors.info, bold = true })
    sethl(0, "WinBarDiagHint", { fg = colors.hint })
    sethl(0, "WinBarPath", { fg = colors.path, italic = true })
    sethl(0, "WinBarModified", { fg = colors.error, bold = true })
end

-- Setup function
--- @param user_config? Config
function M.setup(user_config)
    -- Merge user config with defaults
    if user_config then
        M.config = vim.tbl_deep_extend("force", M.config, user_config)
    end

    local autocmd = api.nvim_create_autocmd
    local group = api.nvim_create_augroup("CustomWinBar", { clear = true })

    -- Window cleanup
    autocmd("WinClosed", {
        group = group,
        callback = function(args)
            local win_id = tonumber(args.match)
            if win_id then
                pcall(api.nvim_set_hl, 0, "WinBarFileIcon" .. win_id, {})
            end
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
            local ft = bo.filetype
            if ft == "TelescopePrompt" or ft == "TelescopeResults" or ft == "telescope" then
                vim.schedule(function()
                    for _, win in ipairs(api.nvim_list_wins()) do
                        if api.nvim_win_is_valid(win) then
                            local bufnr = api.nvim_win_get_buf(win)
                            if api.nvim_buf_is_valid(bufnr) then
                                api.nvim_win_call(win, function()
                                    if
                                        not should_ignore_buffer()
                                        and not is_window_too_small()
                                        and not is_popup_or_floating_window()
                                    then
                                        M.update_winbar(api.nvim_get_current_win() == win)
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

--- @module 'custom-winbar'
--- @type CustomWinBar
return M
