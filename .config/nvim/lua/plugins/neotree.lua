---@diagnostic disable: undefined-field
return {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
        {
            "<C-n>",
            "<cmd>Neotree toggle<cr>",
            desc = "Neotree toggle",
        },
        {
            "<leader>e",
            "<cmd>Neotree reveal<cr>",
        },
    },
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
        { "nvim-tree/nvim-web-devicons", lazy = true },
        { "MunifTanjim/nui.nvim", lazy = true },
    },
    config = function()
        local function on_move(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
        end

        local events = require "neo-tree.events"

        require("neo-tree").setup {
            ---@diagnostic disable-next-line: assign-type-mismatch
            popup_border_style = tools.border,
            enable_modified_markers = true,
            event_handlers = {
                { event = events.FILE_MOVED, handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    with_markers = false,
                    indent_size = 3,
                    padding = 1,
                    expander_collapsed = "",
                    expander_expanded = "",
                },
                diagnostics = {
                    enabled = false,
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
                position = "right",
                width = 35,
                mappings = {
                    ["l"] = "open",
                    ["e"] = "rename_basename",
                    ["."] = function(state)
                        local node = state.tree:get_node()
                        local filepath = node:get_id()

                        require("config.floaterminal").put_command(filepath, "start")
                    end,
                    ["gy"] = function(state)
                        local node = state.tree:get_node()
                        local filepath = node:get_id()

                        local filename = node.name

                        -- Use system clipboard with proper file URI
                        local uri = "file://" .. vim.fn.fnamemodify(filepath, ":p")
                        local cmd = string.format('echo "%s" | wl-copy --type text/uri-list', uri)
                        os.execute(cmd)

                        vim.notify(filename .. " copied to system clipboard", vim.log.levels.INFO)
                    end,
                },
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
