return {

    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"
            require("core.mappings").debugger()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-dap-virtual-text").setup {
                -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
                display_callback = function(variable)
                    local name = string.lower(variable.name)
                    local value = string.lower(variable.value)
                    if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                        return "*****"
                    end

                    if #variable.value > 15 then
                        return " " .. string.sub(variable.value, 1, 15) .. "... "
                    end

                    return " " .. variable.value
                end,
            }
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            local path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },
}
