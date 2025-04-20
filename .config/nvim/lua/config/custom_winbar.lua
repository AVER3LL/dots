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

    local result = ""
    local plain_result = "" -- for width calculation

    if errors > 0 then
        result = result .. "%#WinBarDiagError# 󰅙 " .. errors .. "%* "
        plain_result = plain_result .. " 󰅙 " .. errors .. " "
    end
    if warnings > 0 then
        result = result .. "%#WinBarDiagWarn#  " .. warnings .. "%* "
        plain_result = plain_result .. "  " .. warnings .. " "
    end
    if info > 0 then
        result = result .. "%#WinBarDiagInfo# 󰋼 " .. info .. "%* "
        plain_result = plain_result .. " 󰋼 " .. info .. " "
    end
    if hints > 0 then
        result = result .. "%#WinBarDiagHint# 󰌵 " .. hints .. "%* "
        plain_result = plain_result .. " 󰌵 " .. hints .. " "
    end

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
    local filepath = vim.fn.expand "%:~:."
    local filename = vim.fn.expand "%:t"

    if filepath == filename then
        return ""
    else
        local path = string.sub(filepath, 1, #filepath - #filename - 1)
        return path
    end
end

-- Function to calculate string display width correctly
local function display_width(str)
    -- Use strdisplaywidth to get actual display width
    return vim.fn.strdisplaywidth(str)
end

-- Update the winbar
function M.update_winbar()
    local filename = vim.fn.expand "%:t"
    if filename == "" then
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

    -- Truncate path if necessary
    local path_component = ""
    if file_path ~= "" then
        local path_width = display_width(file_path)
        if path_width > available_path_space and available_path_space > 3 then
            -- If path is too long, truncate it with ellipsis
            local truncate_to = available_path_space - 3 -- space for "..."
            local truncated_path = ""
            local current_width = 0

            -- Split path into components
            for part in string.gmatch(file_path, "[^/]+") do
                local part_width = display_width(part)
                if current_width + part_width + 1 <= truncate_to then
                    truncated_path = truncated_path .. (truncated_path == "" and "" or "/") .. part
                    current_width = current_width + part_width + 1
                else
                    break
                end
            end

            path_component = "%#WinBarPath#" .. truncated_path .. "...%* "
        elseif available_path_space >= path_width then
            path_component = "%#WinBarPath#" .. file_path .. " %*"
        end
    end

    -- Construct the content
    local content = colored_icon .. filename_part .. path_component .. modified .. diagnostics

    -- Calculate final padding
    local visual_content = icon
        .. filename_part
        .. (path_component ~= "" and file_path .. " " or "")
        .. plain_modified
        .. plain_diagnostics
    local content_width = display_width(visual_content)

    local final_padding = math.floor((win_width - content_width) / 2)
    if final_padding < 0 then
        final_padding = 0
    end

    local winbar = string.rep(" ", final_padding) .. content

    -- Set the winbar
    vim.wo.winbar = winbar
end

-- Set up autocmds to update the winbar
function M.setup()
    local autocmd = vim.api.nvim_create_autocmd
    local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })

    autocmd({ "FileType" }, {
        callback = function()
            local filename = vim.fn.expand "%:t"
            local extension = vim.fn.expand "%:e"
            local _, color = require("nvim-web-devicons").get_icon_color(filename, extension)

            if color then
                vim.api.nvim_set_hl(0, "WinBarFileIcon", { fg = color })
            end
        end,
    })

    -- update the winbar
    autocmd({
        "BufWinEnter",
        "BufFilePost",
        "BufWritePost",
        "InsertEnter",
        "InsertLeave",
        "BufEnter",
        "CursorHold",
        "DiagnosticChanged",
        "VimResized",
        "WinResized",
        "WinLeave",
        "WinScrolled",
        "WinEnter", -- Added to handle switching between splits
    }, {
        group = group,
        callback = function()
            -- Only show winbar in normal buffers
            if vim.bo.buftype == "" then
                M.update_winbar()
            else
                vim.wo.winbar = ""
            end
        end,
    })
end

return M
