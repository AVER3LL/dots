return {
    -- Automatically closes html tags
    {
        "windwp/nvim-ts-autotag",
        ft = {
            "php",
            "html",
            "blade",
            "vue",
            "xml",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-ts-autotag").setup {
                opts = {
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = true, -- Auto close on trailing </
                },
            }
        end,
    },
}
