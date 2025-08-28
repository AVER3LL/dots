local M = {}
---@class InclineRenderProps
---@field buf number
---@field win number
---@field focused boolean

---@param props InclineRenderProps
M.search_count = function(props)
    if not props.focused then
        return nil
    end

    -- Check if search highlighting is enabled (did we call :noh)
    if vim.v.hlsearch == 0 then
        return nil
    end

    local count = vim.fn.searchcount { recompute = 1, maxcount = -1 }
    local contents = vim.fn.getreg "/"
    if string.len(contents) == 0 then
        return ""
    end
    return {
        {
            " ? ",
            group = "dkoStatusKey",
        },
        {
            (" %s "):format(contents),
            group = "IncSearch",
        },
        {
            (" %d/%d "):format(count.current, count.total),
            group = "dkoStatusValue",
        },
    }
end

---@param props InclineRenderProps
M.location = function(props)
    -- if not props.focused then
    --     return nil
    -- end

    local ok, navic = pcall(require, "nvim-navic")
    local res = { " " }

    if ok then
        for index, item in ipairs(navic.get_data(props.buf) or {}) do
            local to_insert = {
                { item.icon, group = "NavicIcons" .. item.type },
                { item.name, group = "NavicText" },
            }

            if index ~= 1 then
                table.insert(to_insert, 1, { " > ", group = "NavicSeparator" })
            end

            table.insert(res, to_insert)
        end

        table.insert(res, " ")
    end

    if #res == 2 then
        return nil
    end

    -- if res is empty, return nil

    return res
end

return M
