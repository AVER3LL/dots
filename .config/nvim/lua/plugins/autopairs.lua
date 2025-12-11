-- Automatically closes brackets

return {
    {
        "windwp/nvim-autopairs",
        enabled = false,
        event = "BufEnter",
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

    {
        "saghen/blink.pairs",
        version = "*", -- (recommended) only required with prebuilt binaries

        -- download prebuilt binaries from github releases
        dependencies = "saghen/blink.download",
        -- OR build from source, requires nightly:
        -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        --- @module 'blink.pairs'
        --- @type blink.pairs.Config
        opts = {
            mappings = {
                -- you can call require("blink.pairs.mappings").enable()
                -- and require("blink.pairs.mappings").disable()
                -- to enable/disable mappings at runtime
                enabled = true,
                -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
                -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
                disabled_filetypes = {},
                -- see the defaults:
                -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
                pairs = {},
            },
            debug = false,
        },
    },
}
