local terminal = require "config.floaterminal.terminal"
local runner = require "config.floaterminal.runner"

local M = {}

M.toggle = terminal.toggle

M.send = terminal.send_command

M.run = runner.run

return M
