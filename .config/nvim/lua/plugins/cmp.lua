---@diagnostic disable: unused-local

local current_border = require("config.looks").current_border
local bt = require("config.looks").border_type()
local symbol_map = {
    Namespace = "󰌗",
    Text = "󰉿",
    Method = "󰊕",
    Function = "󰊕", -- 󰆧 , ƒ, 󰡱, 󰊕, 󰮊 ,󱒗 , 󰫢
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈚",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    Table = "",
    Object = "󰅩",
    Tag = "",
    Array = "[]",
    Boolean = "",
    Number = "",
    Null = "󰟢",
    Supermaven = "",
    String = "󰉿",
    Calendar = "",
    Watch = "󰥔",
    Package = "",
    Copilot = "",
    Codeium = "",
    TabNine = "",
    BladeNav = "",
}

return {
    {
        "hrsh7th/nvim-cmp",
        enabled = not vim.g.use_blink,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", -- source for text in buffer
            "hrsh7th/cmp-path", -- source for file system paths
            "hrsh7th/cmp-nvim-lsp", -- source for lsp
            "hrsh7th/cmp-emoji", -- 😄
            "saadparwaiz1/cmp_luasnip", -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets

            {
                "kristijanhusak/vim-dadbod-ui",
                dependencies = {
                    "tpope/vim-dadbod",
                    "kristijanhusak/vim-dadbod-completion",
                },
                cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
                init = function()
                    -- Your DBUI configuration
                    vim.g.db_ui_use_nerd_fonts = 1
                end,
            },

            {
                "onsails/lspkind.nvim",
                config = function()
                    require("lspkind").init {
                        preset = "codicons",
                        symbol_map = symbol_map,
                    }
                end,
            }, -- vs-code like pictograms

            {
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = "make install_jsregexp",
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                    -- vscode format
                    require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
                    require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

                    -- snipmate format
                    require("luasnip.loaders.from_snipmate").load()
                    require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

                    -- lua format
                    require("luasnip.loaders.from_lua").load()
                    require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

                    vim.api.nvim_create_autocmd("InsertLeave", {
                        callback = function()
                            if
                                require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                                and not require("luasnip").session.jump_active
                            then
                                require("luasnip").unlink_current()
                            end
                        end,
                    })
                end,
            },
        },
        config = function()
            local cmp = require "cmp"

            local luasnip = require "luasnip"

            local lspkind = require "lspkind"

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

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
                    completion = {
                        border = current_border "CmpBorder",
                        winhighlight = "Normal:CmpPmenu,Search:None,FloatBorder:CmpBorder",
                        scrollbar = false,
                    },
                    documentation = {
                        border = current_border "CmpDocBorder",
                        winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
                    },
                },

                mapping = cmp.mapping.preset.insert {
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, true, true), "i", true)
                    end, { "i", "s" }),

                    ["<C-j>"] = cmp.mapping(function(fallback)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), "i", true)
                    end, { "i", "s" }),

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
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), "i", true)
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, true, true), "i", true)
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                -- sources for autocompletion
                sources = cmp.config.sources {
                    { name = "nvim_lsp", priority = 1000 }, -- lsp
                    { name = "luasnip", priority = 850 }, -- snippets
                    { name = "buffer", priority = 750 }, -- text within current buffer
                    { name = "path", priority = 500 }, -- file system paths
                    { name = "emoji", priority = 100 },
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
                        --
                        -- local source = entry.source.name
                        -- item.menu = string.format("%s %s", menu_icon[source] or "", source)
                        --
                        -- if source == "nvim_lsp" then
                        --     local client_name = entry.source.source.client.name
                        --     item.menu = string.format("%s %s", menu_icon[source] or "", client_name)
                        -- else
                        --     item.menu = string.format("%s %s", menu_icon[source] or "", source)
                        -- end

                        return item
                    end,

                    experimental = {
                        ghost_text = true,
                    },
                },
            }

            cmp.setup.filetype({ "sql" }, {
                sources = {
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                },
            })

            -- cmp.setup.filetype({ "markdown" }, {
            --     sources = {
            --         { name = "render-markdown" },
            --     },
            -- })
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
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.snippet_forward()
                        else
                            return cmp.select_next()
                        end
                    end,
                    "select_next",
                    "fallback",
                },
                ["<S-Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.snippet_backward()
                        else
                            return cmp.select_prev()
                        end
                    end,
                    "select_prev",
                    "fallback",
                },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },

            completion = {
                menu = {
                    border = bt,
                    winhighlight = "Normal:CmpPmenu,Search:None,FloatBorder:CmpBorder",
                },
                documentation = {
                    window = { border = bt, winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder" },
                },
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                cmdline = {},
            },
        },
        opts_extend = { "sources.default" },
    },
}
