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
                "<leader>lu",
                require("config.laravel.gf").generate_all_caches,
                { desc = "Generate gf cache", silent = true }
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

            vim.keymap.set("n", "gf", require("config.laravel").gf, { desc = "Pick Laravel Views", silent = true })

            vim.keymap.set("n", "<leader>li", require("config.laravel").find_related, {
                desc = "Pick related files",
                silent = true,
            })

            vim.keymap.set("n", "<leader>lo", require("config.laravel").run_ide_helper, {
                desc = "Run ide helper",
                silent = true,
            })

            vim.keymap.set("n", "<leader>lfm", require("config.laravel.pickers").find_migrations, {
                desc = "FInd migrations",
                silent = true,
            })

            vim.keymap.set("n", "<leader>lff", require("config.laravel.pickers").find_factories, {
                desc = "Find factories",
                silent = true,
            })

            vim.keymap.set("n", "<leader>lfs", require("config.laravel.pickers").find_seeders, {
                desc = "Find seeders",
                silent = true,
            })

            vim.keymap.set("n", "<leader>lfr", require("config.laravel.pickers").find_routes, {
                desc = "Find routes",
                silent = true,
            })

            -- Add autocommand to update gf cache automatically
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = vim.api.nvim_create_augroup("LaravelGfCache", { clear = true }),
                pattern = "*/routes/**/*.php",
                callback = function()
                    if require("config.laravel.utils").is_laravel_project() then
                        vim.defer_fn(function()
                            require("config.laravel.gf").generate_all_caches()
                            vim.notify("Laravel `gf` cache updated.", vim.log.levels.INFO, { title = "Laravel" })
                        end, 50) -- Defer to not slow down saving
                    end
                end,
                desc = "Update Laravel gf cache on route file changes",
            })
        end,
    },
}
