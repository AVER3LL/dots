return {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    build = "make install_jsregexp",

    opts = function()
        local types = require "luasnip.util.types"
        return {
            -- Check if the current snippet was deleted.
            history = true,
            delete_check_events = "TextChanged",
            updateevents = "TextChanged,TextChangedI",
            -- Display a cursor-like placeholder in unvisited nodes
            -- of the snippet.
            ext_opts = {
                [types.insertNode] = {
                    unvisited = {
                        virt_text = { { "|", "Conceal" } },
                        virt_text_pos = "inline",
                    },
                },
                [types.exitNode] = {
                    unvisited = {
                        virt_text = { { "|", "Conceal" } },
                        virt_text_pos = "inline",
                    },
                },
                [types.choiceNode] = {
                    active = {
                        virt_text = { { "(snippet) choice node", "LspInlayHint" } },
                    },
                },
            },
        }
    end,

    config = function(_, opts)
        local luasnip = require "luasnip"

        ---@diagnostic disable: undefined-field
        luasnip.setup(opts)

        -- Load my custom snippets:
        require("luasnip.loaders.from_vscode").lazy_load {
            paths = vim.fn.stdpath "config" .. "/snippets",
        }
    end,
}
