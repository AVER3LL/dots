local M = {}

M.CONFIG_FILE_NAME = "runner.lua"

M.filetype_commands = {
    python = "python -u $filepath",
    lua = "lua $filepath",
    javascript = "node $filepath",
    php = "php $filepath",
    typescript = "tsc $filename && node $filenameWithoutExt.js",
    c = {
        "cd $dir",
        "gcc $filename -o $filenameWithoutExt",
        "$dir$filenameWithoutExt",
    },
    cpp = {
        "cd $dir",
        "g++ $filename -o $filenameWithoutExt",
        "$dir$filenameWithoutExt",
    },
    java = {
        "cd $dir",
        "javac $filename",
        "java $dir$filenameWithoutExt",
    },
    kotlin = {
        "cd $dir",
        "kotlinc $filename -include-runtime -d $filenameWithoutExt.jar",
        "java -jar $filenameWithoutExt.jar",
    },
    rust = {
        "cd $dir",
        "rustc $filename",
        "$dir$filenameWithoutExt",
    },
    haskell = {
        "ghci",
        ":l $filepath",
    },
    tex = "pdflatex $filepath",
    go = "go run $filepath",
    sh = "bash $filepath",
    dart = "dart $filepath",
    html = "xdg-open $filepath",
}

function M.interpolate_variables(command)
    local substitutions = {
        filepath = vim.fn.expand "%:p",
        dirWithoutTrailingSlash = vim.fn.expand "%:h",
        filenameWithoutExt = vim.fn.expand "%:t:r",
        filename = vim.fn.expand "%:t",
    }

    -- NOTE: Order of substitutions matters to avoid conflicts
    local key_order = {
        "dirWithoutTrailingSlash",
        "filenameWithoutExt",
        "filepath",
        "filename",
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

        -- return table.concat(result, " && ")
        return result
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

function M.get_config_file_command(filename, filetype)
    -- loadfile returns a function, which needs to be called to execute the code
    local config_loader, load_err = loadfile(vim.fn.expand("./" .. M.CONFIG_FILE_NAME))
    if not config_loader then
        error("Failed to load runner config file: " .. load_err)
    end

    -- Execute the loaded Lua code
    local config = config_loader()

    if not config or type(config) ~= "table" then
        error "Invalid runner config: file must return a table"
    end

    local command = config[filetype]

    if config.filename and config.filename[filename] then
        command = config.filename[filename]
    end

    if not command then
        return nil
    end

    return M.interpolate_variables(command)
end

function M.get_command(filename, filetype)
    -- First priority: filetype-specific command from config file
    if M.config_file_exists() then
        local command = M.get_config_file_command(filename, filetype)
        if command then
            return command
        end
    end

    -- Second priority: hardcoded filetype command
    local hardcoded_command = M.get_filetype_command(filetype)
    if hardcoded_command then
        return hardcoded_command
    end

    return nil
end

function M.create_runner_file()
    local config_dir = vim.fn.stdpath "config"
    -- TODO: There's probably a better way to do this
    local template_path = config_dir .. "/lua/config/floaterminal/runner-template.lua"
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
        vim.cmd("edit " .. dest_path)
        return
    end

    vim.ui.select({ "Create it", "Cancel" }, { prompt = M.CONFIG_FILE_NAME .. '" file not found.' }, function(choice)
        if choice == "Cancel" then
            vim.notify("Runner creation cancelled.", vim.log.levels.INFO)
            return
        elseif choice == "Create it" then
            copy_file()
        end
    end)
end

return M
