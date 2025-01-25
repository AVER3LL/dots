local bt = require("config.looks").border_type()
return {

    {
        "folke/noice.nvim",
        -- enabled = false,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        opts = {
            views = {
                cmdline_popup = {
                    border = { style = bt, padding = { 0, 2 } },
                    position = { row = "41%", col = "50%" },
                    size = { height = "auto" },
                },
                popupmenu = {
                    relative = "editor",
                    position = { row = "72%", col = "50%" },
                    size = { width = 60, height = 10 },
                    border = { style = bt, padding = { 0, 2 } },
                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "DiagnosticInfo",
                        },
                    },
                },
            },
            lsp = {
                signature = { enabled = false },
                progress = { enabled = true },
                hover = { enabled = false },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                    ["vim.lsp.util.stylize_markdown"] = false,
                    ["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
                },
            },
            presets = {
                bottom_search = true,
                long_message_to_split = true,
            },
            routes = {
                {
                    view = "notify",
                    filter = {
                        event = "msg_showmode",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd [[messages clear]]
            end
            require("noice").setup(opts)
            require("core.mappings").noice()
        end,
    },

    {
        "rcarriga/nvim-notify",
        lazy = true,
        opts = {
            stages = "static", -- Disables the animations
            timeout = 1500,
            render = "wrapped-compact",
        },
        config = function(_, opts)
            local notify = require "notify"
            notify.setup(opts)
            vim.notify = notify
        end,
    },
}
