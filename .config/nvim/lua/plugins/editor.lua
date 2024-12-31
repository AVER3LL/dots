return {
    -- Better comments somehow
    {
        "numToStr/Comment.nvim",
        -- enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        ft = { "javascript", "typescript" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            local comment = require "Comment"
            local ts_context_commentstring = require "ts_context_commentstring.integrations.comment_nvim"
            comment.setup {
                pre_hook = ts_context_commentstring.create_pre_hook(),
            }
        end,
    },

    -- Colored comments because monke brain
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = false,
        },
    },

    -- Hides the buffer that are not in the current tab (For bufferline)
    {
        "tiagovla/scope.nvim",
        enabled = false,
        event = { "TabEnter", "TabNewEntered", "TabLeave", "TabNew" },
        config = function()
            require("scope").setup {}
        end,
    },

    -- Automatically closes html tags
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "js", "javascriptreact", "typescript", "tsx", "blade" },
        config = function()
            require("nvim-ts-autotag").setup {
                opts = {
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = true, -- Auto close on trailing </
                },
                per_filetype = {
                    -- ["html"] = {
                    --   enable_close = false,
                    -- },
                },
            }
        end,
    },

    -- Automatically closes brackets
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = { java = false },
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0,
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "PmenuSel",
                highlight_grey = "LineNr",
            },
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            if not vim.g.use_blink then
                local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                local is_cmp_loaded, cmp = pcall(require, "cmp")
                if is_cmp_loaded then
                    ---@diagnostic disable-next-line: undefined-field
                    cmp.event:on(
                        "confirm_done",
                        cmp_autopairs.on_confirm_done {
                            tex = false,
                        }
                    )
                end
            end
        end,
    },

    -- Renaming accross files. Might switch to inc-rename
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        config = function()
            require("spectre").setup()
        end,
    },

    {
        "smjonas/inc-rename.nvim",
        enabled = false,
        cmd = "IncRename",
        config = function()
            require("inc_rename").setup()
        end,
    },

    -- Splits line into multiple ones
    {
        "Wansmer/treesj",
        cmd = { "TSJToggle" },
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
        config = function()
            require("treesj").setup {
                use_default_keymaps = false,
            }
        end,
        version = "*",
    },

    -- Helps manage keymaps
    {
        "folke/which-key.nvim",
        -- keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
        -- cmd = "WhichKey",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {},
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            return require "configs.treesitter"
        end,
    },

    {
        "kylechui/nvim-surround",
        enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = true,

        --
        --     Old text                    Command         New text
        -- --------------------------------------------------------------------------------
        --     surr*ound_words             ysiw)           (surround_words)
        --     *make strings               ys$"            "make strings"
        --     [delete ar*ound me!]        ds]             delete around me!
        --     remove <b>HTML t*ags</b>    dst             remove HTML tags
        --     'change quot*es'            cs'"            "change quotes"
        --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        --     delete(functi*on calls)     dsf             function calls
    },

    {
        "NStefan002/visual-surround.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("visual-surround").setup {
                -- your config
            }
        end,
        -- or if you don't want to change defaults
        -- config = true
    },

    {
        "echasnovski/mini.nvim",
        config = function()
            local ai = require "mini.ai"
            ai.setup {
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
                custom_textobjects = {
                    f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
                    a = ai.gen_spec.treesitter { a = "@parameter.outer", i = "@parameter.inner" },
                    i = ai.gen_spec.treesitter { a = "@conditional.outer", i = "@conditional.inner" },
                    -- l = ai.gen_spec.treesitter { a = "@loop.outer", i = "@loop.inner" },
                    c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
                    -- The tag specification might need adjustment
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                    d = { "%f[%d]%d+" }, -- digits
                    e = { -- Word with case
                        {
                            "%u[%l%d]+%f[^%l%d]",
                            "%f[%S][%l%d]+%f[^%l%d]",
                            "%f[%P][%l%d]+%f[^%l%d]",
                            "^[%l%d]+%f[^%l%d]",
                        },
                        "^().*()$",
                    },
                    u = ai.gen_spec.function_call(), -- u for "Usage"
                },
                n_lines = 500,
                silent = true,
            }
            require("mini.surround").setup()
        end,
    },

    {
        -- "LunarVim/bigfile.nvim",
        "pteroctopus/faster.nvim",
    },
}
