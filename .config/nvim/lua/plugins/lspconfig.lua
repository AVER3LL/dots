---@diagnostic disable: unused-local

-- vim.o.background = (vim.o.background == "dark") and "light" or "dark"
local cmp_plugin
cmp_plugin = vim.g.use_blink and "saghen/blink.cmp" or "hrsh7th/cmp-nvim-lsp"

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
    lua_ls = {
        server_capabilities = {
            semanticTokensProvider = vim.NIL,
        },
    },

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
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        cmp_plugin,
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "Bilal2453/luvit-meta", lazy = true },
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        local on_init = require("config.lsp-requirements").on_init
        local capabilities = require("config.lsp-requirements").capabilities
        local lspconfig = require "lspconfig"

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
