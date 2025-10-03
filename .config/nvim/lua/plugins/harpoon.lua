return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local harpoon = require "harpoon"

        harpoon:setup()

        harpoon:extend {
            UI_CREATE = function(cx)
                vim.keymap.set("n", "s", function()
                    harpoon.ui:select_menu_item { vsplit = true }
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "v", function()
                    harpoon.ui:select_menu_item { split = true }
                end, { buffer = cx.bufnr })

                vim.keymap.set("n", "t", function()
                    harpoon.ui:select_menu_item { tabedit = true }
                end, { buffer = cx.bufnr })
            end,
        }

        local harpoon_extensions = require "harpoon.extensions"
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end)
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        vim.keymap.set("n", "&", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "é", function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", '"', function()
            harpoon:list():select(3)
        end)
        vim.keymap.set("n", "'", function()
            harpoon:list():select(4)
        end)
    end,
}
