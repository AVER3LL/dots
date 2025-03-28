local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"
local icons = false

-- Diagnostic Icons
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = opts.numhl or "",
    })
end

sign { name = "DiagnosticSignError", text = (icons and " ") or "", numhl = "LspDiagnosticsLineNrError" }
sign { name = "DiagnosticSignWarn", text = (icons and " ") or "", numhl = "LspDiagnosticsLineNrWarning" }
sign { name = "DiagnosticSignHint", text = (icons and " ") or "", numhl = "LspDiagnosticsLineNrHint" }
sign { name = "DiagnosticSignInfo", text = (icons and " ") or "", numhl = "LspDiagnosticsLineNrInfo" }

-- effects of lsp diagnostic texts

vim.diagnostic.config {
    title = false,
    virtual_text = true,
    -- virtual_lines = true,
    signs = true,
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
