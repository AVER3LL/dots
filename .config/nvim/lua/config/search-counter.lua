local api = vim.api
local fn = vim.fn
local M = {}

-- Configuration for the popup window
local config = {
    width_min = 20,
    border = "solid",
    highlight = "SCNormal",
    title_color = "SCTitle",
    border_color = "SCBorder",
}

local state = {
    buf = -1,
    win = -1,
    closing_timer = nil,
    augroup = api.nvim_create_augroup("SearchOverlay", { clear = true }),
}

-- --- Window Management ---

local function close_window()
    local win_id = state.win
    state.win = -1

    -- Wrap in schedule to avoid E565 (Not allowed to change text or change window)
    if win_id ~= -1 then
        vim.schedule(function()
            if api.nvim_win_is_valid(win_id) then
                api.nvim_win_close(win_id, true)
            end
        end)
    end
    -- Do not delete the buffer, reuse it to avoid allocation overhead
end

local function update_view(lines, title)
    -- If no lines provided, do nothing
    if not lines then
        return
    end
    if type(lines) == "string" then
        lines = { lines }
    end

    -- Create buffer if invalid
    if state.buf == -1 or not api.nvim_buf_is_valid(state.buf) then
        state.buf = api.nvim_create_buf(false, true) -- Scratch buffer
    end

    -- Set buffer content
    api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

    -- Calculate width based on content (clamped to min width)
    local content_width = 0
    for _, line in ipairs(lines) do
        content_width = math.max(content_width, #line)
    end
    local width = math.max(config.width_min, content_width + 2)

    -- Window configuration
    local win_opts = {
        relative = "editor",
        style = "minimal",
        border = config.border,
        row = 1, -- Top margin
        col = vim.o.columns,
        width = width,
        height = #lines,
        anchor = "NE", -- Anchor to North East (Top Right)
        title = title or " Search ",
        title_pos = "center",
        focusable = false,
        zindex = 200, -- Ensure it sits above other floats
    }

    -- Create or Update Window
    if state.win ~= -1 and api.nvim_win_is_valid(state.win) then
        api.nvim_win_set_config(state.win, win_opts)
    else
        state.win = api.nvim_open_win(state.buf, false, win_opts)
        -- Set highlighting for the popup
        api.nvim_set_option_value(
            "winhl",
            "Normal:"
                .. config.highlight
                .. ",FloatTitle:"
                .. config.title_color
                .. ",FloatBorder:"
                .. config.border_color,
            { win = state.win }
        )
    end
end

-- --- Logic ---

local function show_search_count()
    -- Schedule this to run after the search executes (next event loop)
    vim.schedule(function()
        local ok, count = pcall(fn.searchcount, { recompute = 1, maxcount = 9999, timeout = 500 })

        -- Guard against errors (e.g. invalid regex) or no search pattern
        if not ok or not count or count.total == nil then
            return
        end

        -- 1. Get the last searched term
        local search_pattern = fn.getreg "/"
        if search_pattern == "" then
            -- If the register is empty, try to get the current search term from hlsearch
            search_pattern = vim.v.hlsearch
        end

        local count_text = string.format(" (%d / %d) ", count.current, count.total)

        -- If count is 0, show explicitly
        if count.total == 0 then
            count_text = " No Matches "
        end

        -- Combine pattern and count
        local lines = {
            "Pattern: " .. search_pattern .. count_text,
        }

        update_view(lines, " Search ")

        -- Setup auto-close only when leaving normal mode (e.g., entering insert mode)
        -- CursorMoved is removed here to allow n/N jumps to keep the window open.
        local close_group = api.nvim_create_augroup("SearchOverlayClose", { clear = true })
        api.nvim_create_autocmd({ "InsertEnter" }, {
            group = close_group,
            callback = function()
                close_window()
                api.nvim_del_augroup_by_id(close_group)
            end,
        })
    end)
end

-- --- Public API ---

-- Manually close the window (useful for mapping to Esc or :nohlsearch)
function M.clear()
    close_window()
end

-- --- Setup ---

function M.setup()
    -- 1. Handle live typing in Command Mode
    api.nvim_create_autocmd("CmdlineChanged", {
        group = state.augroup,
        callback = function()
            local cmd_type = fn.getcmdtype()
            -- Only trigger for search commands (/ or ?)
            if cmd_type == "/" or cmd_type == "?" then
                local cmd_line = "Pattern: " .. fn.getcmdline()
                update_view(cmd_line, " Search ")
            end
        end,
    })

    -- 2. Open window immediately upon entering search mode
    api.nvim_create_autocmd("CmdlineEnter", {
        group = state.augroup,
        callback = function()
            local cmd_type = fn.getcmdtype()
            if cmd_type == "/" or cmd_type == "?" then
                update_view("", " Search ")
            end
        end,
    })

    -- 3. Handle Leave (Pressing Enter) -> Show Count
    api.nvim_create_autocmd("CmdlineLeave", {
        group = state.augroup,
        callback = function()
            local cmd_type = fn.getcmdtype()
            if cmd_type == "/" or cmd_type == "?" then
                -- Check if we actually searched (Enter) or aborted (Esc)
                if vim.v.event.abort == false then
                    show_search_count()
                else
                    close_window()
                end
            end
        end,
    })

    -- 4. Handle star (*) search
    vim.keymap.set("n", "*", function()
        -- Perform the normal star search
        vim.cmd "normal! *"
        -- Show the count immediately
        show_search_count()
    end, { desc = "Search word under cursor and show count overlay" })

    -- Handle hash (#) search similarly if desired
    vim.keymap.set("n", "#", function()
        vim.cmd "normal! #"
        show_search_count()
    end, { desc = "Search word backwards and show count overlay" })

    -- 5. Handle n/N jumps to UPDATE the count and KEEP the window open (New logic)
    vim.keymap.set("n", "n", function()
        vim.cmd "normal! n"
        show_search_count()
        return "zz"
    end, { desc = "Next match and update search overlay count" })

    vim.keymap.set("n", "N", function()
        vim.cmd "normal! N"
        show_search_count()
        return "zz"
    end, { desc = "Previous match and update search overlay count" })
end

return M
