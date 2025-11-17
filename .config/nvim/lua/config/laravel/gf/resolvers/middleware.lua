-- Middleware references: middleware('auth') → app/Http/Middleware/Authenticate.php
local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    -- Pattern 1: Route middleware
    if line:match "middleware%s*%(" then
        -- Handle both string and array middleware
        local middleware_names = {}

        -- Extract single middleware
        if quoted_content then
            table.insert(middleware_names, quoted_content)
        end

        -- Extract array middleware (middleware(['auth', 'verified']))
        local array_match = line:match("middleware%s*%(%s*%[([^%]]+)%]")
        if array_match then
            for middleware in array_match:gmatch("'([^']+)'") do
                table.insert(middleware_names, middleware)
            end
            for middleware in array_match:gmatch('"([^"]+)"') do
                table.insert(middleware_names, middleware)
            end
        end

        for _, middleware_name in ipairs(middleware_names) do
            -- Convert common middleware names to class names
            local class_name_map = {
                auth = "Authenticate",
                guest = "RedirectIfAuthenticated",
                verified = "EnsureEmailIsVerified",
                throttle = "ThrottleRequests",
                substitute = "SubstituteBindings",
                ["api"] = "Authenticate",
            }

            local class_name = class_name_map[middleware_name] or middleware_name:gsub("^%l", string.upper):gsub("[-_](%w)", function(c) return c:upper() end) .. "Middleware"

            local middleware_file = laravel_root .. "/app/Http/Middleware/" .. class_name .. ".php"
            if vim.fn.filereadable(middleware_file) == 1 then
                table.insert(results, {
                    file = middleware_file,
                    description = "Middleware: " .. class_name,
                    type = "middleware",
                })
            end
        end
    end

    -- Pattern 2: Middleware alias references in Kernel.php
    if line:match "=>" and quoted_content then
        -- Look for middleware aliases in route middleware array
        local alias_pattern = "['\"]" .. vim.pesc(quoted_content) .. "['\"]%s*=>"
        if line:match(alias_pattern) then
            -- This might be a middleware alias definition
            local kernel_file = laravel_root .. "/app/Http/Kernel.php"
            if vim.fn.filereadable(kernel_file) == 1 then
                table.insert(results, {
                    file = kernel_file,
                    description = "Middleware Alias: " .. quoted_content .. " (in Kernel.php)",
                    type = "middleware-alias",
                })
            end
        end
    end

    return results
end

return M