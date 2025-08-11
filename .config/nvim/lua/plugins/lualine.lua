return {

    -- Line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        enabled = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        config = function()
            local lualine = require "lualine"
            vim.o.laststatus = vim.g.lualine_laststatus

            local lsp_status = {
                "lsp_status",
                icon = " ",
                symbols = {
                    -- Standard unicode symbols to cycle through for LSP progress:
                    spinner = {},
                    -- Standard unicode symbol for when LSP is done:
                    done = "",
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
            }

            -- configure lualine with modified theme
            lualine.setup {
                options = {
                    icons_enabled = true,
                    disabled_filetypes = { "alpha", "TelescopePrompt", "snacks_picker_input" },
                    section_separators = {},
                    globalstatus = true,
                    component_separators = {},
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = { lsp_status, "filetype" },
                    lualine_y = { "location" },
                    lualine_z = { "progress" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                extensions = {},
            }
        end,
    },
}
