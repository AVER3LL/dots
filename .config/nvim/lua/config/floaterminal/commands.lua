local M = {}

M.CONFIG_FILE_NAME = "runner.json"

M.filetype_commands = {
    python = "python -u $filepath",
    lua = "lua $filepath",
    javascript = "node $filepath",
    php = "php $filepath",
    typescript = "tsc $fileName && node $fileNameWithoutExt.js",
    c = {
        "cd $dir",
        "gcc $fileName -o $fileNameWithoutExt",
        "$dir$fileNameWithoutExt",
    },
    cpp = {
        "cd $dir",
        "g++ $fileName -o $fileNameWithoutExt",
        "$dir$fileNameWithoutExt",
    },
    java = {
        "cd $dir",
        "javac $fileName",
        "java $fileNameWithoutExt",
    },
    kotlin = {
        "cd $dir",
        "kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar",
        "java -jar $fileNameWithoutExt.jar",
    },
    rust = {
        "cd $dir",
        "rustc $fileName",
        "$dir$fileNameWithoutExt",
    },
    haskell = {
        "cd $dir",
        "ghc -o $fileNameWithoutExt $fileName",
        "$dir$fileNameWithoutExt",
    },
    tex = "~/Documents/memoire-2025/Template-Licence-3-Latex/compile_latex.sh $fileName",
    go = "go run $filepath",
    sh = "bash $filepath",
    dart = "dart $filepath",
    html = "xdg-open $filepath",
}

function M.interpolate_variables(command)
    -- Note: Order of substitutions matters to avoid conflicts
    local substitutions = {
        filepath = vim.fn.expand "%:p",
        dirWithoutTrailingSlash = vim.fn.expand "%:h",
        fileNameWithoutExt = vim.fn.expand "%:t:r",
        fileName = vim.fn.expand "%:t",
    }

    local key_order = {
        "dirWithoutTrailingSlash",
        "fileNameWithoutExt",
        "filepath",
        "fileName",
        "dir",
    }

    substitutions.dir = substitutions.dirWithoutTrailingSlash
    if not substitutions.dir:match "/$" then
        substitutions.dir = substitutions.dir .. "/"
    end

    if type(command) == "string" then
        return M.substitute_variables(command, substitutions, key_order)
    end

    if type(command) == "table" then
        local result = {}
        for _, value in ipairs(command) do
            table.insert(result, M.substitute_variables(value, substitutions, key_order))
        end

        return table.concat(result, " && ")
    else
        error("Invalid command type: expected string or table, got " .. type(command))
    end
end

function M.substitute_variables(command, substitutions, key_order)
    for _, key in ipairs(key_order) do
        command = command:gsub("%$" .. key, substitutions[key])
    end

    return command
end

function M.get_filetype_command(filetype)
    local command = M.filetype_commands[filetype]

    if not command then
        return nil
    end

    return M.interpolate_variables(command)
end

function M.config_file_exists()
    return vim.fn.filereadable(vim.fn.expand "./" .. M.CONFIG_FILE_NAME) ~= 0
end

function M.get_config_file_command(filetype)
    local content = table.concat(vim.fn.readfile(vim.fn.expand("./" .. M.CONFIG_FILE_NAME)), "\n")

    local ok, data = pcall(vim.json.decode, content)
    if not ok then
        error("Failed to decode JSON from config file: " .. data)
    end

    local command = data[filetype]
    if not command then
        return nil
    end

    return M.interpolate_variables(command)
end

function M.get_command(filetype)
    -- First priority: filetype-specific command from config file
    if M.config_file_exists() then
        local command = M.get_config_file_command(filetype)
        if command then
            return command
        end
    end

    -- Second priority: hardcoded filetype command
    local hardcoded_command = M.get_filetype_command(filetype)
    if hardcoded_command then
        return hardcoded_command
    end

    -- Third priority: generic "command" field from config file (fallback)
    if M.config_file_exists() then
        local content = table.concat(vim.fn.readfile(vim.fn.expand("./" .. M.CONFIG_FILE_NAME)), "\n")
        local ok, data = pcall(vim.json.decode, content)
        if ok and data.command then
            return M.interpolate_variables(data.command)
        end
    end

    return nil
end

function M.create_runner_file()
    local config_dir = vim.fn.stdpath "config"
    -- TODO: There's probably a better way to do this
    local template_path = config_dir .. "/lua/config/floaterminal/runner-template.json"
    local dest_path = vim.fn.getcwd() .. "/" .. M.CONFIG_FILE_NAME

    if vim.fn.filereadable(template_path) == 0 then
        vim.notify("Runner template not found at: " .. template_path, vim.log.levels.ERROR)
        return
    end

    local function copy_file()
        local success = os.execute("cp " .. vim.fn.shellescape(template_path) .. " " .. vim.fn.shellescape(dest_path))
        if success == 0 or success == true then
            vim.notify("Runner file created at " .. dest_path, vim.log.levels.INFO)
            vim.cmd("edit " .. dest_path)
        else
            vim.notify("Failed to create runner file", vim.log.levels.ERROR)
        end
    end

    if vim.fn.filereadable(dest_path) == 1 then
        vim.ui.select(
            { "Overwrite it", "Cancel" },
            { prompt = 'A "' .. M.CONFIG_FILE_NAME .. '" file already exists.' },
            function(choice)
                if choice == "Cancel" then
                    vim.notify("Runner creation cancelled.", vim.log.levels.INFO)
                    return
                elseif choice == "Overwrite it" then
                    copy_file()
                end
            end
        )
    else
        copy_file()
    end
end

return M
