return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    init = function()
        local is_windows = vim.fn.has "win32" ~= 0
        local sep = is_windows and "\\" or "/"
        local delim = is_windows and ";" or ":"
        vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
    end,
    opts = {
        ui = {
            icons = {
                package_pending = " ",
                package_installed = " ",
                package_uninstalled = " ",
            },
        },
        max_concurrent_installers = 10,
        ensure_installed = function()
            local tools = {}
            vim.list_extend(tools, require "config.lsp.formatters")
            vim.list_extend(tools, require("config.lsp.servers").mason)
            vim.list_extend(tools, require "config.lsp.linters")
            vim.list_extend(tools, require "config.lsp.debuggers")
            return tools
        end,
    },
    config = function(_, opts)
        -- Resolve ensure_installed if it's a function
        if type(opts.ensure_installed) == "function" then
            opts.ensure_installed = opts.ensure_installed()
        end

        require("mason").setup(opts)

        -- Custom MasonInstallAll command to install only missing packages
        vim.api.nvim_create_user_command("MasonInstallAll", function()
            local mr = require "mason-registry"
            local missing_packages = {}

            for _, package_name in ipairs(opts.ensure_installed) do
                local package = mr.get_package(package_name)
                if not package:is_installed() then
                    table.insert(missing_packages, package_name)
                end
            end

            if #missing_packages > 0 then
                vim.cmd("MasonInstall " .. table.concat(missing_packages, " "))
            else
                vim.notify("All packages are already installed!", vim.log.levels.INFO)
            end
        end, {})

        vim.g.mason_binaries_list = opts.ensure_installed
    end,
}
