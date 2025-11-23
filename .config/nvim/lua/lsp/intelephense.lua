---@class vim.lsp.Config
local intelephense = {
    filetypes = {
        "php",
        "blade",
        "php_only",
    },
    settings = {
        intelephense = {
            filetypes = {
                "php",
                "blade",
                "php_only",
            },
            files = {
                associations = {
                    "*.php",
                    "*.blade.php",
                },
                maxSize = 5000000,
            },
        },
    },
}

return intelephense
