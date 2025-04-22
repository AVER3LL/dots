local delete = require("icons").misc.delete
local bar = require("icons").misc.thick_bar
local border = require("config.looks").border_type()

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup {
                on_attach = function(bufnr)
                    local gitlinker = require "gitlinker"
                    local gs = package.loaded.gitsigns

                    -- Mappings.
                    ---@param lhs string
                    ---@param rhs function
                    ---@param desc string
                    local function nmap(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
                    end

                    nmap("<leader>go", function()
                        gitlinker.get_buf_range_url(
                            "n",
                            { action_callback = require("gitlinker.actions").open_in_browser }
                        )
                    end, "Open git file in browser")
                    nmap("[g", gs.prev_hunk, "Previous hunk")
                    nmap("]g", gs.next_hunk, "Next hunk")
                end,
                preview_config = {
                    border = border,
                },
                diff_opts = {
                    vertival = false,
                },
                signs = {
                    add = { text = bar },
                    change = { text = bar },
                    delete = { text = delete },
                    topdelete = { text = delete },
                    changedelete = { text = bar },
                    untracked = { text = bar },
                },
                signs_staged = {
                    add = { text = bar },
                    change = { text = bar },
                    delete = { text = delete },
                    topdelete = { text = delete },
                    changedelete = { text = bar },
                },
            }
        end,
    },

    {
        "ruifm/gitlinker.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = true,
        opts = {
            -- Keymap to copy the link of the file
            mappings = "<leader>gy",
        },
    },
}
