return {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
        {
            "<C-n>",
            "<cmd>NvimTreeToggle<CR>",
            mode = "n",
            desc = "Nvimtree toggle window",
        },
        {
            "<leader>e",
            "<cmd>NvimTreeFocus<CR>",
            mode = "n",
            desc = "Nvimtree focus window",
        },
    },
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
            vim.keymap.set("n", "y", api.fs.copy.node, opts "Copy")
            vim.keymap.set("n", "s", api.node.open.vertical, opts "Open in vertical split")
            vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
            -- vim.keymap.set("n", "<Tab>", api.node.open.preview, opts "Open Preview")
            vim.keymap.set("n", "d", api.fs.trash, opts "Trash")
            vim.keymap.set("n", "D", api.fs.remove, opts "Remove")

            vim.keymap.set("n", ".", function()
                local core = require "nvim-tree.core"

                local explorer = core.get_explorer()

                if not explorer then
                    return
                end

                local path = explorer["get_node_at_cursor"](explorer).absolute_path

                require("config.floaterminal").put_command(path, "start")
            end, opts "Run Command on file")
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
    end,
}
