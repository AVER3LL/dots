local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"

-- effects of lsp diagnostic textst

vim.diagnostic.config {
    title = false,
    virtual_text = true,
    -- virtual_lines = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
        },
    },
    update_in_insert = false,
    severity_sort = true,
    underline = true,
    float = {
        border = borderType,
        source = "if_many",
        style = "minimal",
        header = "",
        prefix = "",
    },
}
