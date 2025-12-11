if vim.g.vscode then
    require "core.vscode_mappings"
    return
end

require "globals"

require "core"

require "lsp"

require("config.winbar").setup()

vim.cmd.colorscheme "bamboo"

require "config.generated"

-- require("vim._extui").enable {}
