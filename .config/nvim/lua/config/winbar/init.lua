--- @class CustomWinBar
--- @field config Config
--- @field update_winbar fun(is_active: boolean)
--- @field setup fun(user_config: Config|nil)
--- @field refresh_all_windows fun()

-- Import modules
local autocmds = require "config.winbar.autocmds"
local config_module = require "config.winbar.config"
local updater = require "config.winbar.updater"

local M = {}

--- Update the winbar (public interface)
--- @param is_active boolean
function M.update_winbar(is_active)
    if not M.config then
        vim.notify("CustomWinBar not initialized. Call setup() first.", vim.log.levels.ERROR)
        return
    end
    updater.update_winbar(M.config, is_active)
end

--- Public function to refresh all windows
function M.refresh_all_windows()
    if not M.config then
        vim.notify("CustomWinBar not initialized. Call setup() first.", vim.log.levels.ERROR)
        return
    end
    vim.schedule(function()
        updater.update_all_visible_windows(M.config)
    end)
end

--- Setup function
--- @param user_config? Config
function M.setup(user_config)
    -- Setup configuration
    M.config = config_module.setup(user_config)

    -- Validate configuration
    local valid, error_msg = config_module.validate(M.config)
    if not valid then
        vim.notify("CustomWinBar config error: " .. error_msg, vim.log.levels.ERROR)
        return
    end

    -- Setup autocommands
    autocmds.setup_autocmds(M.config)
end

--- @module 'custom-winbar'
--- @type CustomWinBar
return M
