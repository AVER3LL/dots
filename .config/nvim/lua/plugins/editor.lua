return {
    -- Better comments somehow
    {
        "numToStr/Comment.nvim",
        -- enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            local comment = require "Comment"
            local ts_context_commentstring = require "ts_context_commentstring.integrations.comment_nvim"
            ---@diagnostic disable-next-line: missing-fields
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
        ft = { "html", "js", "javascriptreact", "typescript", "typescriptreact", "blade" },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
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
        enabled = false,
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = { java = false },
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
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
        end,
        opts = {
            -- classic, modern, helix
            preset = "classic",
        },
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
    },

    {
        "echasnovski/mini.nvim",
        config = function()
            require("configs.mini-ai").setup()
            require("mini.surround").setup()
            require("mini.trailspace").setup()
            require("mini.pairs").setup()
            -- if not vim.g.neovide then
            --     require("mini.animate").setup {}
            -- end
        end,
    },

    {
        -- "LunarVim/bigfile.nvim",
        "pteroctopus/faster.nvim",
    },
}
