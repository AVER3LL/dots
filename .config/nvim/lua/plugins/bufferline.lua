return {
    "akinsho/bufferline.nvim",
    event = { "TabEnter" },
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        options = {
            mode = "tabs",
            always_show_bufferline = false,
            indicator = { style = "none" },
            seperator_style = "thick",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "",
                    text_align = "left",
                    separator = false,
                    highlight = "NvimTreeNormal",
                },
            },
            color_icons = false,
            show_buffer_icons = false,
        },
    },
}
