-- ide_helper.lua - IDE Helper package management and generation
local utils = require "config.laravel.utils"

local M = {}

-- Check if ide-helper package is installed
local function is_ide_helper_installed(laravel_root)
    local composer_file = laravel_root .. "/composer.json"
    if vim.fn.filereadable(composer_file) == 0 then
        return false
    end

    local composer_content = table.concat(vim.fn.readfile(composer_file), "\n")
    return composer_content:match "barryvdh/laravel%-ide%-helper" ~= nil
end

-- Install ide-helper package
local function install_ide_helper(laravel_root)
    vim.notify("Installing laravel-ide-helper package...", vim.log.levels.INFO)

    local install_cmd = "cd " .. laravel_root .. " && composer require --dev barryvdh/laravel-ide-helper"

    vim.fn.jobstart(install_cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify("IDE Helper package installed successfully!", vim.log.levels.INFO)
                -- After successful installation, run the generation commands
                M.generate_ide_helpers()
            else
                vim.notify("Failed to install IDE Helper package", vim.log.levels.ERROR)
            end
        end,
        on_stdout = function(_, data)
            if data and #data > 0 then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print("Error: " .. line)
                    end
                end
            end
        end,
    })
end

-- Run a single artisan command with output handling
local function run_artisan_command(cmd, laravel_root, callback)
    local full_cmd = "cd " .. laravel_root .. " && php artisan " .. cmd

    vim.notify("Running: php artisan " .. cmd, vim.log.levels.INFO)

    vim.fn.jobstart(full_cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                vim.notify("✓ Completed: php artisan " .. cmd, vim.log.levels.INFO)
                if callback then
                    callback()
                end
            else
                vim.notify("✗ Failed: php artisan " .. cmd, vim.log.levels.ERROR)
            end
        end,
        on_stdout = function(_, data)
            if data and #data > 0 then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print("Error: " .. line)
                    end
                end
            end
        end,
    })
end

-- Generate all IDE helper files
M.generate_ide_helpers = function()
    if not utils.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local laravel_root = utils.get_laravel_root()

    -- Check if ide-helper is installed
    if not is_ide_helper_installed(laravel_root) then
        vim.ui.select({ "Yes", "No" }, {
            prompt = "IDE Helper package not found. Install it now?",
        }, function(choice)
            if choice == "Yes" then
                install_ide_helper(laravel_root)
            end
        end)
        return
    end

    -- Run commands sequentially
    local commands = {
        "ide-helper:generate",
        "ide-helper:models --write",
        "ide-helper:meta",
    }

    local function run_next_command(index)
        if index <= #commands then
            run_artisan_command(commands[index], laravel_root, function()
                run_next_command(index + 1)
            end)
        else
            vim.notify("🎉 All IDE helper files generated successfully!", vim.log.levels.INFO)
        end
    end

    run_next_command(1)
end

-- Generate only the basic helper file
M.generate_basic = function()
    if not utils.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local laravel_root = utils.get_laravel_root()

    if not is_ide_helper_installed(laravel_root) then
        vim.notify("IDE Helper package not installed. Use generate_ide_helpers() to install it.", vim.log.levels.WARN)
        return
    end

    run_artisan_command("ide-helper:generate", laravel_root)
end

-- Generate only model helpers
M.generate_models = function()
    if not utils.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local laravel_root = utils.get_laravel_root()

    if not is_ide_helper_installed(laravel_root) then
        vim.notify("IDE Helper package not installed. Use generate_ide_helpers() to install it.", vim.log.levels.WARN)
        return
    end

    run_artisan_command("ide-helper:models --write", laravel_root)
end

-- Generate only meta helpers
M.generate_meta = function()
    if not utils.is_laravel_project() then
        vim.notify("Not in a Laravel project", vim.log.levels.WARN)
        return
    end

    local laravel_root = utils.get_laravel_root()

    if not is_ide_helper_installed(laravel_root) then
        vim.notify("IDE Helper package not installed. Use generate_ide_helpers() to install it.", vim.log.levels.WARN)
        return
    end

    run_artisan_command("ide-helper:meta", laravel_root)
end

return M
