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
    local path_component = file_path ~= "" and file_path .. " " or ""
    local icon, icon_color = get_file_icon()
    local diagnostics, plain_diagnostics = get_diagnostics()
    local modified, plain_modified = get_modified_status()

    -- Apply highlight to icon
    vim.api.nvim_set_hl(0, "WinBarFileIcon", { fg = icon_color })

    -- Create the content without extra spaces
    local colored_icon = "%#WinBarFileIcon#" .. icon .. "%*"
    local italic_path = "%#WinBarPath#" .. path_component .. "%*"
    local filename_part = filename .. "  "

    -- Construct the actual content with proper highlighting
    local content = colored_icon .. filename_part .. italic_path .. modified .. diagnostics

    -- Calculate the actual visual width of the content (excluding highlight syntax)
    local visual_content = icon .. filename_part .. path_component .. plain_modified .. plain_diagnostics
    local content_width = display_width(visual_content)

    -- Center the content properly based on window width
    local win_width = vim.api.nvim_win_get_width(0)
    local padding = math.floor((win_width - content_width) / 2)
    if padding < 0 then
        padding = 0
    end

    local winbar = string.rep(" ", padding) .. content

    -- Set the winbar
    vim.wo.winbar = winbar
end

-- Set up autocmds to update the winbar
function M.setup()
    local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })

    vim.api.nvim_create_autocmd({ "FileType" }, {
        callback = function()
            local filename = vim.fn.expand "%:t"
            local extension = vim.fn.expand "%:e"
            local _, color = require("nvim-web-devicons").get_icon_color(filename, extension)

            if color then
                vim.api.nvim_set_hl(0, "WinBarFileIcon", { fg = color })
            end
        end,
    })

    vim.api.nvim_create_autocmd({
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
