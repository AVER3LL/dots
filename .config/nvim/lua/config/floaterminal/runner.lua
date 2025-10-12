local commands = require "config.floaterminal.commands"
local terminal = require "config.floaterminal.terminal"

local M = {}

function M.run()
    local filetype = vim.bo.filetype
    local command = commands.get_command(filetype)

    if not command then
        vim.notify("No run command defined for filetype: " .. filetype, vim.log.levels.WARN)
        return
    end

    if type(command) == "string" then
        terminal.send_command(command)
        return
    end

    if type(command) == "table" then
        for _, line in ipairs(command) do
            terminal.send_command(line)
        end
    end
end

return M
