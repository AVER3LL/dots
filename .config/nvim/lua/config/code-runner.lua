-- code-runner.lua
local M = {}

-- Define the file type commands
local file_type_commands = {
    java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
    python = "python3 -u $filePath",
    lua = "lua $filePath",
    typescript = "deno run",
    rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
}

-- Function to replace variables in command string
local function replace_variables(cmd)
    local dir = vim.fn.expand "%:p:h"
    local file_name = vim.fn.expand "%:t"
    local file_name_without_ext = vim.fn.expand "%:t:r"
    local file_path = vim.fn.expand "%:p"

    return cmd:gsub("$dir", dir)
        :gsub("$fileName", file_name)
        :gsub("$fileNameWithoutExt", file_name_without_ext)
        :gsub("$filePath", file_path)
end

-- Function to get the final command for current filetype
local function get_command()
    local ft = vim.bo.filetype
    local cmd = file_type_commands[ft]

    if not cmd then
        vim.notify("No command defined for filetype: " .. ft, vim.log.levels.WARN)
        return nil
    end

    return replace_variables(cmd)
end

-- Public function to run the current file
function M.run_file()
    local command = get_command()
    if command then
        Snacks.terminal.get(command, { cwd = vim.fn.expand "%:p:h", interactive = true })
    end
end

return M
