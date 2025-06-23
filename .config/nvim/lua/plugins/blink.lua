local bt = require("config.looks").border_type()
local symbol_map = require("icons").symbol_kinds

return {
    {
        "saghen/blink.cmp",
        enabled = vim.g.use_blink,
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {

            keymap = {
                preset = "none",
                ["<C-space>"] = { "show" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<Tab>"] = {
                    "snippet_forward",
                    "select_next",
                    "fallback",
                },
                ["<S-Tab>"] = {
                    "snippet_backward",
                    "select_prev",
                    "fallback",
                },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
                kind_icons = symbol_map,
            },

            signature = {
                enabled = false,
                window = {
                    show_documentation = true,
                },
            },

            cmdline = {
                enabled = false,
            },

            snippets = { preset = "luasnip" },

            completion = {
                list = {
                    selection = { preselect = true, auto_insert = false },
                },
                menu = {
                    draw = {
                        -- left and right padding
                        padding = { 1, 1 },
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 2 },
                        },
                        components = {
                            kind_icon = {
                                -- Add some space between the label and the icon
                                text = function(ctx)
                                    return "   " .. ctx.kind_icon .. ctx.icon_gap
                                end,
                            },
                        },
                    },
                    border = bt,
                    scrollbar = false,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    window = {
                        border = bt,
                        scrollbar = false,
                        max_width = 100,
                    },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },

            sources = {
                default = function()
                    local sources = { "lazydev", "lsp", "buffer", "blade-nav" }
                    local ok, node = pcall(vim.treesitter.get_node)

                    if ok and node then
                        if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
                            table.insert(sources, "path")
                        end
                        if node:type() ~= "string" then
                            table.insert(sources, "snippets")
                        end
                    end

                    return sources
                end,

                providers = {
                    ["blade-nav"] = {
                        module = "blade-nav.blink",
                        opts = {
                            close_tag_on_complete = false, -- default: true,
                        },
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            -- opts_extend = { "sources.default" },
        },
    },

    {
        "saghen/blink.compat",
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = "*",
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    },
}
