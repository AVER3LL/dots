return {
    ---@module 'lazy'
    ---@type LazySpec
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        config = function()
            local lsp = require "lazydev.lsp"

            ---@diagnostic disable-next-line: duplicate-set-field
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

    ---@module 'lazy'
    ---@type LazySpec
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

                    lua_ls = require "lsp.lua_ls",

                    cssls = require "lsp.cssls",

                    basedpyright = require "lsp.basedpyright",

                    vtsls = require "lsp.vtsls",

                    vue_ls = require "lsp.vue_ls",

                    intelephense = require "lsp.intelephense",

                    emmet_language_server = require "lsp.emmet_language_server",

                    qmlls = require "lsp.qmlls",

                    html = require "lsp.html",

                    jinja_lsp = require "lsp.jinja_lsp",

                    bashls = {},
                    clangd = {},
                    hyprls = {},
                    kotlin_language_server = {},
                    gopls = {},
                    taplo = {},
                    tailwindcss = {},
                    texlab = {},
                    copilot = {},
                    pyrefly = {},

                    -- phpactor = {},
                },

                others = {},
            }

            local ensure_installed = vim.tbl_filter(function(server)
                local ensure_ignored = {}
                return not vim.tbl_contains(ensure_ignored, server)
            end, vim.tbl_keys(servers.mason or {}))

            vim.list_extend(ensure_installed, {
                "jdtls",
                "rust_analyzer",
            })

            vim.lsp.config("*", {
                capabilities = require("lsp").capabilities,
                on_init = require("lsp").on_init,
            })

            for server, config in pairs(vim.tbl_extend("keep", servers.mason, servers.others)) do
                if not vim.tbl_isempty(config) then
                    vim.lsp.config(server, config)
                end
            end

            require("mason-lspconfig").setup {
                ensure_installed = ensure_installed,
                automatic_enable = {
                    exclude = {
                        "phpactor",
                        "jdtls",
                        "emmylua_ls",
                        "copilot",
                        "basedpyright",
                        -- "pyrefly",
                    },
                },
            }

            -- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
            if not vim.tbl_isempty(servers.others) then
                vim.lsp.enable(vim.tbl_keys(servers.others))
            end
        end,
    },
}
