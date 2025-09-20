local diagnostic_icons = require("icons").diagnostics
local methods = vim.lsp.protocol.Methods

vim.g.inlay_hints = true

local M = {}

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
        keymap("i", "<C-x>", function()
            -- Close the completion menu first (if open).
            if require("blink.cmp.completion.windows.menu").win:is_open() then
                require("blink.cmp").hide()
            end

            vim.lsp.buf.signature_help()
        end, "Show signature help")
    end

    if client:supports_method(methods.textDocument_references) then
        keymap("n", "gr", Snacks.picker.lsp_references, "Go to references")
    end

    if client:supports_method(methods.textDocument_hover) or client.name == "dartls" then
        keymap("n", "<leader>k", vim.lsp.buf.hover, "Show documentation")
    end

    if client:supports_method(methods.textDocument_inlayHint) then
        keymap("n", "<leader>dh", function()
            if vim.g.inlay_hints then
                vim.lsp.inlay_hint.enable(false)
            else
                vim.lsp.inlay_hint.enable(true)
            end

            vim.g.inlay_hints = not vim.g.inlay_hints
        end, "Toggle inlay hints")

        local inlay_hints_group = vim.api.nvim_create_augroup("mariasolos/toggle_inlay_hints", { clear = false })

        vim.lsp.inlay_hint.enable(vim.g.inlay_hints)

        vim.api.nvim_create_autocmd("InsertEnter", {
            group = inlay_hints_group,
            desc = "Enable inlay hints",
            buffer = bufnr,
            callback = function()
                if vim.g.inlay_hints then
                    vim.lsp.inlay_hint.enable(false)
                end
            end,
        })

        vim.api.nvim_create_autocmd("InsertLeave", {
            group = inlay_hints_group,
            desc = "Disable inlay hints",
            buffer = bufnr,
            callback = function()
                if vim.g.inlay_hints then
                    vim.lsp.inlay_hint.enable(true)
                end
            end,
        })
    end

    if client:supports_method(methods.textDocument_rename) or client.name == "dartls" then
        keymap("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

        -- PERF: Commented because my laptop is dying

        -- vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        --     group = highlight_augroup,
        --     desc = "Highlight references under cursor",
        --     buffer = bufnr,
        --     callback = vim.lsp.buf.document_highlight,
        -- })
        --
        -- vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        --     group = highlight_augroup,
        --     desc = "Clear highlight references",
        --     buffer = bufnr,
        --     callback = vim.lsp.buf.clear_references,
        -- })
        --
        -- vim.api.nvim_create_autocmd("LspDetach", {
        --     group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        --     callback = function(event)
        --         vim.lsp.buf.clear_references()
        --         vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event.buf }
        --     end,
        -- })
    end
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    on_attach(client, bufnr)

    return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if not client then
            return
        end

        on_attach(client, event.buf)

        if vim.g.enable_signature then
            local signatureProvider = client.server_capabilities.signatureHelpProvider
            if signatureProvider and signatureProvider.triggerCharacters then
                require("config.signature").setup(client, event.buf)
            end
        end

        local ok, navic = pcall(require, "nvim-navic")
        if ok then
            navic.attach(client, event.buf)
        end
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

-- Override inlay hints handler to add padding
local inlay_hint_handler = vim.lsp.handlers["textDocument/inlayHint"]
vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
    if err or not result then
        return inlay_hint_handler(err, result, ctx, config)
    end

    -- Add spaces around inlay hints
    for _, hint in ipairs(result) do
        if hint.label then
            if type(hint.label) == "string" then
                hint.label = " " .. hint.label .. " "
            elseif type(hint.label) == "table" then
                -- Handle InlayHintLabelPart[] format
                if #hint.label > 0 then
                    hint.label[1].value = " " .. hint.label[1].value
                    hint.label[#hint.label].value = hint.label[#hint.label].value .. " "
                end
            end
        end
    end

    return inlay_hint_handler(err, result, ctx, config)
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

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

M.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

M.on_init = function(client, _)
    if client:supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

return M
