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
                    ---@param rhs function|string
                    ---@param desc string
                    local function nmap(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = bufnr })
                    end
                    nmap("<leader>gb", ":Gitsigns blame_line<CR>", "Git blame the current line")
                    nmap("<leader>gd", ":Gitsigns preview_hunk <CR>", "Git diff the current hunk")
                    nmap(
                        "<leader>gg",
                        ":lua require('gitsigns').diffthis(nil, { vertical = true }) <CR>",
                        "Git diff the current file"
                    )

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
                    border = tools.border,
                },
                culhl = true,
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 500,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                    use_focus = true,
                },
                diff_opts = {
                    vertical = false,
                },
                -- signs = {
                --     add = { text = "+" },
                --     change = { text = "~" },
                --     delete = { text = "_" },
                --     topdelete = { text = "‾" },
                --     changedelete = { text = "~" },
                --     untracked = { text = "┆" },
                -- },
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
