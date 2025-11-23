---@class vim.lsp.Config
local lua_ls = {
    settings = {
        Lua = {
            completion = { callSnippet = "Replace" },
            format = { enable = false },
            hint = {
                enable = true,
                arrayIndex = "Disable",
            },
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                },
            },
        },
    },
}

return lua_ls
