local vue_language_server_path = vim.fn.stdpath "data"
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
}

---@class vim.lsp.Config
local vtsls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    settings = {
        vtsls = {
            tsserver = { globalPlugins = { vue_plugin } },
        },
        typescript = {
            tsserver = {
                maxTsServerMemory = 8192,
                nodePath = "node",
            },
        },
    },
}

return vtsls
