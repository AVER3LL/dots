return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",

            "jay-babu/mason-nvim-dap.nvim",
        },
        keys = {
            { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
            { "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", desc = "Continue" },
            { "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", desc = "Step into" },
            { "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", desc = "Step out" },
        },
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"

            ---@diagnostic disable-next-line: missing-parameter
            require("nvim-dap-virtual-text").setup()

            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close
        end,
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        lazy = true,
        dependencies = {
            "mason-org/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                handlers = {},

                ensure_installed = { "python" },
            }
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
