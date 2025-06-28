return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        branch = "0.1.x",
        cmd = { "Telescope" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require "telescope"
            local actions = require "telescope.actions"

            local ok, border = pcall(require, "config.looks")
            local current_borders = ok and border.current_border_telescope() or {}

            telescope.setup {
                defaults = {
                    path_display = { "filename_first" },
                    prompt_prefix = "   ",
                    selection_caret = " ",
                    entry_prefix = " ",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                        width = 0.87,
                        height = 0.80,
                    },
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                            ["<C-j>"] = actions.move_selection_next, -- move to next result
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-d>"] = actions.delete_buffer,
                        },
                        n = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                    },
                    borderchars = current_borders,
                    color_devicons = true,
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    set_env = { ["COLORTERM"] = "truecolor" },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {},
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                        ignore_builtins = true,
                    },
                    find_files = {
                        file_ignore_patterns = {
                            "node_modules",
                            "%.git",
                            "%.venv",
                            ".mypy_cache",
                            "__pycache__",
                            "vendor",
                        },
                        hidden = true,
                    },
                    live_grep = {
                        file_ignore_patterns = {
                            "node_modules",
                            "%.git",
                            "%.venv",
                            ".mypy_cache",
                            "__pycache__",
                            "vendor",
                        },
                        additional_args = function(_)
                            return { "--hidden" }
                        end,
                    },
                },
            }

            -- telescope.load_extension "flutter"
            telescope.load_extension "fzf"
            telescope.load_extension "ui-select"
        end,
    },
}
