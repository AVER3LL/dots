local window = require "floaterminal.window"

local M = {}

local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

local function create_hidden_terminal()
    state.floating = window.create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
        vim.cmd.terminal()
        vim.bo[state.floating.buf].buflisted = false
    end
end

function M.send_command(cmd)
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        create_hidden_terminal()
    end

    local chan = vim.b[state.floating.buf].terminal_job_id
    if chan then
        vim.api.nvim_chan_send(chan, cmd .. "\n")
    end
end

function M.toggle()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        create_hidden_terminal()
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
    vim.cmd.startinsert()
end

return M
