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
        vim.defer_fn(function()
            vim.api.nvim_chan_send(chan, cmd .. "\n")
        end, 235)
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
