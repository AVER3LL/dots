local commands = require "config.floaterminal.commands"
local terminal = require "config.floaterminal.terminal"

local M = {}

function M.run()
    local filetype = vim.bo.filetype
    local command = commands.get_command_for_filetype(filetype)

    if not command then
        vim.notify("No run command defined for filetype: " .. filetype, vim.log.levels.WARN)
        return
    end

    terminal.send_command(command)
end

return M
