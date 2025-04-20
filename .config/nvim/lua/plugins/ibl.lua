return {

    -- indentation marks
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        main = "ibl",
        config = function()
            local ibl = require("ibl")
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

            ibl.setup {
                exclude = {
                    filetypes = {
                        "help",
                        "lazy",
                        "mason",
                        "notify",
                        "oil",
                        "lazy",
                        "NvimTree",
                        "terminal",
                        "lspinfo",
                        "TelescopePrompt",
                        "TelescopeResults",
                        "Trouble",
                        "trouble",
                        "toggleterm",
                        "alpha",
                    },
                    buftypes = {
                        "terminal",
                        "nofile",
                        "prompt",
                    },
                },
                indent = { char = "│" },
                scope = { char = "│", show_start = false, show_end = false },
                -- indent = { char = "┊" },
                -- scope = { char = "┊", show_start = false, show_end = false },
            }
        end,
    },
}
