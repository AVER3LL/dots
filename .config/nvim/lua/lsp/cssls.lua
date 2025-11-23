---@class vim.lsp.Config
local cssls = {
    settings = {
        css = {
            lint = {
                -- TWEAK: Do not warn for tailwind's @apply rules
                unknownAtRules = "ignore",
            },
        },
    },
}

return cssls
