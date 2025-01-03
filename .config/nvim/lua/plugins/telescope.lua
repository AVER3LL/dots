return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = { "Telescope" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require "telescope"
            local actions = require "telescope.actions"

            local ok, border = pcall(require, "config.looks")
            local current_borders = ok and border.current_border_telescope() or {}

            telescope.setup {
                defaults = {
                    path_display = { "truncate" },
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
                        },
                    },
                    borderchars = current_borders,
                    color_devicons = true,
                    set_env = { ["COLORTERM"] = "truecolor" },
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- Enable fuzzy searching
                        override_generic_sorter = true, -- Use FZF for generic sorters
                        override_file_sorter = true, -- Use FZF for file sorters
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                        ignore_builtins = true,
                    },
                    find_files = {
                        file_ignore_patterns = { "node_modules", ".git", ".venv", ".mypy_cache", "__pycache__" },
                        hidden = true,
                    },
                    live_grep = {
                        file_ignore_patterns = { "node_modules", ".git", ".venv", ".mypy_cache", "__pycache__" },
                        additional_args = function(_)
                            return { "--hidden" }
                        end,
                    },
                },
            }

            -- telescope.load_extension "flutter"
            telescope.load_extension "fzf"
        end,
    },

    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup {}
        end,
    },
}
