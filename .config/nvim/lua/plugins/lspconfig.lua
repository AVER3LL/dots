local cmp_plugin
cmp_plugin = vim.g.use_blink and "saghen/blink.cmp" or "hrsh7th/cmp-nvim-lsp"

local servers = require("config.lsp.servers").lspconfig

return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            cmp_plugin,
            { "antosha417/nvim-lsp-file-operations", opts = {} },
            { "Bilal2453/luvit-meta", lazy = true },
        },
        config = function()
            local on_init = require("config.lsp-requirements").on_init
            local capabilities = require("config.lsp-requirements").capabilities
            local lspconfig = require "lspconfig"

            local cmp_capabilities = vim.g.use_blink and require("blink.cmp").get_lsp_capabilities()
                or require("cmp_nvim_lsp").default_capabilities()

            capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities, {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            })

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
    },
}
