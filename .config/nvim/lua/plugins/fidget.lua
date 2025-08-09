return {

    -- Lsp percentages and shit
    {
        "j-hui/fidget.nvim",
        enabled = true,
        event = "LspAttach",
        opts = {
            progress = {
                display = {
                    -- Cleans the ui
                    done_ttl = 2,
                    done_icon = require("icons").misc.ok,
                    -- done_style = "NonText",
                    -- group_style = "NonText",
                    -- icon_style = "Title",
                    -- progress_style = "NonText",
                    progress_icon = {
                        pattern = {
                            " 󰫃 ",
                            " 󰫄 ",
                            " 󰫅 ",
                            " 󰫆 ",
                            " 󰫇 ",
                            " 󰫈 ",
                        },
                    },
                },
            },
        },
    },
}
