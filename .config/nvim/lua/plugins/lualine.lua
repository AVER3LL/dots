return {

    -- Line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        enabled = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local lualine = require "lualine"

            local function activated_python_environment()
                local venv_name = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV" or nil

                -- Determine which Python to use
                local python_cmd = "python"
                local env_label = "system"

                if venv_name then
                    -- Use the Python from the virtual environment
                    python_cmd = venv_name .. "/bin/python"
                    env_label = venv_name:match "([^/]+)$" or venv_name
                end

                -- Get version from the appropriate Python
                local job = vim.system({ python_cmd, "--version" }, { text = true }):wait()
                if job.code ~= 0 then
                    return venv_name and (" " .. env_label) or " System"
                end

                local version = vim.trim(job.stdout):gsub("^Python ", "")
                return version .. " (" .. env_label .. ")"
            end

            local function git_project_branch()
                -- Get git root directory
                local git_root = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
                if git_root.code ~= 0 then
                    return ""
                end

                -- Get project name from git root
                local project_name = vim.trim(git_root.stdout):match "([^/]+)$"
                if not project_name then
                    return ""
                end

                -- Get current branch
                local branch = vim.system({ "git", "branch", "--show-current" }, { text = true }):wait()
                if branch.code ~= 0 then
                    return project_name
                end

                local branch_name = vim.trim(branch.stdout)
                return project_name .. "  " .. branch_name
            end

            local python_venv = {
                activated_python_environment,
                on_click = function()
                    vim.cmd "VenvSelect"
                end,
                cond = function()
                    return vim.bo.filetype == "python"
                end,
            }

            local git_info = {
                git_project_branch,
            }

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
                    -- section_separators = {},
                    component_separators = {},
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { git_info },
                    lualine_c = { python_venv },
                    lualine_x = { lsp_status, "filetype" },
                    lualine_y = { "location", "selectioncount" },
                    lualine_z = { "progress" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = {},
                    lualine_y = { "location" },
                    lualine_z = {},
                },
                tabline = {},
                extensions = {},
            }

            vim.defer_fn(function()
                vim.o.laststatus = 0
            end, 1)
        end,
    },
}
