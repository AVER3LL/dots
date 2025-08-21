local diagnostic_icons = require("icons").diagnostics
local methods = vim.lsp.protocol.Methods

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    ---@param mode? string|string[]
    ---@param rhs string|function
    ---@param lhs string
    ---@param desc string
    local function keymap(mode, lhs, rhs, desc)
        mode = mode or "n"
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP " .. desc })
    end

    keymap({ "n", "x" }, "<leader>ca", function()
        ---@diagnostic disable-next-line: missing-parameter
        require("tiny-code-action").code_action()
    end, "Display code actions")

    keymap("n", "<leader>dl", vim.diagnostic.open_float, "Show inline diagnostics")

    keymap("n", "<leader>da", "<cmd>Trouble diagnostics<CR>", "Show all diagnostics")

    keymap("n", "<leader>ds", vim.diagnostic.setloclist, "Show diagnostic loclist")

    keymap("n", "<leader>fs", Snacks.picker.lsp_symbols, "Show document symbols")

    if client:supports_method(methods.textDocument_definition) then
        keymap("n", "gd", Snacks.picker.lsp_definitions, "Go to definition")
    end

    if client:supports_method(methods.textDocument_declaration) then
        keymap("n", "gD", Snacks.picker.lsp_declarations, "Go to declaration")
    end

    if client:supports_method(methods.textDocument_implementation) then
        keymap("n", "gi", Snacks.picker.lsp_implementations, "Go to implementation")
    end

    if client:supports_method(methods.textDocument_signatureHelp) then
        keymap("i", "<C-x>", vim.lsp.buf.signature_help, "Show signature help")
    end

    if client:supports_method(methods.textDocument_references) then
        keymap("n", "gr", Snacks.picker.lsp_references, "Go to references")
    end

    if client:supports_method(methods.textDocument_hover) then
        keymap("n", "<leader>k", vim.lsp.buf.hover, "Show documentation")
    end

    if client:supports_method(methods.textDocument_inlayHint) then
        keymap("n", "<leader>dh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "Toggle inlay hints")
    end

    if client:supports_method(methods.textDocument_rename) then
        keymap("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

        vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
            group = highlight_augroup,
            desc = "Highlight references under cursor",
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
            group = highlight_augroup,
            desc = "Clear highlight references",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event.buf }
            end,
        })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if not client then
            return
        end

        on_attach(client, event.buf)
    end,
})

vim.diagnostic.config {
    title = false,
    virtual_text = false,
    virtual_lines = false,

    update_in_insert = false,
    severity_sort = true,
    underline = true,
    -- underline = { severity = vim.diagnostic.severity.ERROR },

    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
            [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
            [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
            [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = "LspDiagnosticsLineNrWarning",
            [vim.diagnostic.severity.ERROR] = "LspDiagnosticsLineNrError",
            [vim.diagnostic.severity.INFO] = "LspDiagnosticsLineNrInfo",
            [vim.diagnostic.severity.HINT] = "LspDiagnosticsLineNrHint",
        },
    },

    float = {
        border = tools.border,
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

local float = {
    style = "minimal",
    border = tools.border,
    max_width = 100,
    focusable = true,
    silent = true,
}

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
    return hover {
        border = float.border,
        max_width = math.floor(vim.o.columns * 0.5),
        max_height = math.floor(vim.o.lines * 0.5),
        focusable = true,
        silent = float.silent,
    }
end

local signature = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
    return signature {
        border = float.border,
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.floor(vim.o.lines * 0.5),
        focusable = false,
        silent = float.silent,
    }
end

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
    show = function(ns, bufnr, diagnostics, opts)
        table.sort(diagnostics, function(diag1, diag2)
            return diag1.severity > diag2.severity
        end)
        return show_handler(ns, bufnr, diagnostics, opts)
    end,
    hide = hide_handler,
}
