return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.icons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        ignore = function(buf)
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })

            return buftype == "nofile"
        end,
        heading = {
            sign = false,
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        },
        code = {
            sign = false,
            style = "none",
            language_name = false,
            width = "block",
            right_pad = 1,
        },
        bullet = {
            enabled = true,
        },
        checkbox = {
            enabled = true,
            position = "inline",
            unchecked = {
                icon = "   󰄱 ",
                -- Highlight for the unchecked icon
                highlight = "RenderMarkdownUnchecked",
                -- Highlight for item associated with unchecked checkbox
                scope_highlight = nil,
            },
            checked = {
                -- Replaces '[x]' of 'task_list_marker_checked'
                icon = "   󰱒 ",
                -- Highlight for the checked icon
                highlight = "RenderMarkdownChecked",
                -- Highlight for item associated with checked checkbox
                scope_highlight = nil,
            },
        },
        completions = {
            blink = { enabled = true },
            lsp = { enabled = true },
        },
    },
}
