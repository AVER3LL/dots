local M = {}

M.mason = {}

M.default = {
    "hyprls", -- Hyprland dots
    "html",
    "texlab",
    "cssls", -- CSS lsp
    "clangd", -- C lsp
    "taplo", -- markdown
    "bashls", -- bash lsp
    "tailwindcss", -- obvious
    "basedpyright",
    "lua_ls",
}

-- Function to convert the default array into key-value pairs
local function process_default_lsps()
    local result = {}
    for _, lsp_name in ipairs(M.default) do
        result[lsp_name] = true
    end
    return result
end

M.lspconfig = vim.tbl_extend("force", process_default_lsps(), {
    intelephense = { -- no nonsense lsp for php. No rename tho
        filetypes = {
            "php",
            "blade",
            "php_only",
        },
        settings = {
            intelephense = {
                filetypes = {
                    "php",
                    -- "blade",
                    "php_only",
                },
                files = {
                    associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
                    maxSize = 5000000,
                },
            },
        },
    },

    ts_ls = {
        single_file_support = true,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "literal",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },

    jinja_lsp = {
        filetypes = { "jinja", "htmldjango" },
    },

    emmet_language_server = {
        filetypes = {
            "css",
            "php",
            "blade",
            "eruby",
            "html",
            "htmldjango",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
        },
    },

    gopls = {
        filetypes = { "go", "gomod", "gowork", "gohtmltmpl", "gotexttmpl", "gotmpl" },
        settings = {
            gopls = {
                analyses = {
                    fieldalignment = true,
                    unusedparams = true,
                },
                staticcheck = true,
                completeUnimported = true,
                usePlaceholders = true,
            },
        },
    },
})

return M
