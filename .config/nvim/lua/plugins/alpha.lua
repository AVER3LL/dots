--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param hl_shortcut string? optional
local function button(sc, txt, keybind, hl_shortcut)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
    local opts = {
        position = "center",
        shortcut = " " .. sc .. " ",
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = hl_shortcut or "AlphaButton",
        hl = "String",
    }
    local keybind_opts
    if keybind then
        keybind_opts = { noremap = true, silent = true, nowait = true }
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

return {
    "goolord/alpha-nvim",
    priority = 900,
    event = "VimEnter",
    config = function()
        local alpha = require "alpha"

        local heading = {
            type = "text",
            val = require("config.banners")["threeskulls_v1"],
            opts = {
                position = "center",
                hl = "Type",
            },
        }

        local buttons = {
            type = "group",
            val = {
                button("SPC f f", "󰱼   Find File", "<cmd>lua Snacks.picker.files({ layout = 'vscode' })<CR>"),
                button("SPC w r", "󰁯   Restore Session", "<cmd>SessionRestore<CR>"),
                button("q", "   Quit NVIM", "<cmd>qa<CR>"),
            },
            opts = {
                position = "center",
                spacing = 1,
            },
        }

        local loaded = {
            type = "text",
            val = "Could not load plugins...",
            opts = {
                position = "center",
                hl = "Comment",
            },
        }

        local averell = {
            type = "text",
            val = " AVER3LL ",
            opts = {
                position = "center",
                hl = "Number",
            },
        }

        vim.api.nvim_create_autocmd("UIEnter", {
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                loaded.val = "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. " ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })

        local layout = {
            { type = "padding", val = 1 },
            heading,
            { type = "padding", val = 4 },
            averell,
            buttons,
            { type = "padding", val = 4 },
            loaded,
        }

        local config = {
            layout = layout,
            opts = { margin = 10 },
        }

        alpha.setup(config)

        -- Disable folding on alpha buffer
        vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
    end,
}
