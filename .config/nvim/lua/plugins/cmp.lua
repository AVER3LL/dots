---@diagnostic disable: unused-local

local current_border = require("config.looks").border
local bt = require("config.looks").border_type()
local symbol_map = require("icons").symbol_kinds

return {
    {
        "hrsh7th/nvim-cmp",
        enabled = not vim.g.use_blink,
        version = "1.*",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", -- source for text in buffer
            "hrsh7th/cmp-path", -- source for file system paths
            "hrsh7th/cmp-nvim-lsp", -- source for lsp
            "saadparwaiz1/cmp_luasnip", -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "f3fora/cmp-spell",
            "L3MON4D3/LuaSnip",
            { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
        },
        config = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"

            cmp.setup {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },

                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                window = {
                    completion = cmp.config.window.bordered {
                        border = bt,
                        scrollbar = false,
                        -- winhighlight = "Normal:Pmenu,Search:None,FloatBorder:Pmenu",
                    },
                    documentation = cmp.config.window.bordered {
                        border = bt,
                        scrollbar = false,
                        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu",
                    },
                },

                mapping = cmp.mapping.preset.insert {

                    ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                    ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },

                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(), -- close completion window

                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                -- sources for autocompletion
                sources = cmp.config.sources {
                    {
                        name = "lazydev",
                        -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                        group_index = 0,
                    },
                    { name = "nvim_lsp", priority = 1000 }, -- lsp
                    { name = "luasnip", priority = 850 }, -- snippets
                    { name = "buffer", priority = 750 }, -- text within current buffer
                    { name = "path", priority = 500 }, -- file system paths
                    -- { name = "emoji", priority = 100 },
                },

                -- configure lspkind for vs-code like pictograms in completion menu
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    -- expandable_indicator = true,
                    fields = { "abbr", "kind", "menu" },
                    format = function(entry, item)
                        local icons = symbol_map
                        local icon = icons[item.kind] or ""
                        local kind = item.kind or ""

                        item.kind = "   " .. icon .. "  " .. kind .. " " -- Add space between the icon and the kind
                        item.menu_hl_group = "comment"

                        -- Custom menu icons
                        local menu_icon = {
                            nvim_lsp = "λ",
                            luasnip = "⋗",
                            buffer = "󰦨",
                            path = "",
                            nvim_lua = "",
                        }

                        item.menu = ""

                        -- Combine icon with source name
                        -- local source = entry.source.name
                        -- item.menu = string.format("%s %s", menu_icon[source] or "", source)
                        --
                        -- if source == "nvim_lsp" then
                        --     local client_name = entry.source.source.client.name
                        --     item.menu = string.format("%s %s", menu_icon[source] or "", client_name)
                        -- else
                        --     item.menu = string.format("%s %s", menu_icon[source] or "", source)
                        -- end

                        -- return item
                        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
                    end,

                    experimental = {
                        ghost_text = true,
                    },
                },
            }
        end,
    },

    {
        "saghen/blink.cmp",
        enabled = vim.g.use_blink,
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",
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
                    winhighlight = "Normal:BlinkCmpMenu,Search:None,FloatBorder:BlinkCmpMenuBorder",
                    -- winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    scrollbar = false,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    window = {
                        border = bt,
                        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
                        -- winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
                        scrollbar = false,
                        max_width = 100,
                    },
                },
            },

            sources = {
                default = function()
                    local sources = { "lsp", "buffer" }
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
            },
            -- opts_extend = { "sources.default" },
        },
    },
}
