if vim.g.vscode then
    require "core.vscode_mappings"
else
    require "core"

    require "lsp"

    require "config.lazy"

    -- Get the home directory from environment
    local home = os.getenv "HOME"
    local config = home .. "/.config/gtk-3.0/settings.ini"

    -- Function to read file line by line
    local function get_theme_value(path)
        local file = io.open(path, "r")
        if not file then
            return nil
        end

        for line in file:lines() do
            local value = line:match "^gtk%-application%-prefer%-dark%-theme%s*=%s*(%d+)"
            if value then
                file:close()
                return value
            end
        end

        file:close()
        return nil
    end

    vim.cmd.colorscheme "jb"
    if get_theme_value(config) == "1" then
        vim.o.background = "dark"
    else
        vim.o.background = "light"
    end

    require("config.winbar").setup()
    require "config.statusline"
end
