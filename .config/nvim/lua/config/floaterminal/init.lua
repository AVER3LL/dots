local terminal = require "config.floaterminal.terminal"
local runner = require "config.floaterminal.runner"

local M = {}

M.toggle = terminal.toggle

M.send = terminal.send_command

M.put_command = terminal.put_command

M.put_current_file = terminal.put_current_file

M.run = runner.run

return M
