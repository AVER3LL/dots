local symbol_map = require("icons").symbol_kinds

local function is_laravel_source(source_name)
    return vim.list_contains({ "Blade-nav", "Laravel", "laravel" }, source_name)
end

---@type "vscode"|"normal"
local blink_kind = "vscode"

local blink_style = {
    vscode = {
        columns = {
            { "kind_icon", gap = 2 },
            { "label", "label_description", gap = 1 },
        },
        kind_icon_formatter = function(ctx)
            local icon = is_laravel_source(ctx.source_name) and "" or ctx.kind_icon

            return icon .. ctx.icon_gap .. " "
        end,
    },
    normal = {
        columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 2 },
        },
        kind_icon_formatter = function(ctx)
            local icon = is_laravel_source(ctx.source_name) and "" or ctx.kind_icon

            return "   " .. icon .. ctx.icon_gap
        end,
    },
}

local has_words_before = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if col == 0 then
        return false
    end
    local line = vim.api.nvim_get_current_line()
    return line:sub(col, col):match "%s" == nil
end

return {
    ---@module 'lazy'
    ---@type LazySpec
    {
        "saghen/blink.cmp",
        event = "InsertEnter",
        dependencies = {
            -- "rafamadriz/friendly-snippets",
            "saghen/blink.compat",
        },
        version = "*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {

            keymap = {
                preset = "none",

                ["<C-i>"] = { "show" },
                ["<C-o>"] = { "select_accept_and_enter" },

                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<Tab>"] = {
                    "snippet_forward",
                    "select_next",
                    "fallback",
                },

                -- TODO: work on this
                -- ["<Tab>"] = {
                --     function(cmp)
                --         if cmp.is_visible() then
                --             cmp.select_next()
                --         elseif has_words_before() then
                --             cmp.show()
                --             cmp.accept()
                --         end
                --     end,
                -- },

                ["<S-Tab>"] = {
                    "snippet_backward",
                    "select_prev",
                    "fallback",
                },
            },

            appearance = {
                use_nvim_cmp_as_default = false,
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
                    -- auto_show = false,
                    -- auto_show_delay_ms = 750,
                    draw = {
                        -- left and right padding
                        padding = { 1, 1 },
                        columns = blink_style[blink_kind].columns,
                        components = {
                            kind_icon = {
                                text = blink_style[blink_kind].kind_icon_formatter,
                                highlight = function(ctx)
                                    local hl = is_laravel_source(ctx.source_name) and "Laravel" or ctx.kind_hl

                                    return { { group = hl, priority = 20000 } }
                                end,
                            },
                        },
                    },
                    border = tools.border,
                    scrollbar = false,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    window = {
                        border = tools.border,
                        scrollbar = false,
                        max_width = 100,
                    },
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },

            sources = {
                default = function()
                    local success, node = pcall(vim.treesitter.get_node)
                    if not (success and node) then
                        return { "snippets", "lsp", "path", "buffer" }
                    end

                    local t = node:type()
                    if vim.tbl_contains({ "comment", "line_comment", "block_comment" }, t) then
                        return { "buffer" }
                    else
                        return { "snippets", "lsp", "path", "buffer" }
                    end
                end,

                providers = {
                    snippets = {
                        score_offset = 5,
                    },
                    -- lazydev = {
                    --     name = "LazyDev",
                    --     module = "lazydev.integrations.blink",
                    --     score_offset = 4,
                    -- },
                    lsp = {
                        score_offset = 3,
                    },
                    path = {
                        score_offset = 2,
                    },
                    buffer = {
                        score_offset = 1,
                    },
                    laravel = {
                        name = "laravel",
                        module = "blink.compat.source",
                        score_offset = 95,
                    },
                },
            },
        },
    },

    ---@module 'lazy'
    ---@type LazySpec
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
