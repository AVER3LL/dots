local M = {}

-- Constants
M.CONSTANTS = {
    DEBOUNCE_MS = 50,
    DEFAULT_PADDING = 2,
    MIN_WINDOW_WIDTH = 30,
}

--- @class ComponentSpec
--- @field name string
--- @field priority integer

--- @class Config
--- @field show_diagnostics boolean
--- @field show_modified boolean
--- @field show_path_when_inactive boolean
--- @field min_padding integer
--- @field modified_icon string
--- @field ignore_filetypes string[]
--- @field ignore_buftypes string[]
--- @field min_window_width integer
--- @field component_order ComponentSpec[]

--- @type Config
M.defaults = {
    show_diagnostics = true,
    show_modified = true,
    show_path_when_inactive = false,
    modified_icon = require("icons").misc.dot,
    min_padding = M.CONSTANTS.DEFAULT_PADDING,
    min_window_width = M.CONSTANTS.MIN_WINDOW_WIDTH,
    component_order = {
        { name = "filename", priority = 1 },
        { name = "modified", priority = 2 },
        { name = "path", priority = 3 },
        { name = "diagnostics", priority = 2 },
    },
    ignore_filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "snacks_dashboard",
        "TelescopePrompt",
        "TelescopeResults",
        "telescope",
        "Fyler",
    },
    ignore_buftypes = {
        "nofile",
        "terminal",
        "help",
        "quickfix",
        "prompt",
    },
}

--- Merge user configuration with defaults
--- @param user_config? Config
--- @return Config
function M.setup(user_config)
    if user_config then
        return vim.tbl_deep_extend("force", M.defaults, user_config)
    end
    return vim.deepcopy(M.defaults)
end

--- Validate configuration
--- @param config Config
--- @return boolean, string?
function M.validate(config)
    if type(config.min_padding) ~= "number" or config.min_padding < 0 then
        return false, "min_padding must be a non-negative number"
    end

    if type(config.min_window_width) ~= "number" or config.min_window_width < 10 then
        return false, "min_window_width must be at least 10"
    end

    if type(config.ignore_filetypes) ~= "table" then
        return false, "ignore_filetypes must be a table"
    end

    if type(config.ignore_buftypes) ~= "table" then
        return false, "ignore_buftypes must be a table"
    end

    return true, nil
end

return M
