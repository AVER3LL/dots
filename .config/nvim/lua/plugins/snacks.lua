local bt = require("config.looks").border_type()
return {

    {
        "folke/snacks.nvim",
        keys = {
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
            { "<leader>fc", function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end, desc = "Find config files" },
            { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find git files" },
            { "<leader>fo", function() Snacks.picker.recent() end, desc = "Find recent files" },
            { "<leader>fw", function() Snacks.picker.grep() end, desc = "Find word" },
            { "<leader>z", function() Snacks.picker.grep_word() end, desc = "Find word" },
            { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
            { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find keymaps" },
            { "<leader>th", function() Snacks.picker.colorschemes() end, desc = "Find buffers" },
            { "<leader>o", function() Snacks.picker.spelling() end, desc = "Spelling suggestions" },
            { "<leader>fp", function() Snacks.picker.projects { dev = { "~/Projects" } } end },
        },
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                layout = "custom_layout",
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
                                { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
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
                },
            },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            dashboard = { enabled = false },
            indent = { enabled = false, only_current = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
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
    },
}
