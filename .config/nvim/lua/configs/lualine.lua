local lualine_installed, lualine = pcall(require, "lualine")

{ Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
if not lualine_installed then
    return
end

local ok, border = pcall(require, "config.looks")
local bt = ok and border.border_type() or "single"
bt = "single"

local sec_sep = {
    rounded = { left = "", right = "" }, -- other separators : "", "", "", "",
    -- single = { left = "", right = "" }, -- other separators : "", "", "", "",
    -- single = { left = "", right = "" },
    single = { left = "", right = "" },
}
local comp_sep = {
    rounded = { left = "", right = "" },
    -- single = { left = "", right = "" },
    single = { left = "▎", right = "▎" },
}

local function setup_lualine()
    vim.o.laststatus = 0
    local function activated_python_environment()
        if vim.bo.filetype ~= "python" then
            return ""
        end

        local venv_selector_ok, venv_selector = pcall(require, "venv-selector")
        local venv_name = venv_selector_ok and venv_selector.venv() or nil

        if venv_name == nil then
            return "System"
        end

        -- Split the venv_name by '/' and get the last word
        local words = {}
        for word in string.gmatch(venv_name, "([^/]+)") do
            table.insert(words, word)
        end
        local last_word = words[#words]

        return tostring(last_word)
    end

    local function recording()
        local reg = vim.fn.reg_recording()
        if reg == "" then
            return ""
        end -- not recording
        return "recording @" .. reg
    end

    -- configure lualine with modified theme
    lualine.setup {
        options = {
            theme = "auto",
            section_separators = sec_sep[bt],
            component_separators = comp_sep[bt],
            globalstatus = true,
            disabled_filetypes = { "alpha", "TelescopePrompt" },
            always_divide_middle = true,
        },
        sections = {
            -- lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
            lualine_a = {
                {
                    "mode",
                    icons_enabled = true,
                    icon = "",
                    fmt = function(string, _)
                        return string:sub(1, 1):upper() .. string:sub(2):lower()
                    end,
                },
            },
            lualine_b = {
                {
                    "filename",
                    path = 4,
                    shorting_target = 20,
                },
                {
                    "branch",
                    icon = "",
                },
            },
            lualine_c = {
                {
                    "diff",
                    cond = function()
                        return vim.fn.isdirectory ".git" == 1
                    end,
                },
                "diagnostics",
                recording,
            },
            lualine_x = {
                {
                    require("noice").api.status.command.get,
                    cond = require("noice").api.status.command.has,
                    color = { fg = "#ff9e64" },
                },
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#2aa198" },
                    on_click = function()
                        require("lazy").home()
                    end,
                },
            },
            lualine_y = {
                {
                    activated_python_environment,
                    on_click = function()
                        vim.cmd "VenvSelect"
                    end,
                },
                {
                    "lsp_status",
                    icon = " ",
                    symbols = {
                        -- Standard unicode symbols to cycle through for LSP progress:
                        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                        -- Standard unicode symbol for when LSP is done:
                        done = "✓",
                        -- Delimiter inserted between LSP names:
                        separator = ", ",
                    },
                    -- List of LSP names to ignore (e.g., `null-ls`):
                    ignore_lsp = {},
                    fmt = function(inputString)
                        local replacementMap = {
                            emmet_language_server = "Emmet",
                            jedi_language_server = "Jedi",
                        }

                        local result = {}
                        for value in inputString:gmatch "([^,]+)" do
                            value = value:match "^%s*(.-)%s*$" -- Trim spaces
                            table.insert(result, replacementMap[value] or value)
                        end

                        return table.concat(result, ", ")
                    end,
                },
                "filetype",
                "progress",
            },
            -- lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = { "filename" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "location" },
        },
        extensions = { "nvim-tree", "fzf", "toggleterm", "mason", "lazy", "neo-tree" },
    }
end

return setup_lualine()
