return {
    -- Added them in the same file here because Kickstart recommended so

    {
        "mason-org/mason.nvim",
        lazy = true,
        opts = {
            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = " ",
                    package_uninstalled = " ",
                },
            },
            max_concurrent_installers = 10,
        },
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            local vue_language_server_path = vim.fn.stdpath "data"
                .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
            local vue_plugin = {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript",
            }

            local servers = {

                lua_ls = {},
                -- ts_ls = {},
                bashls = {},
                clangd = {},
                cssls = {},
                hyprls = {},
                kotlin_language_server = {},
                gopls = {},
                taplo = {},
                tailwindcss = {},
                texlab = {},

                basedpyright = {
                    analysis = {
                        typeCheckingMode = "strict",
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true,
                    },
                },

                -- vtsls = {
                --     filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
                --     settings = {
                --         vtsls = {
                --             tsserver = {
                --                 globalPlugins = {
                --                     {
                --                         configNamespace = "typescript",
                --                         enableForWorkspaceTypeScriptVersions = true,
                --                         languages = { "vue" },
                --                         location = vim.fn.stdpath "data"
                --                             .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                --                         name = "@vue/typescript-plugin",
                --                     },
                --                 },
                --             },
                --         },
                --     },
                -- },

                vue_ls = {},

                html = {
                    filetypes = { "html", "templ" },
                },

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
                                }, -- Associating .blade.php files as well
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
            }

            local ensure_installed = vim.tbl_filter(function(server)
                local ensure_ignored = { "clangd" }
                return not vim.tbl_contains(ensure_ignored, server)
            end, vim.tbl_keys(servers or {}))

            vim.list_extend(ensure_installed, {
                "jdtls",
                -- "ts_ls",
                "rust_analyzer",
                "vue_ls",
            })

            require("mason-lspconfig").setup {
                ensure_installed = ensure_installed,
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            }
        end,
    },
}
