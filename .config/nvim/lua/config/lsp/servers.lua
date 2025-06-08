local M = {}

M.mason = {
    "basedpyright",
    "bash-language-server",
    "css-lsp",
    "css-variables-language-server",
    "cssmodules-language-server",
    "emmet-language-server",
    "gopls",
    "hyprls",
    "intelephense",
    "jdtls",
    "jinja-lsp",
    "rust-analyzer",
    "kotlin-language-server",
    "lua-language-server",
    "tailwindcss-language-server",
    "taplo",
    "texlab",
    "typescript-language-server",
}

M.default = {
    "bashls", -- bash lsp
    "clangd", -- C lsp
    "cssls", -- CSS lsp
    -- "html",
    "hyprls", -- Hyprland dots
    "kotlin_language_server",
    "lua_ls",
    "tailwindcss",
    "taplo", -- markdown
    "texlab",
    -- "rust_analyzer",
    -- "basedpyright", -- apparently need to set contentFormat to "plaintext" if I want to fix doc breaks
    -- "css_variables",
    -- "cssmodules_ls",
    -- "html",
    -- "phpactor",
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

    basedpyright = {
        settings = {
            basedpyright = {
                typeCheckingMode = "basic", -- or "off"
                diagnosticSeverityOverrides = {
                    reportUnknownVariableType = "none",
                    reportMissingTypeStubs = "none",
                },
            },
        },
    },

    html = {
        filetypes = { "html", "templ", "blade" },
    },

    intelephense = {
        filetypes = {
            "php",
            "blade",
            -- "php_only",
        },
        settings = {
            intelephense = {
                filetypes = {
                    "php",
                    "blade",
                    -- "php_only",
                },
                files = {
                    associations = {
                        "*.php",
                        "*.blade.php",
                    }, -- Associating .blade.php files as well
                    maxSize = 5000000,
                },
            },
        },
    },

    -- ts_ls = {
    --     single_file_support = true,
    --     init_options = {
    --         plugins = {
    --             {
    --                 name = "@vue/typescript-plugin",
    --                 location = vim.fn.stdpath "data"
    --                     .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
    --                 languages = { "vue" },
    --             },
    --         },
    --     },
    --     settings = {
    --         typescript = {
    --             inlayHints = {
    --                 includeInlayParameterNameHints = "literal",
    --                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --                 includeInlayFunctionParameterTypeHints = true,
    --                 includeInlayVariableTypeHints = false,
    --                 includeInlayPropertyDeclarationTypeHints = true,
    --                 includeInlayFunctionLikeReturnTypeHints = true,
    --                 includeInlayEnumMemberValueHints = true,
    --             },
    --         },
    --         javascript = {
    --             inlayHints = {
    --                 includeInlayParameterNameHints = "all",
    --                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    --                 includeInlayFunctionParameterTypeHints = true,
    --                 includeInlayVariableTypeHints = true,
    --                 includeInlayPropertyDeclarationTypeHints = true,
    --                 includeInlayFunctionLikeReturnTypeHints = true,
    --                 includeInlayEnumMemberValueHints = true,
    --             },
    --         },
    --     },
    -- },

    jinja_lsp = {
        filetypes = { "jinja", "htmldjango" },
    },

    volar = {
        vue = {
            hybridMode = false,
        },
    },

    emmet_language_server = {
        filetypes = {
            "blade",
            "css",
            "eruby",
            "html",
            "htmldjango",
            "javascript",
            "javascriptreact",
            "less",
            "php",
            "pug",
            "sass",
            "scss",
            "typescriptreact",
            "vue",
        },
    },

    gopls = {
        filetypes = { "go", "gohtmltmpl", "gomod", "gotexttmpl", "gotmpl", "gowork" },
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
