local M = {
    require "config.laravel.gf.resolvers.routes",
    require "config.laravel.gf.resolvers.inertia",
    require "config.laravel.gf.resolvers.view",
    require "config.laravel.gf.resolvers.volt",
    require "config.laravel.gf.resolvers.component",
    require "config.laravel.gf.resolvers.livewire",
    require "config.laravel.gf.resolvers.config",
    require "config.laravel.gf.resolvers.env",
    require "config.laravel.gf.resolvers.asset",
    require "config.laravel.gf.resolvers.model",
    require "config.laravel.gf.resolvers.translation",
    require "config.laravel.gf.resolvers.storage_path",
    require "config.laravel.gf.resolvers.storage_url",
}

return M
