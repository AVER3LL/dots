-- Environment variables: env('APP_NAME') → .env file

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "env%s*%(" then
        local env_files = {
            laravel_root .. "/.env",
            laravel_root .. "/.env.local",
            laravel_root .. "/.env.example",
        }

        for _, env_file in ipairs(env_files) do
            if vim.fn.filereadable(env_file) == 1 then
                local line_num = nil
                -- Try to find the specific environment variable
                local content = vim.fn.readfile(env_file)
                local env_pattern = "^" .. vim.pesc(quoted_content) .. "%s*="
                for i, file_line in ipairs(content) do
                    if file_line:match(env_pattern) then
                        line_num = i
                        break
                    end
                end

                table.insert(results, {
                    file = env_file,
                    line = line_num,
                    description = "Environment variable: " .. quoted_content,
                    type = "env",
                })
                break
            end
        end
    end

    return results
end

return M
