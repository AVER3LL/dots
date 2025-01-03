-- ~/.config/nvim/lua/configs/mini-ai.lua
local M = {}

function M.setup()
    local mini_installed, ai = pcall(require, "mini.ai")
    if not mini_installed then
        return
    end

    ai.setup {
        mappings = {
            around = "a",
            inside = "i",
            around_next = "an",
            inside_next = "in",
            around_last = "al",
            inside_last = "il",
            goto_left = "[",
            goto_right = "]",
        },
        custom_textobjects = {
            f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
            a = ai.gen_spec.treesitter { a = "@parameter.outer", i = "@parameter.inner" },
            i = ai.gen_spec.treesitter { a = "@conditional.outer", i = "@conditional.inner" },
            -- l = ai.gen_spec.treesitter { a = "@loop.outer", i = "@loop.inner" },
            c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
            -- The tag specification might need adjustment
            d = { "%f[%d]%d+" }, -- digits
            e = { -- Word with case
                {
                    "%u[%l%d]+%f[^%l%d]",
                    "%f[%S][%l%d]+%f[^%l%d]",
                    "%f[%P][%l%d]+%f[^%l%d]",
                    "^[%l%d]+%f[^%l%d]",
                },
                "^().*()$",
            },
            u = ai.gen_spec.function_call(), -- u for "Usage"
        },
        n_lines = 500,
        silent = true,
    }
end

return M
