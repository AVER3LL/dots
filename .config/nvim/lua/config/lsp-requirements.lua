local M = {}
-- local map = vim.keymap.set
local function table_concat(t1, t2)
    for i = 1, #t2 do
        table.insert(t1, t2[i])
    end
    return t1
end

local map = function(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, table_concat(opts, { noremap = true }))
end

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end

    map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
    map("n", "<leader>h", vim.lsp.buf.signature_help, opts "Show signature help")
    map("n", "<leader>k", vim.lsp.buf.hover, opts "Show documentation")

    map("n", "<leader>rn", vim.lsp.buf.rename, opts "Smart rename")

    map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
    -- map("n", "]d", vim.diagnostic.goto_next, opts "Go to next diagnostic")
    -- map("n", "[d", vim.diagnostic.goto_prev, opts "Go to previous diagnostic")
    map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })
    map("n", "<leader>dl", vim.diagnostic.open_float, opts "Show inline diagnostics")
    map("n", "<leader>da", "<cmd>Trouble diagnostics<CR>", opts "Show all diagnostics")

    map("n", "<leader>dh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), nil)
    end, opts "Toggle inlay hints")

    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
    map("n", "gr", require("telescope.builtin").lsp_references, opts "Go to references")

    map("i", "<C-x>", vim.lsp.buf.signature_help, opts "Show signature help")
end

-- disable semanticTokens
M.on_init = function(client, _)
    if client:supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- M.capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true,
-- }

M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

return M
