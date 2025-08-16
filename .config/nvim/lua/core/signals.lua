-- init.lua or a separate lua file sourced from it
local uv = vim.loop

-- Create a new signal handle
local sigusr1 = uv.new_signal()

-- Start listening for SIGUSR1
---@diagnostic disable-next-line: need-check-nil
sigusr1:start("sigusr1", function()
    vim.schedule(function()
        -- Toggle background between 'light' and 'dark'
        if vim.o.background == "dark" then
            vim.o.background = "light"
        else
            vim.o.background = "dark"
        end
        vim.notify("Background toggled to " .. vim.o.background, vim.log.levels.INFO)
    end)
end)
