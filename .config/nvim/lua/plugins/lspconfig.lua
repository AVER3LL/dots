---@diagnostic disable: unused-local

local cmp_plugin
if vim.g.use_blink then
    cmp_plugin = "saghen/blink.cmp"
else
    cmp_plugin = "hrsh7th/cmp-nvim-lsp"
end

local servers = {

    hyprls = true, -- Hyprland dots

    html = true,

    texlab = true,

    cssls = true, -- Css lsp

    clangd = true, -- C lsp

    taplo = true, -- markdown. dunno what it does

    bashls = true, -- bash lsp

    -- tailwindcss = true, -- obvious

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

    -- phpactor = true, -- foss lsp for php

    -- ts_ls = true,

    ts_ls = {
        javascript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayParameterNameHints = "all",
            },
        },
        typescript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayParameterNameHints = "all",
            },
        },
    },

    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    -- useLibraryCodeForTypes = true,
                    -- reportAttributeAccessIssue = false,
                    -- reportUnusedVariable = false,
                    -- typeCheckingMode = "off", -- Disable type checking diagnostics
                },
            },
        },
        single_file_support = true,
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

    -- lua_ls = true,

    -- lua_ls = {
    --     settings = {
    --         Lua = {
    --             diagnostics = {
    --                 globals = { "vim" },
    --             },
    --             telemetry = {
    --                 enable = false,
    --             },
    --             hint = { enable = true },
    --             workspace = {
    --                 library = {
    --                     vim.fn.expand "$VIMRUNTIME/lua",
    --                     vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
    --                     vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
    --                     -- "${3rd}/luv/library",
    --                     { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    --                 },
    --                 maxPreload = 100000,
    --                 preloadFileSize = 10000,
    --             },
    --         },
    --     },
    -- },

    lua_ls = {
        settings = {
            Lua = {
                telemetry = {
                    enable = false,
                },
            },
        },
        on_init = function(client)
            local join = vim.fs.joinpath
            local path = client.workspace_folders[1].name

            -- Don't do anything if there is project local config
            if vim.uv.fs_stat(join(path, ".luarc.json")) or vim.uv.fs_stat(join(path, ".luarc.jsonc")) then
                return
            end

            -- Apply neovim specific settings
            local runtime_path = vim.split(package.path, ";")
            table.insert(runtime_path, join("lua", "?.lua"))
            table.insert(runtime_path, join("lua", "?", "init.lua"))

            local nvim_settings = {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    version = "LuaJIT",
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        -- Make the server aware of Neovim runtime files
                        vim.env.VIMRUNTIME,
                        vim.fn.stdpath "config",
                    },
                },
            }

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, nvim_settings)
        end,
    },
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        cmp_plugin,
        { "antosha417/nvim-lsp-file-operations", config = true },
        {
            "folke/lazydev.nvim",
            -- enabled = false,
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        local on_init = require("config.lsp-requirements").on_init

        local lspconfig = require "lspconfig"

        local capabilities = require("config.lsp-requirements").capabilities

        if vim.g.use_blink then
            capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
        else
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
        end

        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local ok, border = pcall(require, "config.looks")

        if ok then
            require("lspconfig.ui.windows").default_options.border = border.border_type() -- rounded, single
        end

        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end

            config = vim.tbl_deep_extend("force", {}, {
                capabilities = capabilities,
                on_init = on_init,
            }, config)

            lspconfig[name].setup(config)
        end
    end,
}
