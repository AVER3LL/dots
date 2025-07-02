local M = {}

local api, fn, bo = vim.api, vim.fn, vim.bo
local get_opt = api.nvim_get_option_value
local icons = require "icons"

local HL = {
    branch = { "DiagnosticOk", icons.misc.git },
    file = { "NonText", icons.misc.node },
    fileinfo = { "DiagnosticInfo", icons.misc.document },
    nomodifiable = { "DiagnosticWarn", icons.misc.bullet },
    modified = { "DiagnosticError", icons.misc.bullet },
    readonly = { "DiagnosticWarn", icons.misc.lock },
    visual = { "DiagnosticInfo", "‹› " },
    error = { "DiagnosticError", icons.diagnostics.error or "●" },
    warn = { "DiagnosticWarn", icons.diagnostics.warn or "●" },

    mode_normal = { "DiagnosticOk", icons.modes.normal },
    mode_insert = { "DiagnosticError", icons.modes.insert },
    mode_visual = { "DiagnosticWarn", icons.modes.visual },
    mode_command = { "DiagnosticInfo", icons.modes.command },
    mode_other = { "Comment", icons.modes.other },
}

local function hl_str(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end

local ICON = {}
for k, v in pairs(HL) do
    ICON[k] = hl_str(v[1], v[2])
end

local ORDER = {
    "pad",
    "repo",
    "venv",
    "mod",
    "ro",
    "sep",
    "mode",
    "sep",
    -- "diag",
    "fileinfo",
    "pad",
    "scrollbar",
    "pad",
}

local PAD = " "
local SEP = "%="
-- local SBAR = { "▔", "🮂", "🬂", "🮃", "▀", "▄", "▃", "🬭", "▂", "▁" }
-- local SBAR = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
local SBAR = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁" }

-- utilities -----------------------------------------

local branch_cache = setmetatable({}, { __mode = "k" })
local remote_cache = setmetatable({}, { __mode = "k" })

local function concat(parts)
    local out, i = {}, 1
    for _, k in ipairs(ORDER) do
        local v = parts[k]
        if v and v ~= "" then
            out[i] = v
            i = i + 1
        end
    end
    return table.concat(out, " ")
end

local function esc_str(str)
    return str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
end

local function get_path_root(path)
    if path == "" then
        return
    end

    local root = vim.b.path_root
    if root then
        return root
    end

    local root_items = {
        ".git",
    }

    root = vim.fs.root(path, root_items)
    if root == nil then
        return nil
    end
    if root then
        vim.b.path_root = root
    end
    return root
end

local function git_cmd(root, ...)
    local job = vim.system({ "git", "-C", root, ... }, { text = true }):wait()

    if job.code ~= 0 then
        return nil, job.stderr
    end
    return vim.trim(job.stdout)
end

local function get_git_remote_name(root, show_full)
    if not root then
        return nil
    end
    if remote_cache[root] then
        return remote_cache[root]
    end

    local out = git_cmd(root, "config", "--get", "remote.origin.url")
    if not out then
        return nil
    end

    -- Normalize to owner/repo
    out = out:gsub(":", "/"):gsub("%.git$", ""):match "([^/]+/[^/]+)$"

    -- If show_full is not true, return only repo part
    if not show_full and out then
        out = out:match "([^/]+)$"
    end

    remote_cache[root] = out
    return out
end

local function get_git_branch(root)
    if not root then
        return nil
    end
    if branch_cache[root] then
        return branch_cache[root]
    end

    local out = git_cmd(root, "rev-parse", "--abbrev-ref", "HEAD")
    if out == "HEAD" then
        local commit = git_cmd(root, "rev-parse", "--short", "HEAD")
        if commit then
            commit = hl_str("Comment", "(" .. commit .. ")")
            out = string.format("%s %s", out, commit)
        end
    end

    branch_cache[root] = out

    return out
end

local function diagnostics_available()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg:supports_method(diagnostics) then
            return true
        end
    end

    return false
end

local group_number = function(num, sep)
    if num < 999 then
        return tostring(num)
    end

    num = tostring(num)
    return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^" .. esc_str(sep), "")
end

local nonprog_modes = {
    ["markdown"] = true,
    ["org"] = true,
    ["orgagenda"] = true,
    ["text"] = true,
}

-- path and git info -----------------------------------------
local function get_repo(root)
    local remote = get_git_remote_name(root, false)
    local branch = get_git_branch(root)

    if remote and branch then
        return string.format("%s %s @ %s", ICON.branch, remote, branch)
    end

    return ""
end

-- diagnostics ---------------------------------------------
local function diagnostics_widget()
    if not diagnostics_available() then
        return ""
    end
    local diag_count = vim.diagnostic.count(0)
    local err, warn = diag_count[vim.diagnostic.severity.ERROR] or 0, diag_count[vim.diagnostic.severity.WARN] or 0

    return string.format("%s %-3d  %s %-3d  ", ICON.error, err, ICON.warn, warn)
end

local function fileinfo_widget()
    local ft = get_opt("filetype", {})
    local lines = group_number(api.nvim_buf_line_count(0), ",")
    local str = ICON.fileinfo .. " "

    if not nonprog_modes[ft] then
        return str .. string.format("%3s lines", lines)
    end

    local ok, wc = pcall(fn.wordcount)
    if not ok then
        return str .. string.format("%3s lines", lines)
    end

    local mode = api.nvim_get_mode().mode
    if mode:match "^[vV\22]" and wc.visual_words then
        local vlines = math.abs(fn.line "." - fn.line "v") + 1
        return str
            .. string.format(
                "%3s lines %3s words %3s chars",
                group_number(vlines, ","),
                group_number(wc.visual_words, ","),
                group_number(wc.visual_chars, ",")
            )
    end

    return wc.words and str .. string.format("%3s lines %3s words", lines, group_number(wc.words, ","))
        or str .. string.format("%3s lines", lines)
end

local function venv_widget()
    if bo.filetype ~= "python" then
        return ""
    end
    local env = vim.env.VIRTUAL_ENV

    local str
    if env and env ~= "" then
        str = string.format("[.venv: %s]  ", fn.fnamemodify(env, ":t"))
        return hl_str("Comment", str)
    end

    env = vim.env.CONDA_DEFAULT_ENV
    if env and env ~= "" then
        str = string.format("[conda: %s]  ", env)
        return hl_str("Comment", str)
    end
    return hl_str("Comment", "[no venv]")
end

local function scrollbar_widget()
    local cur = api.nvim_win_get_cursor(0)[1]
    local total = api.nvim_buf_line_count(0)
    if total == 0 then
        return ""
    end
    local idx = math.floor((cur - 1) / total * #SBAR) + 1
    idx = math.min(idx, #SBAR) -- Ensure idx doesn't exceed SBAR length
    return hl_str("Substitute", SBAR[idx]:rep(2))
end

local function mode_widget()
    local mode = api.nvim_get_mode().mode
    local mode_map = {
        n = { "NORMAL", ICON.mode_normal },
        i = { "INSERT", ICON.mode_insert },
        v = { "VISUAL", ICON.mode_visual },
        V = { "V-LINE", ICON.mode_visual },
        ["\22"] = { "V-BLOCK", ICON.mode_visual }, -- Ctrl-V
        c = { "COMMAND", ICON.mode_command },
        s = { "SELECT", ICON.mode_other },
        S = { "S-LINE", ICON.mode_other },
        ["\19"] = { "S-BLOCK", ICON.mode_other }, -- Ctrl-S
        R = { "REPLACE", ICON.mode_insert },
        r = { "PROMPT", ICON.mode_other },
        ["!"] = { "SHELL", ICON.mode_other },
        t = { "TERMINAL", ICON.mode_other },
    }

    local mode_info = mode_map[mode] or { "UNKNOWN", ICON.mode_other }
    return mode_info[2] .. " " .. mode_info[1]
end

function M.render()
    local fname = api.nvim_buf_get_name(0)
    local root = (bo.buftype == "" and get_path_root(fname)) or nil
    if bo.buftype ~= "" and bo.buftype ~= "help" then
        fname = bo.ft
    end

    local buf = api.nvim_win_get_buf(vim.g.statusline_winid or 0)

    local parts = {
        pad = PAD,
        repo = get_repo(root),
        venv = venv_widget(),
        mod = get_opt("modifiable", { buf = buf }) and (get_opt("modified", { buf = buf }) and ICON.modified or " ")
            or ICON.nomodifiable,
        ro = get_opt("readonly", { buf = buf }) and ICON.readonly or "",
        sep = SEP,
        mode = mode_widget(),
        diag = diagnostics_widget(),
        fileinfo = fileinfo_widget(),
        scrollbar = scrollbar_widget(),
    }

    return concat(parts)
end

vim.o.statusline = "%!v:lua.require('config.statusline').render()"

return M
