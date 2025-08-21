return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        config = function()
            local lsp = require "lazydev.lsp"

            lsp.update = function(client)
                client:notify("workspace/didChangeConfiguration", {
                    settings = { Lua = {} },
                })
            end

            require("lazydev").setup {
                library = {

                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                    { path = "snacks.nvim", words = { "Snacks" } },
                },
            }
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            ---@class LspServersConfig
            ---@field mason table<string, vim.lsp.Config>
            ---@field others table<string, vim.lsp.Config>
            local servers = {

                mason = {

                    lua_ls = {
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
                            },
                        },
                    },

                    bashls = {},
                    clangd = {},
                    cssls = {},
                    hyprls = {},
                    kotlin_language_server = {},
                    gopls = {},
                    taplo = {},
                    tailwindcss = {},
                    qmlls = {
                        cmd = { "qmlls", "-E" },
                    },
                    texlab = {},

                    basedpyright = {
                        settings = {
                            basedpyright = {
                                analysis = {
                                    typeCheckingMode = "basic",
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                    inlayHints = {
                                        callArgumentNames = true,
                                    },
                                    diagnosticSeverityOverrides = {
                                        reportUnknownVariableType = "none",
                                        reportUnknownMemberType = "none",
                                        reportImplicitRelativeImport = "none",
                                        reportMissingTypeStubs = "none",
                                        reportAttributeAccessIssue = "none",
                                    },
                                },
                            },
                        },
                    },

                    vue_ls = {},

                    html = {},

                    intelephense = {
                        filetypes = {
                            "php",
                            "blade",
                            "php_only",
                        },
                        settings = {
                            intelephense = {
                                filetypes = {
                                    "php",
                                    "blade",
                                    "php_only",
                                },
                                files = {
                                    associations = {
                                        "*.php",
                                        "*.blade.php",
                                    },
                                    maxSize = 5000000,
                                },
                            },
                        },
                    },

                    jinja_lsp = {
                        filetypes = { "jinja", "htmldjango" },
                    },

                    emmet_language_server = {
                        filetypes = {
                            "django",
                            "astro",
                            "css",
                            "eruby",
                            "html",
                            "htmlangular",
                            "htmldjango",
                            "javascriptreact",
                            "less",
                            "pug",
                            "sass",
                            "scss",
                            "svelte",
                            "templ",
                            "typescriptreact",
                            "vue",
                        },
                    },
                },

                others = {},
            }

            local ensure_installed = vim.tbl_filter(function(server)
                local ensure_ignored = { "clangd" }
                return not vim.tbl_contains(ensure_ignored, server)
            end, vim.tbl_keys(servers.mason or {}))

            vim.list_extend(ensure_installed, {
                "jdtls",
                "rust_analyzer",
            })

            for server, config in pairs(vim.tbl_extend("keep", servers.mason, servers.others)) do
                if not vim.tbl_isempty(config) then
                    vim.lsp.config(server, config)
                end
            end

            require("mason-lspconfig").setup {
                ensure_installed = ensure_installed,
                automatic_enable = true,
            }

            -- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
            if not vim.tbl_isempty(servers.others) then
                vim.lsp.enable(vim.tbl_keys(servers.others))
            end
        end,
    },
}
