local commands = require "config.floaterminal.commands"
local terminal = require "config.floaterminal.terminal"

local M = {}

function M.run()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand "%:t"
    local command = commands.get_command(filename, filetype)

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

function M.compile_command(cursor_position)
    -- if it is a single command, put it in the terminal
    -- if it is a list of commands, ask to select the command, run the commands before, stop on the selected command and let the user type the command. We can then continue
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand "%:t"

    local command = commands.get_command(filename, filetype)
    if type(command) == "string" then
        terminal.put_command(command, cursor_position)
        return
    end

    if type(command) == "table" then
        vim.ui.select(command, {
            prompt = "Select the command to edit",
        }, function(choice)
            if choice == nil then
                return
            end

            for _, line in ipairs(command) do
                if line == choice then
                    break
                end
                terminal.send_command(line)
            end

            terminal.put_command(choice, cursor_position)
        end)
    end
end

return M
