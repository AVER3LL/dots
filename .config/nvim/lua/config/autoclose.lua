-- Autoclose configuration for Neovim

local M = {}

-- Default configuration
local default_config = {
    -- Pairs to auto-close
    pairs = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
        ["'"] = "'",
        ['"'] = '"',
        ["`"] = "`",
    },
    -- Pairs to skip when already closed
    skip_pairs = {
        ["("] = ")",
        ["["] = "]",
        ["{"] = "}",
    },
    -- Filetypes to ignore
    ignore_filetypes = {
        "TelescopePrompt",
        "vim",
        "NvimTree",
    },
    -- Whether to disable in insert mode comments
    disable_in_comments = true,
    -- Whether to disable in strings
    disable_in_strings = false,
    -- Whether to disable when the cursor is not at the end of line
    disable_when_not_eol = false,
}

-- Current configuration
local config = {}

-- Check if current filetype should be ignored
local function should_ignore_filetype()
    local current_ft = vim.bo.filetype
    for _, ft in ipairs(config.ignore_filetypes) do
        if current_ft == ft then
            return true
        end
    end
    return false
end

-- Check if we're in a string or comment
local function in_string_or_comment()
    -- Return false if we're in an ignored filetype
    if should_ignore_filetype() then
        return false
    end

    -- Basic fallback if Treesitter is not available
    if not vim.treesitter then
        return false
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1 -- Convert to 0-based index

    -- Get the parser for the current buffer
    local parser = vim.treesitter.get_parser(bufnr)
    if not parser then
        return false
    end

    -- Get the tree and root
    local tree = parser:parse()[1]
    if not tree then
        return false
    end

    local root = tree:root()
    if not root then
        return false
    end

    -- Get the node at cursor position
    local node = root:named_descendant_for_range(row, col, row, col)
    if not node then
        return false
    end

    local type = node:type()
    local is_string = type == "string" or type == "string_content"
    local is_comment = type == "comment"

    return (is_string and config.disable_in_strings) or (is_comment and config.disable_in_comments)
end

-- Check if the next character matches the closing pair for the current character
local function is_matching_pair_ahead(open_char)
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local next_char = line:sub(col + 1, col + 1)

    -- Only return true if the next character exactly matches
    -- the closing pair for our current opening character
    return next_char == config.pairs[open_char]
end

-- Check if cursor is at end of line
local function is_at_eol()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    return col >= #line
end

-- Function to handle pair insertion
local function handle_pair(open)
    -- Check if we should ignore this filetype
    if should_ignore_filetype() then
        return open
    end

    -- Check if we should disable when not at EOL
    if config.disable_when_not_eol and not is_at_eol() then
        return open
    end

    -- Don't autoclose in strings or comments unless it's a quote
    if in_string_or_comment() and not (open == '"' or open == "'" or open == "`") then
        return open
    end

    -- Only skip if the next character exactly matches our closing pair
    if is_matching_pair_ahead(open) then
        return open
    end

    -- Insert the pair and move cursor back one character
    return open .. config.pairs[open] .. "<Left>"
end

-- Function to handle Enter between pairs
local function handle_enter()
    if should_ignore_filetype() then
        return "<CR>"
    end

    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = line:sub(col, col)
    local after = line:sub(col + 1, col + 1)

    -- Check if cursor is between pairs
    for o, c in pairs(config.pairs) do
        if before == o and after == c then
            -- Create new line with proper indentation
            return "<CR><CR><Up><Tab>"
        end
    end
    return "<CR>"
end

-- Function to handle Backspace between pairs
local function handle_backspace()
    if should_ignore_filetype() then
        return "<BS>"
    end

    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = line:sub(col, col)
    local after = line:sub(col + 1, col + 1)

    -- Check if cursor is between pairs
    for o, c in pairs(config.pairs) do
        if before == o and after == c then
            -- Delete both characters
            return "<BS><Del>"
        end
    end
    return "<BS>"
end

-- Main setup function
function M.setup(user_config)
    -- Merge user config with defaults
    config = vim.tbl_deep_extend("force", default_config, user_config or {})

    -- Create keymaps for each opening character
    for open, _ in pairs(config.pairs) do
        vim.keymap.set("i", open, function()
            return handle_pair(open)
        end, { expr = true, noremap = true })
    end

    -- Set up Enter keymap
    vim.keymap.set("i", "<CR>", handle_enter, { expr = true, noremap = true })

    -- Set up Backspace keymap
    vim.keymap.set("i", "<BS>", handle_backspace, { expr = true, noremap = true })
end

return M
