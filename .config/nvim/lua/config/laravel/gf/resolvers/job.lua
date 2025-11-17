-- Job references: dispatch(new ProcessPodcast()) → app/Jobs/ProcessPodcast.php
local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    -- Pattern 1: Job dispatching with new keyword
    local job_patterns = {
        "dispatch%s*%(%s*new%s+([%w\\]+)",
        "Dispatchable::dispatch%s*%(%s*new%s+([%w\\]+)",
        "dispatch%s*%(%s*new%s+\\([%w\\]+)",
    }

    for _, pattern in ipairs(job_patterns) do
        local job_match = line:match(pattern)
        if job_match then
            -- Handle namespaced jobs
            local job_name = job_match:gsub("\\", "/")
            local job_file = laravel_root .. "/app/Jobs/" .. job_name .. ".php"

            if vim.fn.filereadable(job_file) == 1 then
                table.insert(results, {
                    file = job_file,
                    description = "Job: " .. job_name,
                    type = "job",
                })
            end
        end
    end

    -- Pattern 2: Static dispatch calls like ProcessPodcast::dispatch()
    if quoted_content then
        local job_file = laravel_root .. "/app/Jobs/" .. quoted_content .. ".php"
        if vim.fn.filereadable(job_file) == 1 then
            table.insert(results, {
                file = job_file,
                description = "Job: " .. quoted_content,
                type = "job",
            })
        end
    end

    return results
end

return M