local M = {}

-- Helper function like lazy.nvim's Util.wo to handle deprecated API
function M.wo(win, k, v)
    if vim.api.nvim_set_option_value then
        vim.api.nvim_set_option_value(k, v, { scope = "local", win = win })
    else
        vim.wo[win][k] = v
    end
end

function M.create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf
    if opts.buf and type(opts.buf) == "number" and vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local backdrop_win = nil
    local backdrop_buf = nil

    -- Check if we can create a backdrop (same logic as lazy.nvim)
    local normal, has_bg
    normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    has_bg = normal and normal.bg ~= nil

    local backdrop_blend = opts.backdrop or 60

    -- Create backdrop if conditions are met (like lazy.nvim does)
    if has_bg and backdrop_blend < 100 and vim.o.termguicolors then
        backdrop_buf = vim.api.nvim_create_buf(false, true)
        backdrop_win = vim.api.nvim_open_win(backdrop_buf, false, {
            relative = "editor",
            width = vim.o.columns,
            height = vim.o.lines,
            row = 0,
            col = 0,
            style = "minimal",
            focusable = false,
            zindex = 49, -- One less than main window
        })

        -- Set backdrop appearance (exactly like lazy.nvim)
        vim.api.nvim_set_hl(0, "LazyBackdrop", { bg = "#000000", default = true })
        M.wo(backdrop_win, "winhighlight", "Normal:LazyBackdrop")
        M.wo(backdrop_win, "winblend", backdrop_blend)

        -- Set buffer options like lazy.nvim
        vim.bo[backdrop_buf].buftype = "nofile"
        vim.bo[backdrop_buf].filetype = "lazy_backdrop"
    end

    -- Main floating window configuration
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = opts.border or tools.border,
        zindex = 50,
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    M.wo(win, "winhighlight", "Normal:FloaTerminal,FloatBorder:FloaTerminalBorder")

    -- Close function (like lazy.nvim's close method)
    local function close_windows()
        vim.schedule(function()
            if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
                vim.api.nvim_win_close(backdrop_win, true)
            end
            if backdrop_buf and vim.api.nvim_buf_is_valid(backdrop_buf) then
                vim.api.nvim_buf_delete(backdrop_buf, { force = true })
            end
            if win and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            vim.cmd.redraw()
        end)
    end

    -- Close both windows when 'q' is pressed
    vim.keymap.set("n", "q", close_windows, { buffer = buf })

    -- Handle VimResized like lazy.nvim does
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            if not (win and vim.api.nvim_win_is_valid(win)) then
                return true
            end
            -- Update main window size
            local new_width = opts.width or math.floor(vim.o.columns * 0.8)
            local new_height = opts.height or math.floor(vim.o.lines * 0.8)
            local new_col = math.floor((vim.o.columns - new_width) / 2)
            local new_row = math.floor((vim.o.lines - new_height) / 2)

            vim.api.nvim_win_set_config(win, {
                relative = "editor",
                width = new_width,
                height = new_height,
                row = new_row,
                col = new_col,
            })

            -- Update backdrop window size if it exists
            if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
                vim.api.nvim_win_set_config(backdrop_win, {
                    width = vim.o.columns,
                    height = vim.o.lines,
                })
            end
        end,
        group = vim.api.nvim_create_augroup("FloatingWindowResize", { clear = false }),
    })

    -- Also close backdrop when main window is closed
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(win),
        callback = function()
            if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
                vim.api.nvim_win_close(backdrop_win, true)
            end
            if backdrop_buf and vim.api.nvim_buf_is_valid(backdrop_buf) then
                vim.api.nvim_buf_delete(backdrop_buf, { force = true })
            end
        end,
        once = true,
    })

    return { buf = buf, win = win, backdrop_win = backdrop_win, backdrop_buf = backdrop_buf }
end

return M
