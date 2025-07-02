if vim.g.vscode then
    require "core.vscode_mappings"
else
    require "core"

    require "lsp"

    require "config.lazy"

    require("config.winbar").setup()
    require "config.statusline"
end
