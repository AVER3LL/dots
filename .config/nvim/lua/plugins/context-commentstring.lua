return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            enable_autocmd = false,
            custom_calculation = function(_, language_tree)
                if
                    vim.bo.filetype == "blade"
                    and language_tree._lang ~= "javascript"
                    and language_tree._lang ~= "php"
                then
                    return "{{-- %s --}}"
                end
            end,
        },
    },
}
