-- Collection of pickers of functions helpful for Laravel
local create_picker = require("config.laravel.utils").create_picker

local M = {}
local snacks = require "snacks"

local pickers = {
    controllers = {
        label = "Controllers",
        patterns = { "app/Http/Controllers/**/*.php" },
        filter = function(name)
            return name ~= "Controller"
        end,
        truncate = "app/Http/Controllers",
    },

    models = {
        label = "Models",
        patterns = { "app/Models/**/*.php", "app/*.php" },
        filter = nil,
        truncate = "app/Models",
    },

    migrations = {
        label = "Migrations",
        patterns = { "database/migrations/**/*.php" },
        truncate = "database/migrations",
    },

    views = {
        label = "Views",
        patterns = { "resources/views/**/*.blade.php" },
        truncate = "resources/views",
    },

    routes = {
        label = "Route Files",
        patterns = { "routes/**/*.php" },
        truncate = "routes",
    },

    commands = {
        label = "Artisan Commands",
        patterns = { "app/Console/Commands/**/*.php" },
        truncate = "app/Console/Commands",
    },

    middleware = {
        label = "Middleware",
        patterns = { "app/Http/Middleware/**/*.php" },
        truncate = "app/Http/Middleware",
    },

    requests = {
        label = "Form Requests",
        patterns = { "app/Http/Requests/**/*.php" },
        truncate = "app/Http/Requests",
    },

    resources = {
        label = "API Resources",
        patterns = { "app/Http/Resources/**/*.php" },
        truncate = "app/Http/Resources",
    },

    jobs = {
        label = "Jobs",
        patterns = { "app/Jobs/**/*.php" },
        truncate = "app/Jobs",
    },

    events = {
        label = "Events",
        patterns = { "app/Events/**/*.php" },
        truncate = "app/Events",
    },

    listeners = {
        label = "Event Listeners",
        patterns = { "app/Listeners/**/*.php" },
        truncate = "app/Listeners",
    },

    policies = {
        label = "Policies",
        patterns = { "app/Policies/**/*.php" },
        truncate = "app/Policies",
    },

    providers = {
        label = "Service Providers",
        patterns = { "app/Providers/**/*.php" },
        truncate = "app/Providers",
    },

    config = {
        label = "Configuration Files",
        patterns = { "config/*.php" },
        truncate = "config",
    },

    lang = {
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
        label = "Factories",
        patterns = { "database/factories/**/*.php" },
        truncate = "database/factories",
    },

    seeders = {
        label = "Seeders",
        patterns = { "database/seeders/**/*.php" },
        truncate = "database/seeders",
    },

    tests = {
        label = "Tests",
        patterns = { "tests/**/*.php" },
        truncate = "tests",
    },
}

for key, cfg in pairs(pickers) do
    M["find_" .. key] = function()
        create_picker(cfg.label, cfg.patterns, cfg.filter, cfg.truncate)
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
        })
    end

    snacks.picker.pick {
        name = "Laravel File Types",
        layout = "vscode",
        items = items,
        format = function(item)
            return { { item.text, "SnacksPickerFile" } }
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
