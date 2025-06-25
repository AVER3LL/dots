local diagnostic_icons = require("icons").diagnostics
local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"

--- @class Utils
--- @field ToggleDiagnosticIcons fun()

local M = {}

--- Toggle diagnostic icons
M.ToggleDiagnosticIcons = function()
    vim.diagnostic.config {
        title = false,
        virtual_text = false,
        -- virtual_text = {
        --     prefix = "",
        -- },
        -- virtual_lines = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = vim.g.show_line_number and "" or diagnostic_icons.ERROR,
                [vim.diagnostic.severity.WARN] = vim.g.show_line_number and "" or diagnostic_icons.WARN,
                [vim.diagnostic.severity.INFO] = vim.g.show_line_number and "" or diagnostic_icons.INFO,
                [vim.diagnostic.severity.HINT] = vim.g.show_line_number and "" or diagnostic_icons.HINT,
            },
            numhl = {
                [vim.diagnostic.severity.WARN] = "LspDiagnosticsLineNrWarning",
                [vim.diagnostic.severity.ERROR] = "LspDiagnosticsLineNrError",
                [vim.diagnostic.severity.INFO] = "LspDiagnosticsLineNrInfo",
                [vim.diagnostic.severity.HINT] = "LspDiagnosticsLineNrHint",
            },
        },
        update_in_insert = false,
        severity_sort = true,
        underline = true,
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        float = {
            border = borderType,
            -- Show severity icons as prefixes.
            prefix = function(diag)
                local level = vim.diagnostic.severity[diag.severity]
                local prefix = string.format(" %s  ", diagnostic_icons[level])
                return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
            end,
            source = "if_many",
            style = "minimal",
            header = "",
        },
    }
end

--- @param blinktime number
M.display_search_counts = function(blinktime)
    local ns = vim.api.nvim_create_namespace "search"
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

    local search_pat = "\\c\\%#" .. vim.fn.getreg "/"
    local m = vim.fn.matchadd("IncSearch", search_pat)
    vim.cmd "redraw"
    vim.cmd("sleep " .. blinktime * 1000 .. "m")

    local sc = vim.fn.searchcount()
    vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
        virt_text = { { "[" .. sc.current .. "/" .. sc.total .. "]", "Comment" } },
        virt_text_pos = "eol",
    })

    vim.fn.matchdelete(m)
    vim.cmd "redraw"
end

-- vim.cmd [[
-- nnoremap n nzz:lua require("utils").display_search_counts(0.3)<CR>
-- nnoremap N Nzz:lua require("utils").display_search_counts(0.3)<CR>
-- ]]

--- @type Utils
return M
