local barbecue_installed, barbecue = pcall(require, "barbecue")

if not barbecue_installed then
    return
end

local function setup_barbecue()
    barbecue.setup {
        create_autocmd = false,
    }
    vim.keymap.set("n", "<leader>tb", "<cmd>Barbecue toggle<cr>", { desc = "Toggle barbecue" })

    vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        -- "BufModifiedSet",
    }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
            require("barbecue.ui").update()
        end,
    })
end

return setup_barbecue()
