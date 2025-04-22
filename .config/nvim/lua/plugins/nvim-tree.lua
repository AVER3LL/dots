return {

    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
                vim.keymap.set("n", "s", api.node.open.vertical, opts "Open in vertical split")
                vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
            end
            require("nvim-tree").setup {
                on_attach = my_on_attach,
                filters = { dotfiles = false, git_ignored = false, exclude = { ".env" } },
                disable_netrw = true,
                hijack_cursor = true,
                sync_root_with_cwd = true,
                git = {
                    enable = true,
                    ignore = false,
                    timeout = 500,
                },
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
                view = {
                    width = 32,
                    preserve_window_proportions = true,
                },
                renderer = {
                    root_folder_label = false,
                    highlight_git = true,
                    indent_markers = { enable = false },
                    icons = {
                        glyphs = {
                            default = "󰈚",
                            folder = {
                                default = "",
                                empty = "",
                                empty_open = "",
                                open = "",
                                symlink = "",
                            },
                            git = { unmerged = "" },
                        },
                    },
                },
            }
        end,
    },
}
