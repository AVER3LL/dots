local search = require("icons").misc.search

return {
    "folke/snacks.nvim",
    priority = 1002,
    lazy = false,
    ---@type snacks.Config
    opts = {
        styles = {
            notification = {
                border = tools.border,
                zindex = 100,
                ft = "markdown",
                wo = {
                    winblend = 5,
                    wrap = false,
                    conceallevel = 2,
                    colorcolumn = "",
                },
                bo = { filetype = "snacks_notif" },
            },
        },

        toggle = { notify = false },
        bigfile = { enabled = true },
        explorer = { enabled = false },
        image = { enabled = true },
        notifier = {
            enabled = true,
            margin = { top = 1, right = 1, bottom = 0 },
            style = "compact",
        },
        quickfile = { enabled = true },
        indent = { enabled = false, only_current = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
        input = {
            enabled = true,
            prompt_pos = "title",
            win = {
                border = tools.border,
            },
        },
        picker = {
            enabled = true,
            prompt = search,
            layout = "custom",
            matcher = {
                frecency = true,
                cwd_bonus = true,
            },
            formatters = {
                file = {
                    truncate = 70,
                },
            },
            sources = {
                files = {
                    hidden = true,
                    ignored = true,
                    exclude = { "node_modules", ".git", "__pycache__", ".mypy_cache", "venv", ".venv" },
                },
            },
            layouts = {
                vscode = {
                    preview = false,
                    layout = {
                        backdrop = tools.style == "flat" and { blend = 90 } or false,
                        row = 5,
                        width = 0.4,
                        min_width = 80,
                        height = 0.7,
                        border = tools.border,
                        box = "vertical",
                        {
                            win = "input",
                            height = 1,
                            border = "solid",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                        },
                        { win = "list", border = "none" },
                    },
                },
                custom = {
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
                                border = tools.border,
                                title = "{title} {live} {flags}",
                                title_pos = "center",
                            },
                            { win = "list", title = " Results ", title_pos = "center", border = tools.border },
                        },
                        {
                            win = "preview",
                            title = "{preview:Preview}",
                            width = 0.55,
                            border = tools.border,
                            title_pos = "center",
                        },
                    },
                },
            },
        },
    },
    keys = {
        {
            "<leader>x",
            function()
                Snacks.bufdelete()
            end,
            mode = "n",
            desc = "Close current buffer",
        },
        {
            "<leader>cba",
            function()
                Snacks.bufdelete.other()
            end,
            mode = "n",
            desc = "Close other buffers",
        },
        {
            "<leader>ff",
            function()
                Snacks.picker.files { layout = "vscode" }
            end,
            desc = "Find files",
        },
        {
            "<leader>fd",
            function()
                Snacks.picker.diagnostics { layout = "custom" }
            end,
            desc = "Find diagnostics",
        },
        {
            "<leader>fc",
            function()
                Snacks.picker.files { cwd = vim.fn.stdpath "config", layout = "vscode" }
            end,
            desc = "Find config files",
        },
        {
            "<leader>fg",
            function()
                Snacks.picker.git_files { layout = "vscode" }
            end,
            desc = "Find git files",
        },
        {
            "<leader>fo",
            function()
                Snacks.picker.recent { layout = "custom" }
            end,
            desc = "Find recent files",
        },
        {
            "<leader>fw",
            function()
                Snacks.picker.grep { layout = "custom" }
            end,
            desc = "Find word",
        },
        {
            "<leader>fb",
            function()
                Snacks.picker.buffers { layout = "vscode" }
            end,
            desc = "Find buffers",
        },
        {
            "<leader>fk",
            function()
                Snacks.picker.keymaps { layout = "vscode" }
            end,
            desc = "Find keymaps",
        },
        {
            "<leader>th",
            function()
                Snacks.picker.colorschemes { layout = "custom" }
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
            "<leader>fl",
            function()
                Snacks.picker.lazy { layout = "custom" }
            end,
        },
        {
            "<leader>fhh",
            function()
                Snacks.picker.help { layout = "vscode" }
            end,
            desc = "Search the help manual",
        },
        {
            "<leader>fhl",
            function()
                Snacks.picker.highlights { layout = "custom" }
            end,
            desc = "Search the highlight groups",
        },
        {
            "<leader>rr",
            function()
                Snacks.rename.rename_file()
            end,
            desc = "Rename File",
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                Snacks.toggle.line_number():map "<leader><leader>l"
                Snacks.toggle.option("laststatus", { off = 0, on = 3, name = "Statusline" }):map "<leader><leader>w"
                -- Snacks.toggle.option("background", {
                --     off = "light",
                --     on = "dark",
                --     name = "dark mode",
                -- }):map "<leader>tl"
                Snacks.toggle.option("wrap"):map "<leader>ww"
            end,
        })
    end,
}
