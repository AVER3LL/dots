-- Factory and Seeder references: User::factory() → database/factories/UserFactory.php
local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    -- Pattern 1: Model factory calls
    local factory_patterns = {
        "([%w]+)::factory%s*%(",
        "factory%s*%(%s*([%w]+)::class",
        "create%s*%(%s*([%w]+Factory)",
    }

    for _, pattern in ipairs(factory_patterns) do
        local factory_match = line:match(pattern)
        if factory_match then
            local factory_name = factory_match:match "Factory$" and factory_match or (factory_match .. "Factory")
            local factory_file = laravel_root .. "/database/factories/" .. factory_name .. ".php"

            if vim.fn.filereadable(factory_file) == 1 then
                table.insert(results, {
                    file = factory_file,
                    description = "Factory: " .. factory_name,
                    type = "factory",
                })
            end
        end
    end

    -- Pattern 2: Seeder calls
    local seeder_patterns = {
        "->call%s*%(%s*([%w]+Seeder)",
        "->call%s*%(%s*['\"]([%w]+Seeder)['\"]",
        "Artisan::call%s*%(%s*['\"]db:seed['\"].*--class=([%w]+Seeder)",
    }

    for _, pattern in ipairs(seeder_patterns) do
        local seeder_match = line:match(pattern)
        if seeder_match then
            local seeder_file = laravel_root .. "/database/seeders/" .. seeder_match .. ".php"
            if vim.fn.filereadable(seeder_file) == 1 then
                table.insert(results, {
                    file = seeder_file,
                    description = "Seeder: " .. seeder_match,
                    type = "seeder",
                })
            end
        end
    end

    -- Pattern 3: Database seeder references
    if quoted_content and quoted_content:match "Seeder$" then
        local seeder_file = laravel_root .. "/database/seeders/" .. quoted_content .. ".php"
        if vim.fn.filereadable(seeder_file) == 1 then
            table.insert(results, {
                file = seeder_file,
                description = "Seeder: " .. quoted_content,
                type = "seeder",
            })
        end
    end

    return results
end

return M
