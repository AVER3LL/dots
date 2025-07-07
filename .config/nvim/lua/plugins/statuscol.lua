return {

    -- Hide fold level numbers
    {
        "luukvbaal/statuscol.nvim",
        enabled = true,
        opts = function()
            local builtin = require "statuscol.builtin"

            local function hl_str(hl, str)
                return "%#" .. hl .. "#" .. str .. "%*"
            end

            local function swap(start_val, end_val)
                if start_val > end_val then
                    local swap_val = start_val
                    start_val = end_val
                    end_val = swap_val
                end
                return start_val, end_val
            end

            local function custom_lnumfunc(args)
                local highlighted = "Normal"
                local normal_highlight = "LineNr"

                -- Get total lines in buffer to determine width needed
                local total_lines = vim.api.nvim_buf_line_count(args.buf)
                local width = string.len(tostring(total_lines))

                -- Check if we're in visual mode first
                local mode = vim.fn.mode()
                local normed_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")
                local in_visual_mode = normed_mode == "v"

                -- Get visual selection range if in visual mode
                local is_in_selection = false
                if in_visual_mode then
                    local s_row = vim.fn.line "v" -- start of visual selection
                    local e_row = vim.fn.line "." -- end of visual selection (cursor position)
                    local normed_s_row, normed_e_row = swap(s_row, e_row)
                    is_in_selection = args.lnum >= normed_s_row and args.lnum <= normed_e_row
                end

                -- Handle virtual text cases
                if vim.v.virtnum < 0 then
                    -- Virtual text above the line
                    local line = string.rep(" ", width - 1) .. "-"
                    if in_visual_mode and is_in_selection then
                        return hl_str(highlighted, line)
                    else
                        return hl_str(normal_highlight, line)
                    end
                end

                if vim.v.virtnum > 0 then
                    -- Wrapped lines
                    local line = string.rep(" ", width - 1) .. "-"
                    if in_visual_mode and is_in_selection then
                        return hl_str(highlighted, line)
                    else
                        return hl_str(normal_highlight, line)
                    end
                end

                -- Normal line (vim.v.virtnum == 0)
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
                local line = string.format("%" .. width .. "d", number_to_show)

                -- Check for diagnostics on this line
                local diagnostic_hl = nil
                local is_normal_mode = mode == "n"
                if vim.g.show_line_number and is_normal_mode then
                    local diagnostics = vim.diagnostic.get(args.buf, { lnum = lnum - 1 }) -- 0-based indexing
                    if #diagnostics > 0 then
                        -- Get the highest severity diagnostic
                        local highest_severity = vim.diagnostic.severity.HINT
                        for _, diag in ipairs(diagnostics) do
                            if diag.severity < highest_severity then
                                highest_severity = diag.severity
                            end
                        end

                        -- Map severity to highlight group
                        if highest_severity == vim.diagnostic.severity.ERROR then
                            diagnostic_hl = "LspDiagnosticsLineNrError"
                        elseif highest_severity == vim.diagnostic.severity.WARN then
                            diagnostic_hl = "LspDiagnosticsLineNrWarning"
                        elseif highest_severity == vim.diagnostic.severity.INFO then
                            diagnostic_hl = "LspDiagnosticsLineNrInfo"
                        elseif highest_severity == vim.diagnostic.severity.HINT then
                            diagnostic_hl = "LspDiagnosticsLineNrHint"
                        end
                    end
                end

                -- Apply highlighting based on visual mode and selection
                if in_visual_mode then
                    if is_in_selection then
                        return hl_str(highlighted, line)
                    else
                        -- Use diagnostic highlight if available, otherwise normal
                        return hl_str(diagnostic_hl or normal_highlight, line)
                    end
                else
                    -- Not in visual mode
                    if relnum == 0 then
                        -- Current line - use diagnostic highlight if available, otherwise highlighted
                        return hl_str(diagnostic_hl or highlighted, line)
                    else
                        -- Other lines - use diagnostic highlight if available, otherwise normal
                        return hl_str(diagnostic_hl or normal_highlight, line)
                    end
                end
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
                        -- text = { " │" },
                        text = { " " },
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
