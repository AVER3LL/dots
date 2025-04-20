if vim.g.vscode then
    require "core.vscode_mappings"
else
    require "core"

    require "config.lazy"

    require("config.custom_winbar").setup()
end
