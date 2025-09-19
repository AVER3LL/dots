local M = {}

-- Local man too angry to comment
M.archived_commads = {
    c = "gcc $filepath -o $fileNameWithoutExt && ./$fileNameWithoutExt",
    cpp = "g++ $filepath -o $fileNameWithoutExt && ./$fileNameWithoutExt",
}

M.run_commands = {
    python = "python -u $filepath",
    lua = "lua $filepath",
    javascript = "node $filepath",
    php = "php $filepath",
    typescript = "tsc $fileName && node $fileNameWithoutExt.js",
    c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
    cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
    java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
    kotlin = "cd $dir && kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar $fileNameWithoutExt.jar",
    rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
    tex = "~/Documents/memoire-2025/Template-Licence-3-Latex/compile_latex.sh $fileName",
    go = "go run $filepath",
    sh = "bash $filepath",
    dart = "dart $filepath",
    html = "xdg-open $filepath",
    haskell = "cd $dir && ghc -o $fileNameWithoutExt $fileName && $dir$fileNameWithoutExt",
}

function M.format_command(command)
    local filepath = vim.fn.expand "%:p"
    local dirWithoutTrailingSlash = vim.fn.expand "%:h"
    local fileName = vim.fn.expand "%:t"
    local fileNameWithoutExt = vim.fn.expand "%:t:r"

    -- Create dir with trailing slash
    local dir = dirWithoutTrailingSlash
    if not dir:match "/$" then
        dir = dir .. "/"
    end

    -- Replace in order from most specific to least specific to avoid conflicts
    return command
        :gsub("%$dirWithoutTrailingSlash", dirWithoutTrailingSlash)
        :gsub("%$fileNameWithoutExt", fileNameWithoutExt)
        :gsub("%$filepath", filepath)
        :gsub("%$fileName", fileName)
        :gsub("%$dir", dir)
end

function M.get_command_for_filetype(filetype)
    local command = M.run_commands[filetype]

    if not command then
        return nil
    end

    return M.format_command(command)
end

return M
