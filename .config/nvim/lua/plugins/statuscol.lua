return {

    -- Hide fold level numbers
    {
        "luukvbaal/statuscol.nvim",
        enabled = true,
        opts = function()
            local builtin = require "statuscol.builtin"

            return {
                setopt = true,
                ft_ignore = {
                    "dapui_stacks",
                    "dapui_breakpoints",
                    "dapui_scopes",
                    "dapui_watches",
                    "dapui_console",
                    "dap-repl",
                    "oil",
                    "Trouble",
                    "TelescopePrompt",
                    "Avante",
                    "AvanteInput",
                    "NvimTree",
                    "alpha",
                    "oil",
                },

                -- override the default list of segments with:
                -- number-less fold indicator, then signs, then line number & separator
                segments = {
                    {
                        text = { " " },
                        condition = {
                            function(args)
                                local is_num = vim.wo[args.win].number
                                local is_relnum = vim.wo[args.win].relativenumber

                                return not is_num and not is_relnum
                            end,
                        },
                    },
                    {
                        sign = {
                            name = { ".*" },
                            text = { ".*" },
                            namespace = { ".*" },
                            auto = false,
                        },
                        click = "v:lua.ScSa",
                    },
                    {
                        text = { builtin.lnumfunc },
                        condition = {
                            function(args)
                                local is_num = vim.wo[args.win].number
                                local is_relnum = vim.wo[args.win].relativenumber

                                return is_num or is_relnum
                            end,
                        },
                        click = "v:lua.ScLa",
                    },
                    -- Space between line numbers and buffer
                    {
                        text = { " │" },
                        hl = "LineNr",
                        condition = {
                            function(args)
                                local is_num = vim.wo[args.win].number
                                local is_relnum = vim.wo[args.win].relativenumber

                                return is_num or is_relnum
                            end,
                        },
                    },
                    {
                        sign = {
                            namespace = { "gitsigns" },
                            auto = false,

                            fillchar = " ",
                            maxwidth = 1,
                            colwidth = 1,
                            fillcharhl = "MiniIndentscopeSymbol",
                        },
                        condition = { true, builtin.not_empty },
                        click = "v:lua.ScSa",
                    },
                },
            }
        end,
    },
}
