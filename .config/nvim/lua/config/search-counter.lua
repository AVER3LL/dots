-- Search counter with virtual text display
local M = {}

-- Namespace for virtual text
local ns_id = vim.api.nvim_create_namespace "search_counter"

-- Function to get search pattern and count matches
local function get_search_info()
    local search_pattern = vim.fn.getreg "/"
    if search_pattern == "" then
        return nil
    end

    -- Get total matches in current buffer
    local total_matches = vim.fn.searchcount({ maxcount = 0 }).total
    if total_matches == 0 then
        return nil
    end

    -- Get current match position
    local current_match = vim.fn.searchcount().current

    return {
        pattern = search_pattern,
        current = current_match,
        total = total_matches,
    }
end

-- Track the last match position to avoid unnecessary updates
local last_match_line = nil
local last_match_count = nil

-- Function to check if current line contains a match
local function current_line_has_match()
    local search_pattern = vim.fn.getreg "/"
    if search_pattern == "" then
        return false
    end

    local current_line_text = vim.fn.getline "."
    -- Use vim's search function to check if pattern matches on current line
    return vim.fn.match(current_line_text, search_pattern) ~= -1
end

-- Function to display search counter as virtual text
local function show_search_counter()
    -- Clear existing virtual text
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

    local search_info = get_search_info()
    if not search_info then
        return
    end

    local current_line = vim.fn.line "." - 1 -- Convert to 0-based indexing
    local text = string.format("[%d/%d]", search_info.current, search_info.total)

    -- Only show if current line has a match
    if current_line_has_match() then
        -- Add virtual text at the end of current line
        vim.api.nvim_buf_set_extmark(0, ns_id, current_line, 0, {
            virt_text = { { text, "Comment" } },
            virt_text_pos = "eol",
            priority = 100,
        })

        -- Update tracking variables
        last_match_line = current_line
        last_match_count = search_info.current
    end
end

-- Function to update search counter only when we're on a match line
local function update_search_counter()
    local search_info = get_search_info()
    if not search_info then
        return
    end

    local current_line = vim.fn.line "." - 1

    -- Only update if:
    -- 1. We're on a line with a match, AND
    -- 2. Either the line changed OR the match count changed (meaning we moved to a different match)
    if current_line_has_match() and (current_line ~= last_match_line or search_info.current ~= last_match_count) then
        show_search_counter()
    elseif not current_line_has_match() and last_match_line ~= nil then
        -- Clear the counter if we moved away from a match line
        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        last_match_line = nil
        last_match_count = nil
    end
end

-- Set up autocommands for search events
local function setup_autocommands()
    local group = vim.api.nvim_create_augroup("SearchCounter", { clear = true })

    -- Show counter when search is performed
    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = group,
        pattern = "/,\\?",
        callback = function()
            vim.defer_fn(show_search_counter, 50) -- Small delay to ensure search is complete
        end,
    })

    -- Update counter when using n/N
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        callback = function()
            -- Only update if we're in a search context
            if vim.v.hlsearch == 1 and vim.fn.getreg "/" ~= "" then
                update_search_counter()
            end
        end,
    })

    -- Clear counter when search highlighting is turned off
    vim.api.nvim_create_autocmd("OptionSet", {
        group = group,
        pattern = "hlsearch",
        callback = function()
            if vim.v.hlsearch == 0 then
                vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
                last_match_line = nil
                last_match_count = nil
            end
        end,
    })
end

-- Enhanced n and N mappings
local function setup_mappings()
    -- Enhanced 'n' - next match
    vim.keymap.set("n", "n", function()
        vim.cmd "normal! n"
        show_search_counter()
    end, { desc = "Next search match with counter" })

    -- Enhanced 'N' - previous match
    vim.keymap.set("n", "N", function()
        vim.cmd "normal! N"
        show_search_counter()
    end, { desc = "Previous search match with counter" })

    -- Optional: Show counter on * and #
    vim.keymap.set("n", "*", function()
        vim.cmd "normal! *"
        show_search_counter()
    end, { desc = "Search word under cursor forward with counter" })

    vim.keymap.set("n", "#", function()
        vim.cmd "normal! #"
        show_search_counter()
    end, { desc = "Search word under cursor backward with counter" })

    -- Map Esc to clear search highlights and counter
    vim.keymap.set("n", "<Esc>", function()
        vim.cmd "nohlsearch"
        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        last_match_line = nil
        last_match_count = nil
    end, { desc = "Clear search highlights and counter" })
end

-- Setup function to initialize everything
function M.setup(opts)
    opts = opts or {}

    -- Allow customization of highlight group
    local highlight = opts.highlight or "Comment"

    -- Override the show function if custom highlight is provided
    if opts.highlight then
        show_search_counter = function()
            vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

            local search_info = get_search_info()
            if not search_info then
                return
            end

            local current_line = vim.fn.line "." - 1
            local text = string.format("[%d/%d]", search_info.current, search_info.total)

            -- Only show if current line has a match
            if current_line_has_match() then
                vim.api.nvim_buf_set_extmark(0, ns_id, current_line, 0, {
                    virt_text = { { text, highlight } },
                    virt_text_pos = "eol",
                    priority = 100,
                })

                -- Update tracking variables
                last_match_line = current_line
                last_match_count = search_info.current
            end
        end
    end

    setup_autocommands()
    setup_mappings()
end

-- Manual trigger function (optional)
function M.show_counter()
    show_search_counter()
end

-- Function to clear search counter
function M.clear_counter()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    last_match_line = nil
    last_match_count = nil
end

return M
