-- init.lua or a separate lua file sourced from it
local uv = vim.loop

-- Create a new signal handle
local sigusr1 = uv.new_signal()

-- Start listening for SIGUSR1
---@diagnostic disable-next-line: need-check-nil
sigusr1:start("sigusr1", function()
    vim.schedule(function()
        -- tools.change_background()

        dofile(vim.fn.stdpath "config" .. "/lua/config/generated.lua")
    end)
end)
