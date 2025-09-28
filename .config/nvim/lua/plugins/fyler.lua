return {
    "A7Lavinraj/fyler.nvim",
    enabled = false,
    branch = "stable",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        icon_provider = "nvim_web_devicons",
        close_on_select = false,
        hooks = {
            on_rename = function(src_path, dst_path)
                Snacks.rename.on_rename_file(src_path, dst_path)
            end,
        },
        indentscope = { enabled = false },
        mappings = {
            ["l"] = "Select",
            -- ["q"] = "",
        },
        win = {
            border = tools.border,
            win_opts = {
                number = false,
                relativenumber = false,
            },
            kind_presets = {
                split_right_most = {
                    width = "0.25rel",
                },
            },
        },
    },
}
