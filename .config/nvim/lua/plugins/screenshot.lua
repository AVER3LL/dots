return {

    {
        "michaelrommel/nvim-silicon",
        enabled = false,
        cmd = "Silicon",
        config = function()
            require("nvim-silicon").setup {
                font = "JetBrainsMono NF=34;Noto Color Emoji=34",
                num_separator = "\u{258f} ",
                no_window_controls = false,
                no_line_number = false,
                to_clipboard = false,
                -- with which number the line numbering shall start
                line_offset = 1,
                language = function()
                    local filetype = vim.bo.filetype
                    if filetype and filetype ~= "" then
                        return filetype
                    else
                        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":e")
                    end
                end,
                window_title = function()
                    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
                end,
            }
        end,
    },

    {
        "mistricky/codesnap.nvim",
        -- enabled = false,
        build = "make build_generator",
        cmd = { "CodeSnapSave" },
        opts = {
            code_font_family = "JetBrainsMono NF",
            watermark_font_family = "Pacifico",
            watermark = "",

            save_path = "~/Pictures",

            mac_window_bar = true,
            has_line_number = false,
            has_breadcrumbs = true,
            -- bg_theme = "bamboo",
            bg_color = "#535c68",

            min_width = 0,
            bg_y_padding = 25,
            bg_x_padding = 50,
        },
    },
}
