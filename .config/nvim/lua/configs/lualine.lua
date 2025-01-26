local lualine_installed, lualine = pcall(require, "lualine")

if not lualine_installed then
    return
end

local ok, border = pcall(require, "config.looks")
local bt = ok and border.border_type() or "single"
bt = "single"

local sec_sep = {
    rounded = { left = "", right = "" }, -- other separators : "", "", "", "",
    -- single = { left = "", right = "" },
    single = { left = "", right = "" },
}
local comp_sep = {
    rounded = { left = "", right = "" },
    -- single = { left = "", right = "" },
    single = { left = "▎", right = "▎" },
}

local function setup_lualine()
    local function truncate_branch_name(branch)
        if not branch or branch == "" then
            return ""
        end

        -- Match the branch name to the specified format
        local user, team, ticket_number = string.match(branch, "^(%w+)/(%w+)%-(%d+)")

        -- If the branch name matches the format, display {user}/{team}-{ticket_number}, otherwise display the full branch name
        if ticket_number then
            return user .. "/" .. team .. "-" .. ticket_number
        else
            return branch
        end
    end

    local function current_lsp()
        local name_mappings = {
            emmet_language_server = "Emmet",
        }

        local bufnr = vim.api.nvim_get_current_buf()
        local buf_clients = vim.lsp.get_clients { bufnr = bufnr } -- bufnr = 0 for current buffer, same thing
        if not next(buf_clients) then
            return ""
        end

        local lsp_names = vim.tbl_map(function(client)
            return name_mappings[client.name] or client.name
        end, buf_clients)

        local lsp_icon = " " -- You can change this icon to your preference
        return lsp_icon .. " " .. table.concat(lsp_names, ", ")
    end

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

    local mode = {
        "mode",
        fmt = function(str)
            -- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
            return " " .. str
        end,
    }

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
            lualine_a = { mode },
            lualine_b = {
                {
                    "filename",
                    path = 4,
                    shorting_target = 20,
                },
                {
                    "branch",
                    icon = "",
                    fmt = truncate_branch_name,
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
                -- {
                --     require("noice").api.status.command.get,
                --     cond = require("noice").api.status.command.has,
                --     color = { fg = "#ff9e64" },
                -- },
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
                activated_python_environment,
                current_lsp,
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
