local tree_installed, tree = pcall(require, "neo-tree")

if not tree_installed then
    return
end

local function setup_tree()
    tree.setup {
        close_if_last_window = true,
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_by_name = {
                    ".git",
                },
                hide_gitignored = false,
                always_show = {
                    ".env",
                },
            },
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
        window = {
            position = "left",
            width = 30,
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["<space>"] = "none",
                ["Y"] = {
                    function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                    desc = "Copy Path to Clipboard",
                },
                ["O"] = {
                    function(state)
                        require("lazy.util").open(state.tree:get_node().path, { system = true })
                    end,
                    desc = "Open with System Application",
                },
                ["P"] = { "toggle_preview", config = { use_float = false } },
            },
        },
    }
end

return setup_tree()
