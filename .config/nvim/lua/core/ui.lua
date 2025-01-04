local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"

local icons = false

local float = {
    style = "minimal",
    border = borderType,
    max_width = 100,
    focusable = true,
    silent = true,
}

-- Hover effects look
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    style = float.style,
    border = float.border,
    silent = float.silent,
    max_width = float.max_width,
    focusable = true,
    max_height = 15,
})

-- Signaure Help look
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    style = float.style,
    border = float.border,
    silent = float.silent,
    max_width = float.max_width,
    focusable = false,
    max_height = 7,
})

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
    -- virtual_text = {
    --     prefix = "",
    --     spacing = 4,
    -- },
    -- virtual_text = false,
    title = false,
    virtual_text = true,
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
