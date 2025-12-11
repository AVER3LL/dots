---@class vim.lsp.Config
local lua_ls = {
    settings = {
        Lua = {
            completion = { callSnippet = "Replace" },
            format = { enable = false },
            diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
            },
            hint = {
                enable = true,
                arrayIndex = "Disable",
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                checkThirdParty = false,
                ignoreSubmodules = true,
                library = {
                    vim.env.VIMRUNTIME,
                    "${3rd}/luv/library",
                },
            },
        },
    },
}

return lua_ls
