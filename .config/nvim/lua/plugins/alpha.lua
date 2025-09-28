--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param hl_shortcut string? optional
--- @param hl_icon string? optional - new parameter for icon highlighting
local function button(sc, txt, keybind, hl_shortcut, hl_icon)
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

    -- Extract icon and text parts
    local icon = txt:match "^(%S+)" -- First non-whitespace sequence (the icon)
    local text_part = txt:match "^%S+%s*(.*)" -- Everything after the icon and spaces

    local opts = {
        position = "center",
        shortcut = " " .. sc .. " ",
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = hl_shortcut or "AlphaButton",
        hl = "Normal",
    }

    -- If icon highlight is specified, create highlighted text
    if hl_icon and icon and text_part then
        opts.hl = {
            { hl_icon, 0, #icon }, -- Highlight icon with custom highlight group
            { "Normal", #icon, -1 }, -- Highlight rest with default
        }
    end

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
    enabled = true,
    priority = 900,
    event = "VimEnter",
    config = function()
        local alpha = require "alpha"

        local heading = {
            type = "text",
            val = require("config.banners")["modern"],
            opts = {
                position = "center",
                hl = "Type",
            },
        }

        local buttons = {
            type = "group",
            val = {
                button(
                    "SPC f f",
                    "󰱼   Find File",
                    "<cmd>lua Snacks.picker.files({ layout = 'vscode' })<CR>",
                    nil,
                    "AlphaIconBlue"
                ),
                button("SPC w r", "󰁯   Restore Session", "<cmd>AutoSession restore<cr>", nil, "AlphaIconGreen"),
                button("q", "   Quit NVIM", vim.cmd.qa, nil, "AlphaIconRed"),
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
            val = " AVER3LL- ",
            opts = {
                position = "center",
                hl = "Number",
            },
        }

        -- Define custom highlight groups for icons
        vim.api.nvim_set_hl(0, "AlphaIconBlue", { fg = "#61afef" }) -- Blue for file icon
        vim.api.nvim_set_hl(0, "AlphaIconGreen", { fg = "#98c379" }) -- Green for restore icon
        vim.api.nvim_set_hl(0, "AlphaIconRed", { fg = "#e06c75" }) -- Red for quit icon

        vim.api.nvim_create_autocmd("UIEnter", {
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                loaded.val = "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. " ms"
                pcall(vim.cmd.AlphaRedraw)
            end,
        })

        local layout = {
            { type = "padding", val = 1 },
            heading,
            { type = "padding", val = 3 },
            averell,
            buttons,
            { type = "padding", val = 3 },
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
