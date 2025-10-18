return {
    "A7Lavinraj/fyler.nvim",
    enabled = false,
    branch = "stable",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = function()
        local fyler = require "fyler"
        return {
            {
                "<C-n>",
                function()
                    fyler.toggle()
                end,
                mode = "n",
                desc = "Fyler toggle window",
            },
            {
                "<leader>e",
                function()
                    fyler.open()
                end,
                mode = "n",
                desc = "Fyler focus window",
            },
        }
    end,
    opts = {
        icon_provider = "nvim_web_devicons",
        close_on_select = false,
        default_explorer = true,
        hooks = {
            on_rename = function(src_path, dst_path)
                Snacks.rename.on_rename_file(src_path, dst_path)
            end,
            on_move = function(src_path, dst_path)
                Snacks.rename.on_rename_file(src_path, dst_path)
            end,
        },
        popups = {
            permission = {
                border = tools.border,
            },
        },
        git_status = {
            enabled = true,
            symbols = {
                Untracked = "?",
                Added = "+",
                Modified = "*",
                Deleted = "x",
                Renamed = ">",
                Copied = "~",
                Conflict = "!",
                Ignored = "#",
            },
        },
        indentscope = { enabled = false },
        mappings = {
            ["l"] = "Select",
            ["s"] = "SelectVSplit",
            ["."] = function(self)
                local node_entry = self:cursor_node_entry()
                if not node_entry then
                    return
                end

                require("config.floaterminal").put_command(node_entry.path, "start")
            end,
            ["gy"] = function(self)
                local node_entry = self:cursor_node_entry()
                if not node_entry then
                    return
                end

                vim.system { "wl-copy", "--type", "text/uri-list", "file://" .. node_entry.path .. "\n" }

                vim.notify(node_entry.name .. " copied to system clipboard", vim.log.levels.INFO)
            end,
            -- ["q"] = "",
        },
        win = {
            border = tools.border,
            kind = "split_right_most",
            win_opts = {
                number = false,
                relativenumber = false,
            },
            kind_presets = {
                split_right_most = {
                    width = "0.22rel",
                },
            },
        },
    },
}
