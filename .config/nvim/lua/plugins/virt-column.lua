local bar = require("icons").misc.vertical_bar

return {

    -- Vertical line
    {
        "lukas-reineke/virt-column.nvim",
        -- enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            char = { bar },
            highlight = { "NonText" },
        },
    },
}
