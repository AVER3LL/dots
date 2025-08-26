return {

    -- Automatically closes brackets
    {
        "windwp/nvim-autopairs",
        enabled = true,
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = { java = false, lua = { "string" } },
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            local npairs = require "nvim-autopairs"
            local Rule = require "nvim-autopairs.rule"

            -- Add auto-closing rule for Blade comments {{-- --}}
            npairs.add_rule(Rule("{{--", "  --", "blade"):set_end_pair_length(5):replace_endpair(function()
                -- schedule the cursor movement to happen *after* insertion
                vim.schedule(function()
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<Right><Right>", true, false, true),
                        "n",
                        false
                    )
                end)
                return "  --"
            end))
        end,
    },
}
