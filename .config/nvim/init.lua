if vim.g.vscode then
    require "core.vscode_mappings"
else
    require("config.looks").set_border("square")

    require "core"

    require "lsp"

    require "config.lazy"

    require("config.custom_winbar").setup()
end
