-- Collection of pickers of functions helpful for Laravel
local create_picker = require("config.laravel.utils").create_picker
local utils = require "config.laravel.utils"

local M = {}
local snacks = require "snacks"

local pickers = {
    controllers = {
        key = "controller",
        label = "Controllers",
        patterns = { "app/Http/Controllers/**/*.php" },
        filter = function(name)
            return name ~= "Controller"
        end,
        truncate = "app/Http/Controllers",
    },

    models = {
        key = "model",
        label = "Models",
        patterns = { "app/Models/**/*.php", "app/*.php" },
        filter = nil,
        truncate = "app/Models",
    },

    migrations = {
        key = "migration",
        label = "Migrations",
        patterns = { "database/migrations/**/*.php" },
        truncate = "database/migrations",
    },

    views = {
        key = "view",
        label = "Views",
        patterns = { "resources/views/**/*.blade.php" },
        truncate = "resources/views",
    },

    routes = {
        key = "route",
        label = "Route Files",
        patterns = { "routes/**/*.php" },
        truncate = "routes",
    },

    commands = {
        key = "command",
        label = "Artisan Commands",
        patterns = { "app/Console/Commands/**/*.php" },
        truncate = "app/Console/Commands",
    },

    middleware = {
        key = "middleware",
        label = "Middleware",
        patterns = { "app/Http/Middleware/**/*.php" },
        truncate = "app/Http/Middleware",
    },

    requests = {
        key = "request",
        label = "Form Requests",
        patterns = { "app/Http/Requests/**/*.php" },
        truncate = "app/Http/Requests",
    },

    resources = {
        key = "resource",
        label = "API Resources",
        patterns = { "app/Http/Resources/**/*.php" },
        truncate = "app/Http/Resources",
    },

    jobs = {
        key = "job",
        label = "Jobs",
        patterns = { "app/Jobs/**/*.php" },
        truncate = "app/Jobs",
    },

    events = {
        key = "event",
        label = "Events",
        patterns = { "app/Events/**/*.php" },
        truncate = "app/Events",
    },

    listeners = {
        key = "listener",
        label = "Event Listeners",
        patterns = { "app/Listeners/**/*.php" },
        truncate = "app/Listeners",
    },

    policies = {
        key = "policy",
        label = "Policies",
        patterns = { "app/Policies/**/*.php" },
        truncate = "app/Policies",
    },

    providers = {
        key = "provider",
        label = "Service Providers",
        patterns = { "app/Providers/**/*.php" },
        truncate = "app/Providers",
    },

    config = {
        key = "config",
        label = "Configuration Files",
        patterns = { "config/*.php" },
        truncate = "config",
    },

    lang = {
        key = "lang",
        label = "Language Files",
        patterns = { "lang/**/*.php", "resources/lang/**/*.php" },
        truncate = function(path)
            if path:match "^lang/" then
                return "lang"
            else
                return "resources/lang"
            end
        end,
    },

    factories = {
        key = "factory",
        label = "Factories",
        patterns = { "database/factories/**/*.php" },
        truncate = "database/factories",
    },

    seeders = {
        key = "seeder",
        label = "Seeders",
        patterns = { "database/seeders/**/*.php" },
        truncate = "database/seeders",
    },

    tests = {
        key = "test",
        label = "Tests",
        patterns = { "tests/**/*.php" },
        truncate = "tests",
    },
}

for key, cfg in pairs(pickers) do
    M["find_" .. key] = function()
        create_picker(cfg.label, cfg.patterns, cfg.filter, cfg.truncate, cfg.key)
    end
end

M.find_all = function()
    local items = {}
    for key, cfg in pairs(pickers) do
        table.insert(items, {
            name = cfg.label,
            fn = M["find_" .. key],
            text = cfg.label,
            search_key = cfg.label,
            pretty = utils.icons[cfg.key],
        })
    end

    snacks.picker.pick {
        name = "Laravel File Types",
        layout = "vscode",
        items = items,
        format = function(item)
            return {
                { item.pretty.icon .. " ", item.pretty.hl },
                { item.text, "SnacksPickerFile" },
            }
        end,
        confirm = function(picker, item)
            if item then
                picker:close()
                vim.defer_fn(item.fn, 10)
            end
        end,
    }
end

return M
