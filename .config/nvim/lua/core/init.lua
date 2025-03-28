-- TWEAK: Added those configs here before they have to be set
-- before they are invoked in the mappings file
local ok, border = pcall(require, "config.looks")
local borderType = ok and border.border_type() or "rounded"

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

require "core.options"
require "core.mappings"
require "core.autocommand"
require "core.ui"
require "core.neovide"
