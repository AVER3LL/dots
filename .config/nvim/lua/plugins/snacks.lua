local bt = require("config.looks").border_type()
local search = require("icons").misc.search
return {

    {
        "folke/snacks.nvim",
        priority = 1002,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            explorer = { enabled = false },
            image = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                prompt = search,
                layout = "custom_layout",
                formatters = {
                    file = {
                        truncate = 70,
                    },
                },
                sources = {
                    files = {
                        hidden = true,
                        ignored = true,
                    },
                },
                layouts = {
                    vscode = {
                        preview = false,
                        layout = {
                            backdrop = false,
                            row = 5,
                            width = 0.4,
                            min_width = 80,
                            height = 0.4,
                            border = "none",
                            box = "vertical",
                            {
                                win = "input",
                                height = 1,
                                border = "rounded",
                                title = "{title} {live} {flags}",
                                title_pos = "center",
                            },
                            { win = "list", border = "hpad" },
                            { win = "preview", title = "{preview}", border = "rounded" },
                        },
                    },
                    custom_layout = {
                        layout = {
                            box = "horizontal",
                            backdrop = false,
                            width = 0.87,
                            height = 0.8,
                            border = "none",
                            {
                                box = "vertical",
                                {
                                    win = "input",
                                    height = 1,
                                    border = bt,
                                    title = "{title} {live} {flags}",
                                    title_pos = "center",
                                },
                                { win = "list", title = " Results ", title_pos = "center", border = bt },
                            },
                            {
                                win = "preview",
                                title = "{preview:Preview}",
                                width = 0.55,
                                border = bt,
                                title_pos = "center",
                            },
                        },
                    },
                    dropdown = {
                        layout = {
                            backdrop = false,
                            row = 3,
                            width = 0.4,
                            min_width = 80,
                            height = 0.7,
                            border = "none",
                            box = "vertical",
                            -- { win = "preview", title = "{preview}", height = 0.4, border = bt },
                            {
                                box = "vertical",
                                border = bt,
                                title = "{title} {live} {flags}",
                                title_pos = "center",
                                { win = "list", border = "bottom" },
                                { win = "input", height = 1, border = "none" },
                            },
                        },
                    },
                },
            },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            dashboard = {
                enabled = false,
                sections = {
                    { section = "header" },
                    -- {
                    --     pane = 2,
                    --     section = "terminal",
                    --     cmd = "colorscript -e square",
                    --     height = 5,
                    --     padding = 1,
                    -- },
                    { section = "keys", gap = 1, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1,
                    },
                    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = "startup" },
                },
            },
            indent = { enabled = false, only_current = true },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = false,
                left = { "mark", "sign" }, -- priority of signs on the left (high to low)
                right = { "git", "fold" }, -- priority of signs on the right (high to low)
                folds = {
                    open = true,
                },
            },
            words = { enabled = false },
            terminal = {
                enabled = false,
                win = {
                    style = "terminal",
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                },
            },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find files",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files { cwd = vim.fn.stdpath "config" }
                end,
                desc = "Find config files",
            },
            {
                "<leader>fg",
                function()
                    Snacks.picker.git_files()
                end,
                desc = "Find git files",
            },
            {
                "<leader>fo",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Find recent files",
            },
            {
                "<leader>fw",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Find word",
            },
            {
                "<leader>z",
                function()
                    Snacks.picker.lines()
                end,
                desc = "Find word",
            },
            {
                "<leader>fb",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Find buffers",
            },
            {
                "<leader>fk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Find keymaps",
            },
            {
                "<leader>th",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Find colorschemes",
            },
            {
                "<leader>o",
                function()
                    Snacks.picker.spelling()
                end,
                desc = "Spelling suggestions",
            },
            {
                "<leader>fp",
                function()
                    Snacks.picker.projects { dev = { "~/Projects" } }
                end,
            },
            {
                "<leader>fv",
                function()
                    Snacks.picker.cliphist()
                end,
                desc = "Search in clipboard",
            },
            {
                "<leader>fhh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Search the help manual",
            },
            {
                "<leader>fhl",
                function ()
                    Snacks.picker.highlights()
                end,
                desc = "Search the highlight groups",
            }
        },
    },
}
