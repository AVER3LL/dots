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
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
        },
        cmd = { "Laravel" },
        keys = {
            {
                "<leader>lp",
                function()
                    Laravel.pickers.laravel()
                end,
                desc = "Laravel: Open Laravel Picker",
            },
            {
                "<leader>la",
                function()
                    Laravel.pickers.artisan()
                end,
                desc = "Laravel: Open Artisan Picker",
            },
            {
                "<leader>lrr",
                function()
                    Laravel.pickers.routes()
                end,
                desc = "Laravel: Open Routes Picker",
            },
        },
        event = { "VeryLazy" },
        opts = {
            lsp_server = "intelephense",
            features = {
                pickers = {
                    provider = "snacks",
                },
            },
        },
        config = function(_, opts)
            require("laravel").setup(opts)

            if not require("config.laravel.utils").is_laravel_project() then
                return
            end

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
