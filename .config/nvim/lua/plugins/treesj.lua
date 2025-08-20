return {
    -- Splits line into multiple ones

    {
        "echasnovski/mini.splitjoin",
        enabled = true,
        opts = {
            mappings = { toggle = "" },
        },
        keys = {
            {
                "<leader>m",
                function()
                    require("mini.splitjoin").toggle()
                end,
                desc = "Join/split code block",
            },
        },
    },
}
