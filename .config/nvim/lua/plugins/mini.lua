return {

    {
        "nvim-mini/mini.surround",
        opts = {},
    },

    {
        "nvim-mini/mini.extra",
        version = false,
        opts = {},
    },

    {
        "nvim-mini/mini.pick",
        enabled = false,
        version = false,
        config = function()
            local win_config = function()
                -- local height = math.floor(0.618 * vim.o.lines)
                local width = math.floor(0.8 * vim.o.columns)
                local height = 10
                -- local width = 90

                return {
                    anchor = "SW",
                    height = height,
                    border = tools.border,
                    width = width,
                    -- row = math.floor(0.5 * (vim.o.lines - height)),
                    col = math.floor(0.5 * (vim.o.columns - width)),
                }
            end

            require("mini.pick").setup {
                mappings = {
                    move_down = "<C-j>",
                    move_start = "<C-g>",
                    move_up = "<C-k>",

                    scroll_down = "<C-d>",
                    scroll_left = "<C-h>",
                    scroll_right = "<C-l>",
                    scroll_up = "<C-u>",

                    delete_left = "",
                },

                window = {
                    -- Float window config (table or callable returning it)
                    -- config = { border = tools.border },
                    config = win_config,

                    -- String to use as caret in prompt
                    prompt_caret = "▏",

                    -- String to use as prefix in prompt
                    prompt_prefix = require("icons").misc.search,
                },
            }

            vim.keymap.set("n", "<leader>ff", function()
                MiniPick.builtin.files()
            end, { desc = "Find files" })
        end,
    },

    {
        "nvim-mini/mini.trailspace",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            only_in_normal_buffers = true,
        },
    },

    {
        "nvim-mini/mini.misc",
        enabled = false,
        version = "*",
        config = function()
            require("mini.misc").setup()
            require("mini.misc").setup_termbg_sync()
            -- require("mini.misc").setup_restore_cursor { center = false }
        end,
    },

    {
        "nvim-mini/mini.ai",
        event = "BufReadPre",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
        },
        opts = function()
            local miniai = require "mini.ai"
            return {
                n_lines = 300,
                custom_textobjects = {
                    f = miniai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    d = { "%f[%d]%d+" }, -- digits
                    i = miniai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }, {}),
                    l = miniai.gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }, {}),
                    g = function()
                        local from = { line = 1, col = 1 }
                        local to = {
                            line = vim.fn.line "$",
                            col = math.max(vim.fn.getline("$"):len(), 1),
                        }
                        return { from = from, to = to }
                    end,
                },
                -- Disable error feedback.
                silent = true,
                -- Don't use the previous or next text object.
                search_method = "cover",
                mappings = {
                    around = "a",
                    inside = "i",
                    around_next = "an",
                    inside_next = "in",
                    around_last = "al",
                    inside_last = "il",
                    goto_left = "[",
                    goto_right = "]",
                },
            }
        end,
    },
}
