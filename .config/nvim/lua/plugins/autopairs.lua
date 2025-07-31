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

            local npairs = require "nvim-autopairs"
            local Rule = require "nvim-autopairs.rule"

            -- Add auto-closing rule for Blade comments {{-- --}}
            npairs.add_rule(Rule("{{--", "  --", "blade"))
        end,
    },
}
