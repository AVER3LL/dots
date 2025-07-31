local diagnostic_icons = require("icons").diagnostics

local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        local function opts(desc)
            return { buffer = event.buf, desc = "LSP " .. desc }
        end

        -- map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
        -- map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
        -- map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
        map("n", "gD", Snacks.picker.lsp_declarations, opts "Go to declaration")
        map("n", "gd", Snacks.picker.lsp_definitions, opts "Go to definition")
        map("n", "gi", Snacks.picker.lsp_implementations, opts "Go to implementation")
        -- map("n", "<leader>h", vim.lsp.buf.signature_help, opts "Show signature help")
        map("n", "<leader>k", vim.lsp.buf.hover, opts "Show documentation")
        map("n", "<leader>rn", vim.lsp.buf.rename, opts "Smart rename")
        -- map("n", "<leader>rn", require "config.renamer", opts "Smart rename")
        -- map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
        -- map("n", "]d", vim.diagnostic.jump { count = 1 }, opts "Go to next diagnostic")
        -- map("n", "[d", vim.diagnostic.jump { count = -1 }, opts "Go to previous diagnostic")
        map("n", "<leader>ds", vim.diagnostic.setloclist, opts "Show diagnostic loclist")
        map("n", "<leader>dl", vim.diagnostic.open_float, opts "Show inline diagnostics")
        map("n", "<leader>fs", Snacks.picker.lsp_symbols, opts "Show document symbols")

        map("n", "<leader>dh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), nil)
        end, opts "Toggle inlay hints")

        map("n", "<leader>da", "<cmd>Trouble diagnostics<CR>", opts "Show all diagnostics")

        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
        map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, opts "Run Codelens")
        map({ "n", "v" }, "<leader>cC", vim.lsp.codelens.refresh, opts "Refresh & Display Codelens")

        map("n", "gr", function()
            Snacks.picker.lsp_references()
        end, opts "Go to references")
        map("i", "<C-x>", vim.lsp.buf.signature_help, opts "Show signature help")
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
