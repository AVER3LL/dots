return {
    {
        "folke/noice.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            views = {
                cmdline_popup = {
                    border = { style = tools.border },
                    position = { row = "41%", col = "50%" },
                    size = { height = "auto" },
                },
                popupmenu = {
                    border = { style = tools.border },
                    position = { row = "78%", col = "50%" },
                    size = { width = 60, height = 10 },
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
                progress = { enabled = false },
                hover = { enabled = false },
                message = { enabled = false },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = false,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = false,
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
    },
}
