local commands = require "config.floaterminal.commands"
local runner = require "config.floaterminal.runner"
local terminal = require "config.floaterminal.terminal"

local M = {}

M.toggle = terminal.toggle

M.send = terminal.send_command

M.put_command = terminal.put_command

M.put_current_file = terminal.put_current_file

M.create_runner_file = commands.create_runner_file

M.compile_command = runner.compile_command

M.run = runner.run

return M
