-- Config references: config('app.name') → config/app.php

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "config%s*%(" then
        local config_parts = vim.split(quoted_content, ".", { plain = true })
        if #config_parts > 0 then
            local config_file = laravel_root .. "/config/" .. config_parts[1] .. ".php"
            if vim.fn.filereadable(config_file) == 1 then
                local line_num = nil
                if #config_parts > 1 then
                    -- Try to find the specific config key
                    local content = vim.fn.readfile(config_file)
                    local key_pattern = "['\"]" .. vim.pesc(config_parts[2]) .. "['\"]%s*=>"
                    for i, file_line in ipairs(content) do
                        if file_line:match(key_pattern) then
                            line_num = i
                            break
                        end
                    end
                end

                table.insert(results, {
                    file = config_file,
                    line = line_num,
                    description = "Config: " .. quoted_content,
                    type = "config",
                })
            end
        end
    end

    return results
end

return M
