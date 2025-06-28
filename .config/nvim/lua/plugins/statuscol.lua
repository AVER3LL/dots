return {

    -- Hide fold level numbers
    {
        "luukvbaal/statuscol.nvim",
        enabled = true,
        opts = function()
            local builtin = require "statuscol.builtin"

            local function custom_lnumfunc(args)
                -- Get total lines in buffer to determine width needed
                local total_lines = vim.api.nvim_buf_line_count(args.buf)
                local width = string.len(tostring(total_lines))

                -- If this is a wrapped line (virtnum > 0), show dash with proper width
                if args.virtnum > 0 then
                    return string.rep(" ", width - 1) .. "-"
                end

                -- Otherwise, use the normal line number logic
                local lnum = args.lnum
                local relnum = args.relnum
                local number_to_show

                -- Handle different number/relativenumber combinations
                if args.nu and args.rnu then
                    -- Both enabled: show absolute for current line, relative for others
                    if relnum == 0 then
                        number_to_show = lnum
                    else
                        number_to_show = relnum
                    end
                elseif args.rnu then
                    -- Only relative numbers
                    number_to_show = relnum
                elseif args.nu then
                    -- Only absolute numbers
                    number_to_show = lnum
                else
                    -- No numbers enabled
                    return ""
                end

                -- Format with proper width (right-aligned)
                return string.format("%" .. width .. "d", number_to_show)
            end

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
                        text = { custom_lnumfunc },
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
