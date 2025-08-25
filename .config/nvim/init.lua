if vim.g.vscode then
    require "core.vscode_mappings"
else
    require "globals"

    require "core"

    require "lsp"

    require("config.winbar").setup()

    -- require "config.statusline"

    vim.cmd.colorscheme "bamboo-multiplex"
end
