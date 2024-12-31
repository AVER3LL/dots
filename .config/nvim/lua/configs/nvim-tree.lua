local tree_installed, tree = pcall(require, "nvim-tree")

if not tree_installed then
    return
end

local function setup_tree()
    tree.setup {
        filters = {
            dotfiles = false,
            git_clean = false,
            no_buffer = false,
            custom = { "node_modules", "\\.cache", ".mypy_cache", "__pycache__" },
            exclude = {},
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        sort_by = "name",
        hijack_unnamed_buffer_when_opening = true,
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = false,
        },
        -- view = {
        --     adaptive_size = false,
        --     width = 30,
        --     -- side = "left",
        --     preserve_window_proportions = true,
        -- },
        --
        -- git = {
        --     enable = true,
        --     ignore = false,
        --     show_on_dirs = true,
        --     show_on_open_dirs = true,
        --     timeout = 200,
        -- },
        -- filesystem_watchers = {
        --     enable = true,
        -- },
        -- actions = {
        --     open_file = {
        --         resize_window = true,
        --     },
        -- },
        diagnostics = {
            enable = true,
            show_on_dirs = false,
            show_on_open_dirs = true,
            icons = {
                hint = "⚑",
                info = "",
                warning = "▲",
                error = "✘",
            },
        },
        modified = {
            enable = true,
            show_on_dirs = false,
            show_on_open_dirs = true,
        },
        renderer = {
            root_folder_label = false,
            highlight_git = true,
            icons = {
                modified_placement = "after",
                diagnostics_placement = "after",
                glyphs = {
                    modified = "[+]",
                },
            },
        },
        -- renderer = {
        --     root_folder_label = false,
        --     highlight_git = true,
        --
        --     indent_markers = { enable = true },
        --
        --     icons = {
        --         modified_placement = "after",
        --         diagnostics_placement = "after",
        --
        --         glyphs = {
        --             default = "󰈚",
        --             symlink = "",
        --             modified = "[+]",
        --             folder = {
        --                 default = "",
        --                 empty = "",
        --                 empty_open = "",
        --                 open = "",
        --                 symlink = "",
        --                 symlink_open = "",
        --                 arrow_open = "",
        --                 arrow_closed = "",
        --             },
        --
        --             git = {
        --                 -- unstaged = "✗",
        --                 -- staged = "✓",
        --                 unmerged = "",
        --                 -- renamed = "➜",
        --                 -- untracked = "★",
        --                 -- deleted = "",
        --                 -- ignored = "◌",
        --             },
        --         },
        --     },
        -- },
    }
end

return setup_tree()
