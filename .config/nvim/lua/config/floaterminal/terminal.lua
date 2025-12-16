local window = require "config.floaterminal.window"

local Terminal = {}

local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

function Terminal.create()
    state.floating = window.create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
        vim.cmd.terminal()
        vim.bo[state.floating.buf].buflisted = false
    end
end

function Terminal.send_command(cmd)
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        Terminal.create()
    end

    local chan = vim.b[state.floating.buf].terminal_job_id
    if chan then
        vim.schedule(function()
            vim.api.nvim_chan_send(chan, cmd .. "\n")
        end)
    end
end

--- @param cmd string
--- @param cursor_position "start"|"end"
function Terminal.put_command(cmd, cursor_position)
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        Terminal.create()
    end

    local chan = vim.b[state.floating.buf].terminal_job_id
    if chan then
        -- Focus the terminal window first
        vim.api.nvim_set_current_win(state.floating.win)

        vim.schedule(function()
            -- Enter insert mode in the terminal
            vim.api.nvim_feedkeys("i", "n", false)

            -- Insert the command
            vim.api.nvim_chan_send(chan, "  " .. cmd)

            -- Handle cursor positioning
            if cursor_position == "start" then
                -- Move to the beginning of the line
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Home>", true, false, true), "t", false)
            end
        end) -- Reduced delay for better responsiveness
    else
        vim.notify("Terminal channel not found", vim.log.levels.ERROR)
    end
end

--- @param cursor_position "start"|"end"
function Terminal.put_current_file(cursor_position)
    -- Get full file path of the current buffer
    local filepath = vim.api.nvim_buf_get_name(0)

    -- Only proceed if filepath is not empty
    if filepath and filepath ~= "" then
        -- Call put_command with the file path as the command
        Terminal.put_command(filepath, cursor_position)
    else
        vim.notify("No file path found for current buffer", vim.log.levels.WARN)
    end
end

function Terminal.toggle()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        Terminal.create()
        vim.cmd.startinsert()
        return
    end
    vim.api.nvim_win_hide(state.floating.win)
end

return Terminal
