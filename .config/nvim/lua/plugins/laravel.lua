return {
    {
        "ricardoramirezr/blade-nav.nvim",
        enabled = false,
        dependencies = {
            "saghen/blink.cmp",
        },
        ft = { "blade", "php" },
        opts = {
            close_tag_on_complete = false,
        },
    },

    {
        "adalessa/laravel.nvim",
        dependencies = {
            "tpope/vim-dotenv",
            -- "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
            "kevinhwang91/promise-async",
        },
        cmd = { "Laravel" },
        keys = {
            { "<leader>la", "<cmd>Laravel artisan<cr>", desc = "Laravel artisan command" },
            { "<leader>lrr", "<cmd>Laravel routes<cr>", desc = "Laravel list routes" },
            { "<leader>lrt", "<cmd>Laravel route_info toggle<cr>", desc = "Laravel toggle route info" },
            {
                "gf",
                function()
                    if require("laravel").app("gf").cursor_on_resource() then
                        return "<cmd>Laravel gf<CR>"
                    else
                        return "gf"
                    end
                end,
                noremap = false,
                expr = true,
            },
        },
        config = function()
            require("laravel").setup {
                lsp_server = "intelephense",
                features = {
                    route_info = {
                        enable = false,
                        view = "top",
                    },
                    pickers = {
                        enable = true,
                        provider = "snacks",
                    },
                },
            }

            -- Function to find and list Laravel controllers
            vim.keymap.set(
                "n",
                "<leader>lc",
                require("config.laravel.pickers").find_controllers,
                { desc = "Pick Laravel Controller", silent = true }
            )

            vim.keymap.set(
                "n",
                "<leader>lm",
                require("config.laravel.pickers").find_models,
                { desc = "Pick Laravel Models", silent = true }
            )

            vim.keymap.set(
                "n",
                "<leader>lv",
                require("config.laravel.pickers").find_views,
                { desc = "Pick Laravel Views", silent = true }
            )

            vim.keymap.set(
                "n",
                "<leader>ll",
                require("config.laravel.pickers").find_all,
                { desc = "Pick Laravel Views", silent = true }
            )

            vim.keymap.set(
                "n",
                "gf",
                require("config.laravel").gf,
                { desc = "Pick Laravel Views", silent = true }
            )
        end,
    },

    --[[ {
        "adibhanna/laravel.nvim",
        enabled = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
        },
        ft = { "blade", "php" },
        config = function()
            require("laravel").setup {
                notifications = false,
                debug = false,
                keymaps = false,
            }

            tools.map("n", "<leader>la", ":LaravelMake<CR>", { desc = "Laravel Make" })
            tools.map("n", "<leader>lA", ":Artisan ", { desc = "Artisan" })
            tools.map("n", "<leader>lc", ":LaravelController<CR>", { desc = "Laravel Controllers" })
            tools.map("n", "<leader>lr", ":LaravelRoute<CR>", { desc = "Laravel Routes" })
            tools.map("n", "<leader>lm", ":LaravelModel<CR>", { desc = "Laravel Models" })
            tools.map("n", "gf", ":LaravelGoto<CR>", { desc = "Laravel Goto" })
        end,
    }, ]]
}
