return {

    -- Automatically closes brackets
    {
        "windwp/nvim-autopairs",
        enabled = true,
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
}
