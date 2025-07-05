local diagnostic_icons = require("icons").diagnostics
local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"

--- @class Utils
--- @field ToggleDiagnosticIcons fun()
--- @field map fun(mode: string, lhs: string, rhs: string, opts?: table)

local M = {}

--- Toggle diagnostic icons
M.toggle_diagnostic_icons = function()
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

M.toggle_numbers = function()
    if vim.wo.number then
        vim.g.show_line_number = false
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.foldcolumn = "0"
        M.toggle_diagnostic_icons()
    else
        vim.g.show_line_number = true
        vim.opt.number = true
        vim.opt.relativenumber = vim.g.show_relative_line_number
        vim.opt.foldcolumn = "1"
        M.toggle_diagnostic_icons()
    end
end

--- @param mode string | table
--- @param lhs string
--- @param rhs string | fun()
--- @param opts? table
M.map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

--- @type Utils
return M
