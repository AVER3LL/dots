local bo = vim.bo

local M = {}

--- Check if current buffer should be ignored
--- @param config Config
--- @return boolean
function M.should_ignore_buffer(config)
    local filetype = bo.filetype
    local buftype = bo.buftype
    return vim.list_contains(config.ignore_filetypes, filetype) or vim.tbl_contains(config.ignore_buftypes, buftype)
end

--- Check if buffer is modified
--- @return boolean
function M.is_modified()
    return bo.modified
end

--- Get buffer filetype
--- @return string
function M.get_filetype()
    return bo.filetype
end

--- Get buffer type
--- @return string
function M.get_buftype()
    return bo.buftype
end

return M
