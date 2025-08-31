-- Policy references: $this->authorize('update', $post) → app/Policies/PostPolicy.php
local M = {}

M.resolve = function(line, laravel_root, quoted_content)
    local results = {}

    if not quoted_content then
        return results
    end

    -- Match policy-related functions
    local policy_patterns = {
        "->authorize%s*%(",
        "->can%s*%(",
        "->cannot%s*%(",
        "Gate::allows%s*%(",
        "Gate::denies%s*%(",
        "@can%s*%(",
        "@cannot%s*%(",
    }

    local is_policy_line = false
    for _, pattern in ipairs(policy_patterns) do
        if line:match(pattern) then
            is_policy_line = true
            break
        end
    end

    if not is_policy_line then
        return results
    end

    -- Extract policy name from common patterns
    local policy_name = quoted_content

    -- Try to infer policy from context if it's a simple action
    local common_actions = {
        "view",
        "viewAny",
        "create",
        "update",
        "delete",
        "restore",
        "forceDelete",
    }

    -- If it's just an action name, try to find the model context
    if vim.tbl_contains(common_actions, policy_name) then
        -- Look for model variable in the same line
        local model_var = line:match "%$([%w_]+)"
        if model_var then
            -- Convert variable name to policy name (e.g., $post -> PostPolicy)
            local inferred_policy = model_var:gsub("^%l", string.upper) .. "Policy"
            local policy_file = laravel_root .. "/app/Policies/" .. inferred_policy .. ".php"

            if vim.fn.filereadable(policy_file) == 1 then
                -- Try to find the specific method
                local line_num = nil
                local content = vim.fn.readfile(policy_file)
                local method_pattern = "function%s+" .. policy_name .. "%s*%("

                for i, file_line in ipairs(content) do
                    if file_line:match(method_pattern) then
                        line_num = i
                        break
                    end
                end

                table.insert(results, {
                    file = policy_file,
                    line = line_num,
                    description = "Policy: " .. inferred_policy .. " (method: " .. policy_name .. ")",
                    type = "policy",
                })
            end
        end
    else
        -- Direct policy name reference
        local policy_file = laravel_root .. "/app/Policies/" .. policy_name .. "Policy.php"
        if vim.fn.filereadable(policy_file) == 1 then
            table.insert(results, {
                file = policy_file,
                description = "Policy: " .. policy_name .. "Policy",
                type = "policy",
            })
        end
    end

    return results
end

return M
