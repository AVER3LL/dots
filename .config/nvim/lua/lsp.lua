local ok, border = pcall(require, "config.looks")
local border_type = ok and border.border_type() or "rounded"

local map = require("utils").map

-- LSP Keymappings (inside LspAttach autocmd)
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
        -- map("n", "<leader>rn", vim.lsp.buf.rename, opts "Smart rename")
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

require("utils").toggle_diagnostic_icons()

local float = {
    style = "minimal",
    border = border_type,
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
