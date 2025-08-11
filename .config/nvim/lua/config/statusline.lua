local M = {}

local api, fn, bo = vim.api, vim.fn, vim.bo
local icons = require "icons"

-- Define highlight groups and mode colors
local MODE_COLORS = {
    n = "%#StatuslineNormal#", -- Normal mode - green background
    i = "%#StatuslineInsert#", -- Insert mode - red background
    v = "%#StatuslineVisual#", -- Visual mode - yellow background
    V = "%#StatuslineVisual#", -- Visual line mode
    ["\22"] = "%#StatuslineVisual#", -- Visual block mode (Ctrl-V)
    c = "%#StatuslineCommand#", -- Command mode - blue background
    R = "%#StatuslineReplace#", -- Replace mode - orange background
    r = "%#StatuslineReplace#", -- Replace mode
    s = "%#StatuslineSelect#", -- Select mode - purple background
    S = "%#StatuslineSelect#", -- Select line mode
    ["\19"] = "%#StatuslineSelect#", -- Select block mode (Ctrl-S)
    t = "%#StatuslineTerminal#", -- Terminal mode - cyan background
    ["!"] = "%#StatuslineShell#", -- Shell mode - magenta background
}

local MODE_NAMES = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    R = "REPLACE",
    r = "PROMPT",
    ["!"] = "SHELL",
    t = "TERMINAL",
}

-- Setup highlight groups
local function setup_highlights()
    -- Mode highlight groups with background colors
    vim.api.nvim_set_hl(0, "StatuslineNormal", { fg = "#000000", bg = "#98c379", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineInsert", { fg = "#000000", bg = "#e06c75", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineVisual", { fg = "#000000", bg = "#e5c07b", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineCommand", { fg = "#000000", bg = "#61afef", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineReplace", { fg = "#000000", bg = "#d19a66", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineSelect", { fg = "#000000", bg = "#c678dd", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineTerminal", { fg = "#000000", bg = "#56b6c2", bold = true })
    vim.api.nvim_set_hl(0, "StatuslineShell", { fg = "#000000", bg = "#be5046", bold = true })

    -- Other highlights
    vim.api.nvim_set_hl(0, "StatuslineGit", { fg = "#98c379", bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatuslineFile", { fg = "#61afef", bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatuslineInfo", { fg = "#abb2bf", bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatuslineLSP", { fg = "#e5c07b", bg = "NONE" })
end

-- Icon provider detection
local get_icon = nil

local function init_icons()
    if get_icon then
        return
    end

    -- Try mini.icons first
    local ok_mini, mini_icons = pcall(require, "mini.icons")
    if ok_mini then
        get_icon = function(filetype, filename)
            return mini_icons.get("filetype", filetype)
        end
        return
    end

    -- Try nvim-web-devicons
    local ok_web, web_devicons = pcall(require, "nvim-web-devicons")
    if ok_web then
        get_icon = function(filetype, filename)
            return web_devicons.get_icon_by_filetype(filetype) or web_devicons.get_default_icon()
        end
        return
    end

    -- Fallback to simple text icons
    local fallback_icons = {
        lua = "",
        python = "",
        javascript = "",
        typescript = "",
        html = "",
        css = "",
        json = "",
        markdown = "",
        vim = "",
        go = "",
        rust = "",
        c = "",
        cpp = "",
        java = "",
        php = "",
        ruby = "",
        sh = "",
        zsh = "",
        bash = "",
        yaml = "",
        toml = "",
        xml = "",
        sql = "",
        default = "",
    }

    get_icon = function(filetype, filename)
        return fallback_icons[filetype] or fallback_icons.default, nil
    end
end

-- Git utilities
local branch_cache = setmetatable({}, { __mode = "k" })

local function get_path_root(path)
    if path == "" then
        return
    end

    local root = vim.b.path_root
    if root then
        return root
    end

    root = vim.fs.root(path, { ".git" })
    if root then
        vim.b.path_root = root
    end
    return root
end

local function git_cmd(root, ...)
    local job = vim.system({ "git", "-C", root, ... }, { text = true }):wait()
    if job.code ~= 0 then
        return nil
    end
    return vim.trim(job.stdout)
end

local function get_git_branch(root)
    if not root then
        return nil
    end
    if branch_cache[root] then
        return branch_cache[root]
    end

    local branch = git_cmd(root, "rev-parse", "--abbrev-ref", "HEAD")
    if branch == "HEAD" then
        local commit = git_cmd(root, "rev-parse", "--short", "HEAD")
        if commit then
            branch = "(" .. commit .. ")"
        end
    end

    branch_cache[root] = branch
    return branch
end

-- Get mode with background color
local function get_mode()
    local mode = api.nvim_get_mode().mode
    local mode_color = MODE_COLORS[mode] or "%#StatuslineNormal#"
    local mode_name = MODE_NAMES[mode] or "UNKNOWN"

    return mode_color .. " " .. mode_name .. " %*"
end

-- Get git branch
local function get_git_info()
    local fname = api.nvim_buf_get_name(0)
    local root = (bo.buftype == "" and get_path_root(fname)) or nil
    local branch = get_git_branch(root)

    if branch then
        return "%#StatuslineGit# " .. icons.misc.git .. " " .. branch .. "%*"
    end
    return ""
end

-- Get filetype with icon
local function get_filetype()
    local ft = bo.filetype
    if ft == "" then
        ft = "no ft"
    end

    local icon, _ = get_icon(ft, api.nvim_buf_get_name(0))
    if not icon then
        icon = ""
    end

    return "%#StatuslineFile#" .. icon .. " " .. ft .. "%*"
end

-- Get current line and percentage
local function get_line_info()
    local line = api.nvim_win_get_cursor(0)[1]
    local total = api.nvim_buf_line_count(0)
    local percentage = math.floor((line / total) * 100)

    return "%#StatuslineInfo#" .. line .. ":" .. total .. " " .. percentage .. "%%%*"
end

-- Get active LSP clients
local function get_lsp_info()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then
        return "%#StatuslineLSP#No LSP%*"
    end

    local client_names = {}
    for _, client in pairs(clients) do
        table.insert(client_names, client.name)
    end

    return "%#StatuslineLSP#LSP: " .. table.concat(client_names, ", ") .. "%*"
end

-- Main render function
function M.render()
    -- Initialize icons on first run
    init_icons()
    setup_highlights()

    local left_parts = {
        get_mode(),
        get_git_info(),
    }

    local right_parts = {
        get_filetype(),
        get_line_info(),
        get_lsp_info(),
    }

    -- Filter out empty parts
    local left_filtered = {}
    for _, part in ipairs(left_parts) do
        if part ~= "" then
            table.insert(left_filtered, part)
        end
    end

    local left = table.concat(left_filtered, "")
    local right = table.concat(right_parts, "  ")

    return left .. "%=" .. right
end

-- Set up the statusline
vim.o.statusline = "%!v:lua.require('config.statusline').render()"

return M
