if vim.g.vscode then
    require "core.vscode_mappings"
    return
end

require "globals"

require "core"

require "lsp"

require("config.winbar").setup()

vim.cmd.colorscheme "thorn"

require "config.generated"

-- vim.g.theme = {
--     dark = "github_dark_dimmed",
--     light = "github_light_high_contrast",
-- }

-- vim.cmd.colorscheme(vim.g.theme[vim.o.background])

-- require "config.statusline"

-- require("vim._extui").enable {}
