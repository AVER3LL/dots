local M = {}

-- Tool categories
M.formatters = {
    -- Others
    "ast-grep",

    -- Web
    "prettier",

    -- LaTeX
    "latexindent",

    -- PHP
    "blade-formatter",
    "php-cs-fixer",
    "pint",

    -- Python
    "autopep8",
    "ruff",
    "black",
    "isort",

    -- Java
    "google-java-format",
    "checkstyle",

    -- System
    "shfmt",

    -- Documentation
    "doctoc",

    -- Go
    "gofumpt",
    "goimports-reviser",

    -- C/C++
    "clang-format",

    -- Toml
    "taplo",
}

M.lsps = {
    -- Web/Frontend
    "html-lsp",
    "css-lsp",
    "eslint-lsp",
    "emmet-language-server",
    "tailwindcss-language-server",
    "jinja-lsp",

    -- Python
    "basedpyright",
    "pyright",
    "python-lsp-server",

    --LaTeX
    "texlab",

    -- PHP
    "intelephense",
    "phpactor",

    -- System
    "bash-language-server",

    -- Lua
    "lua-language-server",

    -- Java
    "jdtls",

    -- Go
    "gopls",

    -- Window Manager
    "hyprls",

    -- C/C++ (disabled by default)
    -- "clangd",
}

M.debuggers = {
    -- Python
    "debugpy",
}

M.linters = {
    -- Python
    "debugpy",
    "pylint",
    "mypy",
    "flake8",

    -- Lua
    "stylua",
    "luacheck",

    -- Web
    "djlint",
    "eslint_d",

    -- C/C++
    "cpplint",

    -- PHP
    "easy-coding-standard",
}

-- Plugin specification
return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = {
        ui = {
            icons = {
                package_pending = " ",
                package_installed = " ",
                package_uninstalled = " ",
            },
        },
        PATH = "skip",
        max_concurrent_installers = 10,
        ensure_installed = function()
            local tools = {}
            vim.list_extend(tools, M.formatters)
            vim.list_extend(tools, M.lsps)
            vim.list_extend(tools, M.linters)
            vim.list_extend(tools, M.debuggers)
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
