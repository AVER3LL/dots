local icons = require("icons").diagnostics

-- Custom minimal centered winbar
local M = {}

-- Function to get file icon and color using nvim-web-devicons
local function get_file_icon()
    local filename = vim.fn.expand "%:t"
    local extension = vim.fn.expand "%:e"
    local icon, color = require("nvim-web-devicons").get_icon_color(filename, extension)

    if icon then
        return icon .. " ", color
    end

    return "", ""
end

-- Function to get diagnostic counts with colors
local function get_diagnostics()
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
    if vim.bo.modified then
        return " [+]", " [+]"
    end
    return "", ""
end

-- Function to get relative file path
local function get_file_path()
    local filepath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")

    if filepath == "." or filepath == "" then
        return ""
    end

    return filepath
end

-- Function to truncate text with ellipsis
local function truncate(text, max_width)
    if vim.fn.strdisplaywidth(text) <= max_width then
        return text
    end
    local ellipsis = "…"
    max_width = max_width - vim.fn.strdisplaywidth(ellipsis)
    for i = #text, 1, -1 do
        local truncated = ellipsis .. text:sub(-i)
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

-- Update the winbar
function M.update_winbar(is_active)
    -- local is_active = is_active ~= nil and is_active or true
    local filename = vim.fn.expand "%:t"

    if filename == "" or vim.bo.buftype ~= "" then
        vim.wo.winbar = ""
        return
    end

    local file_path = get_file_path()
    local icon, icon_color = get_file_icon()
    local diagnostics, plain_diagnostics = get_diagnostics()
    local modified, plain_modified = get_modified_status()

    -- Apply highlight to icon
    vim.api.nvim_set_hl(0, "WinBarFileIcon", { fg = icon_color })

    -- Get window width
    local win_width = vim.api.nvim_win_get_width(0)

    -- Calculate base content width (without path)
    local colored_icon = "%#WinBarFileIcon#" .. icon .. "%*"
    local filename_part = filename .. "  "
    local base_visual_content = icon .. filename_part .. plain_modified .. plain_diagnostics
    local base_width = display_width(base_visual_content)

    -- Calculate available space for path
    local padding = 2 -- minimum padding on each side
    local available_path_space = win_width - base_width - (padding * 2)

    -- Determine path component
    local path_component = ""
    if is_active and file_path ~= "" then
        local truncated_path = truncate(file_path, math.max(available_path_space, 0))
        if vim.fn.strdisplaywidth(truncated_path) > 0 then
            path_component = ("%%#WinBarPath#%s %%*"):format(truncated_path)
        end
    end

    -- Construct the content
    local content = colored_icon .. filename_part .. path_component .. modified .. diagnostics

    -- Calculate padding and set winbar
    local content_width = vim.fn.strdisplaywidth(
        icon
            .. filename
            .. "  "
            .. (path_component ~= "" and file_path .. " " or "")
            .. plain_modified
            .. plain_diagnostics
    )
    local final_padding = math.max(math.floor((win_width - content_width) / 2), 0)
    vim.wo.winbar = string.rep(" ", final_padding) .. content
end

-- Set up autocmds to update the winbar
function M.setup()
    local autocmd = vim.api.nvim_create_autocmd
    local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })

    -- autocmd({ "FileType" }, {
    --     callback = function()
    --         local filename = vim.fn.expand "%:t"
    --         local extension = vim.fn.expand "%:e"
    --         local _, color = require("nvim-web-devicons").get_icon_color(filename, extension)
    --
    --         if color then
    --             vim.api.nvim_set_hl(0, "WinBarFileIcon", { fg = color })
    --         end
    --     end,
    -- })

    -- Update when active
    autocmd({
        "BufEnter",
        "BufFilePost",
        "BufWinEnter",
        "BufWritePost",
        "DiagnosticChanged",
        "InsertEnter",
        "InsertLeave",
        "TextChanged",
        "VimResized",
        "WinEnter",
        "WinResized",
    }, {
        group = group,
        callback = function()
            if vim.bo.buftype == "" then
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
            if vim.bo.buftype == "" then
                M.update_winbar(false)
            else
                vim.wo.winbar = ""
            end
        end,
    })
end

return M
