local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"
local diagnostic_icons = require("icons").diagnostics

local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- LSP Keymappings (inside LspAttach autocmd)
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        local function opts(desc)
            return { buffer = event.buf, desc = "LSP " .. desc }
        end

        map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
        map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
        map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
        map("n", "<leader>h", vim.lsp.buf.signature_help, opts "Show signature help")
        map("n", "<leader>k", vim.lsp.buf.hover, opts "Show documentation")
        map("n", "<leader>rn", vim.lsp.buf.rename, opts "Smart rename")
        -- map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
        -- map("n", "]d", vim.diagnostic.jump { count = 1 }, opts "Go to next diagnostic")
        -- map("n", "[d", vim.diagnostic.jump { count = -1 }, opts "Go to previous diagnostic")
        map("n", "<leader>ds", vim.diagnostic.setloclist, opts "Show diagnostic loclist")
        map("n", "<leader>dl", vim.diagnostic.open_float, opts "Show inline diagnostics")
        map("n", "<leader>fs", require("telescope.builtin").lsp_document_symbols, opts "Show document symbols")

        map("n", "<leader>dh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), nil)
        end, opts "Toggle inlay hints")

        map("n", "<leader>da", "<cmd>Trouble diagnostics<CR>", opts "Show all diagnostics")

        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
        map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, opts "Run Codelens")
        map({ "n", "v" }, "<leader>cC", vim.lsp.codelens.refresh, opts "Refresh & Display Codelens")

        map("n", "gr", require("telescope.builtin").lsp_references, opts "Go to references")
        map("i", "<C-x>", vim.lsp.buf.signature_help, opts "Show signature help")
    end,
})

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
    border = borderType,
    max_width = 100,
    focusable = true,
    silent = true,
}

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
    return hover {
        border = float.border,
        max_width = float.max_width,
        max_height = 15,
        focusable = true,
        silent = float.silent,
    }
end

local signature = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
    return signature {
        border = float.border,
        max_width = float.max_width,
        max_height = 7,
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
