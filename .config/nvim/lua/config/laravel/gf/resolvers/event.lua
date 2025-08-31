-- Event and Listener references: event(new UserRegistered()) → app/Events/UserRegistered.php
local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    -- Pattern 1: Event dispatching
    local event_patterns = {
        "event%s*%(%s*new%s+([%w]+)",
        "Event::dispatch%s*%(%s*new%s+([%w]+)",
        "broadcast%s*%(%s*new%s+([%w]+)",
    }

    for _, pattern in ipairs(event_patterns) do
        local event_match = line:match(pattern)
        if event_match then
            local event_file = laravel_root .. "/app/Events/" .. event_match .. ".php"
            if vim.fn.filereadable(event_file) == 1 then
                table.insert(results, {
                    file = event_file,
                    description = "Event: " .. event_match,
                    type = "event",
                })
            end
        end
    end

    -- Pattern 2: Listener references in EventServiceProvider
    if quoted_content and line:match "=>" then
        -- Check if this might be a listener class
        if quoted_content:match "Listener$" then
            local listener_file = laravel_root .. "/app/Listeners/" .. quoted_content .. ".php"
            if vim.fn.filereadable(listener_file) == 1 then
                table.insert(results, {
                    file = listener_file,
                    description = "Listener: " .. quoted_content,
                    type = "listener",
                })
            end
        end
    end

    return results
end

return M
