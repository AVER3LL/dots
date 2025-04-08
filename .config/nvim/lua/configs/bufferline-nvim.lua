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
            show_close_icon = false,
            show_buffer_close_icons = false,
            always_show_bufferline = false,
            offsets = {
                {
                    filetype = "neo-tree",
                },
                {
                    filetype = "nvim-tree",
                },
            },
        },
    }
end

return setup_buffeline()
