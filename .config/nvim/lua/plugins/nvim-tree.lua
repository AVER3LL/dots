return {
    {
        "stevearc/oil.nvim",
        enabled = false,
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            watch_for_changes = false,
            delete_to_trash = true,
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["l"] = "actions.select",
            },
        },
        config = function(_, opts)
            require("oil").setup(opts)

            -- Open parent directory in floating window
            vim.keymap.set("n", "<space>-", require("oil").toggle_float)
        end,
    },

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
                    preserve_window_proportions = false,
                    signcolumn = "no",
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

            local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
            vim.api.nvim_create_autocmd("User", {
                pattern = "NvimTreeSetup",
                callback = function()
                    local events = require("nvim-tree.api").events
                    events.subscribe(events.Event.NodeRenamed, function(data)
                        if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                            data = data
                            Snacks.rename.on_rename_file(data.old_name, data.new_name)
                        end
                    end)
                end,
            })
        end,
    },
}
