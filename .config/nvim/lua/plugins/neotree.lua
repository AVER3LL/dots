return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    branch = "v3.x",
    cmd = "Neotree", -- Load only when `:Neotree` command is used
    keys = {
        {
            "<C-n>",
            "<cmd>Neotree filesystem reveal left<cr>"
        }
    },
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
        { "nvim-tree/nvim-web-devicons", lazy = true },
        { "MunifTanjim/nui.nvim", lazy = true },
    },
    config = function()
        require("neo-tree").setup {
            popup_border_style = "single",
            enable_modified_markers = true,
            default_component_configs = {
                diagnostics = {
                    symbols = {
                        hint = "",
                        info = "",
                        warn = "",
                        error = "",
                    },
                },
                modified = {
                    symbol = "󰫢",
                    highlight = "NeoTreeModified",
                },
                icon = {
                    folder_closed = "󰉋",
                    folder_open = "󰝰",
                    folder_empty = "󰉖",
                    folder_empty_open = "󰷏",
                },
                git_status = {
                    symbols = {
                        added = "",
                        deleted = "",
                        modified = "󰏫",
                        renamed = "󰯁",
                        untracked = "",
                        ignored = "󰈉",
                        unstaged = "",
                        staged = "",
                        conflict = "",
                    },
                },
            },
            window = {
                position = "left",
                width = 32,
            },
            hide_root_node = true,
            retain_hidden_root_indent = false,
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                hijack_netrw_behavior = "open_current",
                cwd_target = "current", -- Ensures Neo-tree always opens in the current working directory
                filtered_items = {
                    hide_dotfiles = false,
                    hide_by_name = { ".DS_Store", "__pycache__", ".mypy_cache" },
                    always_show = { ".env" },
                },
            },
        }
    end,
}
