---@class vim.lsp.Config
local vue_ls = {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
    settings = {
        vue = {
            complete = {
                casing = {
                    props = "autoCamel",
                },
            },
        },
    },
}

return vue_ls
