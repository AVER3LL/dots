local ibl_installed, ibl = pcall(require, "ibl")

if not ibl_installed then
    return
end

local function setup_ibl()
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

    ibl.setup {
        exclude = {
            filetypes = {
                "help",
                "lazy",
                "mason",
                "notify",
                "oil",
                "lazy",
                "NvimTree",
                "terminal",
                "lspinfo",
                "TelescopePrompt",
                "TelescopeResults",
                "Trouble",
                "trouble",
                "toggleterm",
                "alpha",
            },
            buftypes = {
                "terminal",
                "nofile",
                "prompt",
            },
        },
        -- indent = { char = "│" },
        -- scope = { char = "│", show_start = false, show_end = false },
        indent = { char = "┊" },
        scope = { char = "┊", show_start = false, show_end = false },
    }
end

return setup_ibl()
