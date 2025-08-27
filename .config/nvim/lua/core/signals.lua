-- init.lua or a separate lua file sourced from it
local uv = vim.loop

-- Create a new signal handle
local sigusr1 = uv.new_signal()

-- Start listening for SIGUSR1
---@diagnostic disable-next-line: need-check-nil
sigusr1:start("sigusr1", function()
    vim.schedule(function()
        tools.change_background()
        vim.notify("Background toggled to " .. vim.o.background, vim.log.levels.INFO)
    end)
end)
