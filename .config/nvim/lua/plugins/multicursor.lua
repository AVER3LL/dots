return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require "multicursor-nvim"
        mc.setup()

        local set = vim.keymap.set

        -- stylua: ignore start

        set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
        set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
        set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
        set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)

        -- Add or skip adding a new cursor by matching word/selection
        set({ "n", "x" }, "<A-j>", function() mc.matchAddCursor(1) end)
        set({ "n", "x" }, "<A-i>", function() mc.matchSkipCursor(1) end)

        set({ "n", "x" }, "<A-k>", function() mc.matchAddCursor(-1) end)
        set({ "n", "x" }, "<A-o>", function() mc.matchSkipCursor(-1) end)
        -- stylua: ignore end

        mc.addKeymapLayer(function(layerSet)
            -- Select a different cursor as the main one.
            layerSet({ "n", "x" }, "<left>", mc.prevCursor)
            layerSet({ "n", "x" }, "<right>", mc.nextCursor)

            -- Delete the main cursor.
            layerSet({ "n", "x" }, "<leader>q", mc.deleteCursor)

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)
    end,
}
