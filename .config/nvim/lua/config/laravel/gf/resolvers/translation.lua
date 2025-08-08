-- Translation references: __('auth.failed') → lang/en/auth.php

local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    if line:match "__%s*%(" or line:match "trans%s*%(" or line:match "@lang%s*%(" then
        local trans_parts = vim.split(quoted_content, ".", { plain = true })
        if #trans_parts >= 2 then
            local lang_file = trans_parts[1] .. ".php"
            local lang_dirs = {
                laravel_root .. "/lang/en/",
                laravel_root .. "/resources/lang/en/",
                laravel_root .. "/lang/",
                laravel_root .. "/resources/lang/",
            }

            for _, lang_dir in ipairs(lang_dirs) do
                local full_path = lang_dir .. lang_file
                if vim.fn.filereadable(full_path) == 1 then
                    local line_num = nil
                    if #trans_parts > 1 then
                        -- Try to find the specific translation key
                        local content = vim.fn.readfile(full_path)
                        local key_pattern = "['\"]" .. vim.pesc(trans_parts[2]) .. "['\"]%s*=>"
                        for i, file_line in ipairs(content) do
                            if file_line:match(key_pattern) then
                                line_num = i
                                break
                            end
                        end
                    end

                    table.insert(results, {
                        file = full_path,
                        line = line_num,
                        description = "Translation: " .. quoted_content,
                        type = "translation",
                    })
                    break
                end
            end
        end
    end
    return results
end

return M
