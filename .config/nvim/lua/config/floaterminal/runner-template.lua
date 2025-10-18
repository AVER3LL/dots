local M = {}

-- INFO:
-- You can use the following variables in your commands:
--   $filepath                - Full path to the file
--   $dir                     - Directory of the file, with a trailing slash
--   $dirWithoutTrailingSlash - Directory of the file, without a trailing slash
--   $filename                - Filename with extension
--   $filenameWithoutExt      - Filename without extension

M._python = "python -u $filepath"

M.filename = {
    ["_hello.lua"] = "echo 'hello world'",
}

M._c = {
    "cd $dir",
    "gcc $filename -o $filenameWithoutExt",
    "$dir/$filenameWithoutExt",
}

return M
