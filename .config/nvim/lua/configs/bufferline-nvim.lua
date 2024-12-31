local bufferline_installed, bufferline = pcall(require, "bufferline")

if not bufferline_installed then
    return
end

local function setup_buffeline()
    bufferline.setup {
        options = {
            themable = true,
            -- separator_style = { "", "" },
            separator_style = "thick",
            indicator = {
                -- icon = "▎",
                icon = "",
                style = "none",
            },
            diagnostics = "nvim_lsp",
            auto_toggle_bufferline = true,
            always_show_bufferline = false,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "",
                    highlight = "NvimTreeNormal",
                    text_align = "right",
                    -- separator = " ",
                    separator = "",
                },
            },
        },
    }
end

return setup_buffeline()
