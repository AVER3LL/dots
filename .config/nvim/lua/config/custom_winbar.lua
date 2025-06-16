local icons = require("icons").diagnostics

-- Code generated purely by AI
-- Sure I modified some parts to have it actually work
-- but I am not smart enough for all this.

--- @class CustomWinBar
--- @field config Config
--- @field update_winbar fun(is_active: boolean)
--- @field setup fun(user_config: Config|nil)
--- @field clear_caches fun()

-- Custom minimal centered winbar
local M = {}

-- local bt = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }

--- @class Config
--- @field show_diagnostics boolean
--- @field show_modified boolean
--- @field show_path_when_inactive boolean
--- @field min_padding integer
--- @field modified_icon string
--- @field ignore_filetypes string[]
--- @field ignore_buftypes string[]

--- @type Config
M.config = {
    show_diagnostics = true,
    show_modified = true,
    show_path_when_inactive = false,

    modified_icon = "✱",

    min_padding = 2,
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
    },
    ignore_buftypes = {
        "nofile",
        "terminal",
        "help",
        "quickfix",
        "prompt",
    },
}

-- Cache for file icons
local icon_cache = {}
local update_timer = nil

-- Function to check if current buffer should be ignored
local function should_ignore_buffer()
    local filetype = vim.bo.filetype
    local buftype = vim.bo.buftype

    -- Check if filetype should be ignored
    for _, ft in ipairs(M.config.ignore_filetypes) do
        if filetype == ft then
            return true
        end
    end

    -- Check if buftype should be ignored
    for _, bt in ipairs(M.config.ignore_buftypes) do
        if buftype == bt then
            return true
        end
    end

    return false
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
    local icon, color = devicons.get_icon_color(filename, extension)

    local result = { icon and (icon .. " ") or "", color or "" }
    icon_cache[bufnr] = result
    return unpack(result)
end

-- Function to get diagnostic counts with colors
local function get_diagnostics()
    if not M.config.show_diagnostics then
        return "", ""
    end

    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

    local result, plain_result = "", ""
    local add_diagnostic = function(count, icon, hl)
        if count > 0 then
            result = result .. ("%%#%s# %s %d %%*"):format(hl, icon, count)
            plain_result = plain_result .. (" %s %d "):format(icon, count)
        end
    end

    add_diagnostic(errors, icons.ERROR, "WinBarDiagError")
    add_diagnostic(warnings, icons.WARN, "WinBarDiagWarn")
    add_diagnostic(info, icons.INFO, "WinBarDiagInfo")
    add_diagnostic(hints, icons.HINT, "WinBarDiagHint")

    return result, plain_result
end

-- Function to get save status
local function get_modified_status()
    if not M.config.show_modified or not vim.bo.modified then
        return "", ""
    end

    local hl_group = "WinBarModified"
    local colored = (" " .. "%%#%s#%s%%*" .. " "):format(hl_group, M.config.modified_icon)
    return colored, " " .. M.config.modified_icon .. " "
end

-- Function to get relative file path
local function get_file_path()
    local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")

    if filepath == "." or filepath == "" then
        return ""
    end

    return filepath
end

-- Function to truncate text with ellipsis (improved for better Unicode handling)
local function truncate(text, max_width)
    if vim.fn.strdisplaywidth(text) <= max_width then
        return text
    end
    local ellipsis = "…"
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

-- Function to calculate string display width correctly
local function display_width(str)
    return vim.fn.strdisplaywidth(str)
end

-- Function to calculate content width
local function calculate_content_width(icon, filename, path, modified, diagnostics)
    return display_width(icon .. filename .. "  " .. path .. modified .. diagnostics)
end

-- Debounced update function
local function debounced_update(is_active)
    if update_timer then
        update_timer:stop()
    end
    update_timer = vim.uv.new_timer()
    update_timer:start(
        50,
        0,
        vim.schedule_wrap(function()
            M.update_winbar(is_active)
        end)
    )
end

-- Update the winbar
function M.update_winbar(is_active)
    local filename = vim.fn.expand "%:t"

    -- Check if buffer should be ignored
    if filename == "" or should_ignore_buffer() then
        vim.wo.winbar = ""
        return
    end

    local file_path = get_file_path()
    local icon, icon_color = get_file_icon()
    local diagnostics, plain_diagnostics = get_diagnostics()
    local modified, plain_modified = get_modified_status()

    -- Create a unique highlight group name for this window
    local win_id = vim.api.nvim_get_current_win()
    local icon_hl_name = "WinBarFileIcon" .. win_id

    -- Set window-specific highlight for the icon
    if icon_color and icon_color ~= "" then
        vim.api.nvim_set_hl(0, icon_hl_name, { fg = icon_color })
    end

    -- Get window width
    local win_width = vim.api.nvim_win_get_width(0)

    -- Calculate base content width (without path)
    local colored_icon = icon_color and icon_color ~= "" and ("%#" .. icon_hl_name .. "#" .. icon .. "%*") or icon
    local filename_part = filename .. "  "
    local base_visual_content = icon .. filename_part .. plain_modified .. plain_diagnostics
    local base_width = display_width(base_visual_content)

    -- Calculate available space for path
    local padding = M.config.min_padding
    local available_path_space = win_width - base_width - (padding * 2)

    -- Determine path component
    local path_component = ""
    local path_for_width = ""
    if (is_active or M.config.show_path_when_inactive) and file_path ~= "" then
        local truncated_path = truncate(file_path, math.max(available_path_space, 0))
        if vim.fn.strdisplaywidth(truncated_path) > 0 then
            path_component = ("%%#WinBarPath#%s %%*"):format(truncated_path)
            path_for_width = truncated_path .. " "
        end
    end

    -- Construct the content
    local content = colored_icon .. filename_part .. path_component .. modified .. diagnostics

    -- Calculate padding and set winbar
    local content_width = calculate_content_width(icon, filename, path_for_width, plain_modified, plain_diagnostics)
    local final_padding = math.max(math.floor((win_width - content_width) / 2), 0)
    vim.wo.winbar = string.rep(" ", final_padding) .. content
end

-- Clear icon cache for a buffer
local function clear_icon_cache(bufnr)
    if bufnr and icon_cache[bufnr] then
        icon_cache[bufnr] = nil
    end
end

local function set_highlights()
    local sethl = vim.api.nvim_set_hl
    local gethl = vim.api.nvim_get_hl

    local error_fg = gethl(0, { name = "DiagnosticError" }).fg
    local warn_fg = gethl(0, { name = "DiagnosticWarn" }).fg
    local info_fg = gethl(0, { name = "DiagnosticInfo" }).fg
    local hint_fg = gethl(0, { name = "DiagnosticHint" }).fg

    sethl(0, "WinBarDiagError", { fg = error_fg, bold = true }) -- Soft red
    sethl(0, "WinBarDiagWarn", { fg = warn_fg, bold = true }) -- Muted amber
    sethl(0, "WinBarDiagInfo", { fg = info_fg, bold = true }) -- Soft blue
    sethl(0, "WinBarDiagHint", { fg = hint_fg }) -- Muted green

    -- grey out the path
    sethl(0, "WinBarPath", { fg = "#888888", italic = true })
    sethl(0, "WinBarModified", { fg = "#FF7139", bold = true })
end

-- Set up autocmds to update the winbar
--- @param user_config? Config
function M.setup(user_config)
    -- Merge user config with defaults
    if user_config then
        M.config = vim.tbl_extend("force", M.config, user_config)
    end

    local autocmd = vim.api.nvim_create_autocmd
    local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })

    -- Clear icon cache when buffer is deleted or file is renamed
    autocmd({ "BufDelete", "BufFilePost" }, {
        group = group,
        callback = function(args)
            clear_icon_cache(args.buf)
        end,
    })

    autocmd("ColorScheme", {
        group = group,
        callback = set_highlights,
    })

    set_highlights()

    -- Clean up window-specific highlight groups when windows are closed
    autocmd("WinClosed", {
        group = group,
        callback = function(args)
            local win_id = tonumber(args.match)
            if win_id then
                pcall(vim.api.nvim_set_hl, 0, "WinBarFileIcon" .. win_id, {})
            end
        end,
    })

    -- Update when active (with debouncing for frequent events)
    autocmd({ "TextChanged", "InsertEnter", "InsertLeave" }, {
        group = group,
        callback = function()
            if not should_ignore_buffer() then
                debounced_update(true)
            else
                vim.wo.winbar = ""
            end
        end,
    })

    -- Update immediately for other events
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
            if not should_ignore_buffer() then
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
            if not should_ignore_buffer() then
                M.update_winbar(false)
            else
                vim.wo.winbar = ""
            end
        end,
    })
end

-- Function to clear all caches (useful for debugging)
function M.clear_caches()
    icon_cache = {}
    if update_timer then
        update_timer:stop()
        update_timer = nil
    end
end

--- @module 'custom-winbar'
--- @type CustomWinBar
return M
