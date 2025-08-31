---@module 'lazy'
---@type LazySpec
return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        -- Disable the plugin in unfocusable windows (hover)
        ignore = function(buf)
            -- Find the window(s) showing this buffer
            for _, win in ipairs(vim.fn.win_findbuf(buf)) do
                local cfg = vim.api.nvim_win_get_config(win)
                if cfg.focusable then
                    return false
                end
            end

            return true
        end,
        win_options = {
            conceallevel = {
                default = vim.o.conceallevel,
                rendered = 3,
            },
            concealcursor = {
                default = vim.o.concealcursor,
                rendered = "nvic",
            },
        },
        heading = {
            sign = false,
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        },
        code = {
            sign = false,
            style = "normal",
            language_name = false,
            conceal_delimiters = true,
            width = "block",
            right_pad = 1,
            highlight = "NormalFloat",
        },
        bullet = {
            enabled = true,
        },
        checkbox = {
            enabled = true,
            right_pad = 0,
            -- position = "inline",
            unchecked = {
                icon = "   󰄱  ",
                -- Highlight for the unchecked icon
                highlight = "RenderMarkdownUnchecked",
                -- Highlight for item associated with unchecked checkbox
                scope_highlight = nil,
            },
            checked = {
                -- Replaces '[x]' of 'task_list_marker_checked'
                icon = "   󰱒  ",
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
