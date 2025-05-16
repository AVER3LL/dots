local diagnostic_icons = require("icons").diagnostics
local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"

local M = {}

M.ToggleDiagnosticIcons = function()
    vim.diagnostic.config {
        title = false,
        virtual_text = {
            prefix = "",
        },
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

return M
