return {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    dependencies = {},
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
        {
            "<C-n>",
            vim.cmd.NvimTreeToggle,
            mode = "n",
            desc = "Nvimtree toggle window",
        },
        {
            "<leader>e",
            vim.cmd.NvimTreeFocus,
            mode = "n",
            desc = "Nvimtree focus window",
        },
    },
    config = function()
        local TREE_WIDTH = 35

        local function my_on_attach(bufnr)
            local api = require "nvim-tree.api"

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- custom mappings
            vim.keymap.set("n", "a", api.fs.create, opts "Create File Or Directory")
            vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
            vim.keymap.set("n", "y", api.fs.copy.node, opts "Copy")
            vim.keymap.set("n", "s", api.node.open.vertical, opts "Open in vertical split")
            vim.keymap.set("n", "v", api.node.open.horizontal, opts "Open: Horizontal Split")
            vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
            -- vim.keymap.set("n", "<Tab>", api.node.open.preview, opts "Open Preview")
            vim.keymap.set("n", "d", api.fs.trash, opts "Trash")
            vim.keymap.set("n", "D", api.fs.remove, opts "Remove")

            vim.keymap.set("n", ".", function()
                local core = require "nvim-tree.core"
                local node = core.get_explorer():get_node_at_cursor()

                if not node then
                    return
                end

                require("config.floaterminal").put_command(node.absolute_path, "start")
            end, opts "Run Command on file")

            vim.keymap.set("n", "gy", function()
                local core = require "nvim-tree.core"
                local node = core.get_explorer():get_node_at_cursor()

                if not node then
                    return
                end

                vim.system { "wl-copy", "--type", "text/uri-list", "file://" .. node.absolute_path .. "\n" }

                vim.notify(node.name .. " copied to system clipboard", vim.log.levels.INFO)
            end)

            vim.keymap.set("n", "F", api.live_filter.clear, opts "Live Filter: Clear")
            vim.keymap.set("n", "f", api.live_filter.start, opts "Live Filter: Start")
            vim.keymap.set("n", "p", api.fs.paste, opts "Paste")
            vim.keymap.set("n", "q", api.tree.close, opts "Close")
            vim.keymap.set("n", "r", api.fs.rename, opts "Rename")
            vim.keymap.set("n", "x", api.fs.cut, opts "Cut")
            vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts "Open")
            vim.keymap.set("n", "<CR>", api.node.open.edit, opts "Open")
        end
        require("nvim-tree").setup {
            on_attach = my_on_attach,
            filters = {
                dotfiles = false,
                git_ignored = false,
                exclude = { ".env" },
                custom = { "node_modules", "__pycache__", ".mypy_cache" },
            },
            disable_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
            live_filter = {
                prefix = "[FILTER]: ",
                always_show_folders = false,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            view = {
                width = TREE_WIDTH,
                adaptive_size = true,
                preserve_window_proportions = true,
                signcolumn = "no",
                side = "right",
            },
            actions = {
                change_dir = {
                    enable = false,
                    global = false,
                    restrict_above_cwd = true,
                },
            },
            renderer = {
                root_folder_label = false,
                -- root_folder_label = function(path)
                --     --- Truncates the path if possible ans center it
                --     path = path:gsub(os.getenv "HOME", "~", 1)
                --
                --     if #path > TREE_WIDTH then
                --         -- Show only the project folder name
                --         path = vim.fn.fnamemodify(path, ":t")
                --     end
                --
                --     local padding = TREE_WIDTH - #path
                --     local left = math.floor(padding / 2)
                --     local right = padding - left
                --
                --     return string.rep(" ", left) .. path .. string.rep(" ", right)
                -- end,
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
}
