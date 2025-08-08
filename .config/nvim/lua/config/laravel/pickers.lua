--- Collection of pickers of functions helpful for Laravel
local create_picker = require("config.laravel.utils").create_picker

local M = {}

local snacks = require "snacks"

M.find_controllers = function()
    create_picker("Laravel Controllers", {
        "app/Http/Controllers/**/*.php",
        "app/Http/Controllers/*.php",
    }, function(name)
        return name ~= "Controller"
    end, "app/Http/Controllers")
end

M.find_models = function()
    create_picker("Laravel Models", {
        "app/Models/*.php",
        "app/*.php",
    }, nil, "app/Models")
end

M.find_migrations = function()
    create_picker("Laravel Migrations", {
        "database/migrations/*.php",
    }, nil, "database/migrations")
end

M.find_views = function()
    create_picker("Blade Views", {
        "resources/views/**/*.blade.php",
    }, nil, "resources/views")
end

M.find_routes = function()
    create_picker("Routes Files", {
        "routes/*.php",
    }, nil, "routes")
end

M.find_commands = function()
    create_picker("Custom Artisan Commands", {
        "app/Console/Commands/*.php",
    }, nil, "app/Console/Commands")
end

M.find_middleware = function()
    create_picker("Middleware", {
        "app/Http/Middleware/*.php",
    }, nil, "app/Http/Middleware")
end

M.find_requests = function()
    create_picker("Form Requests", {
        "app/Http/Requests/**/*.php",
        "app/Http/Requests/*.php",
    }, nil, "app/Http/Requests")
end

M.find_resources = function()
    create_picker("API Resources", {
        "app/Http/Resources/**/*.php",
        "app/Http/Resources/*.php",
    }, nil, "app/Http/Resources")
end

M.find_jobs = function()
    create_picker("Queue Jobs", {
        "app/Jobs/*.php",
    }, nil, "app/Jobs")
end

M.find_events = function()
    create_picker("Events", {
        "app/Events/*.php",
    }, nil, "app/Events")
end

M.find_listeners = function()
    create_picker("Event Listeners", {
        "app/Listeners/*.php",
    }, nil, "app/Listeners")
end

M.find_policies = function()
    create_picker("Policies", {
        "app/Policies/*.php",
    }, nil, "app/Policies")
end

M.find_providers = function()
    create_picker("Service Providers", {
        "app/Providers/*.php",
    }, nil, "app/Providers")
end

M.find_config = function()
    create_picker("Configuration Files", {
        "config/*.php",
    }, nil, "config")
end

M.find_lang = function()
    create_picker(
        "Language Files",
        {
            "lang/**/*.php",
            "resources/lang/**/*.php",
        },
        nil,
        function(path)
            if path:match "^lang/" then
                return "lang"
            else
                return "resources/lang"
            end
        end
    )
end

M.find_factories = function()
    create_picker("Model Factories", {
        "database/factories/*.php",
    }, nil, "database/factories")
end

M.find_seeders = function()
    create_picker("Database Seeders", {
        "database/seeders/*.php",
    }, nil, "database/seeders")
end

M.find_all = function()
    local pickers = {
        {
            name = "Commands",
            fn = function()
                M.find_commands()
            end,
            text = "Commands",
            search_key = "Commands",
        },
        {
            name = "Config",
            fn = function()
                M.find_config()
            end,
            text = "Config",
            search_key = "Config",
        },
        {
            name = "Controllers",
            fn = function()
                M.find_controllers()
            end,
            text = "Controllers",
            search_key = "Controllers",
        },
        {
            name = "Jobs",
            fn = function()
                M.find_jobs()
            end,
            text = "Jobs",
            search_key = "Jobs",
        },
        {
            name = "Middleware",
            fn = function()
                M.find_middleware()
            end,
            text = "Middleware",
            search_key = "Middleware",
        },
        {
            name = "Migrations",
            fn = function()
                M.find_migrations()
            end,
            text = "Migrations",
            search_key = "Migrations",
        },
        {
            name = "Models",
            fn = function()
                M.find_models()
            end,
            text = "Models",
            search_key = "Models",
        },
        {
            name = "Requests",
            fn = function()
                M.find_requests()
            end,
            text = "Requests",
            search_key = "Requests",
        },
        {
            name = "Resources",
            fn = function()
                M.find_resources()
            end,
            text = "Resources",
            search_key = "Resources",
        },
        {
            name = "Routes",
            fn = function()
                M.find_routes()
            end,
            text = "Routes",
            search_key = "Routes",
        },
        {
            name = "Seeders",
            fn = function()
                M.find_seeders()
            end,
            text = "Seeders",
            search_key = "Seeders",
        },
        {
            name = "Tests",
            fn = function()
                M.find_tests()
            end,
            text = "Tests",
            search_key = "Tests",
        },
        {
            name = "Views",
            fn = function()
                M.find_views()
            end,
            text = "Views",
            search_key = "Views",
        },
    }

    snacks.picker.pick {
        name = "Laravel File Types",
        layout = "vscode",
        items = pickers,
        format = function(item)
            return { { item.text, "SnacksPickerFile" } }
        end,
        confirm = function(picker, item)
            if item then
                picker:close()
                -- Small delay to ensure the picker is fully closed before opening the next one
                vim.defer_fn(function()
                    item.fn()
                end, 10)
            end
        end,
    }
end

return M
