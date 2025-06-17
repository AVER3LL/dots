local runner = require "floaterminal.runner"
local terminal = require "floaterminal.terminal"

local M = {}

function M.run()
    runner.run()
end

function M.toggle()
    terminal.toggle()
end

function M.send_command(cmd)
    terminal.send_command(cmd)
end

function M.setup()
    vim.api.nvim_create_user_command("Floaterminal", M.toggle, {})
    vim.api.nvim_create_user_command("FloaterminalSend", function(opts)
        M.send_command(opts.args)
    end, { nargs = "+" })
end

return M
