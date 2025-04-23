local looks_found, looks = pcall(require, "config.looks")
local bt = looks_found and looks.border_type() or "rounded"

local M = {}

local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

local run_commands = {
    python = "python -u $filepath",
    lua = "lua %",
    javascript = "node %",
    php = "php %",
    typescript = "tsc $filename && node $fileWithoutExt.js",
    cpp = "g++ % -o %:r && ./%:r",
    c = "gcc % -o %:r && ./%:r",
    -- java = "javac % && java %:r",
    java = "cd $dir && javac $filename && java $fileWithoutExt",
    kotlin = "cd $dir && kotlinc $filename -include-runtime -d $fileWithoutExt.jar && java -jar $fileWithoutExt.jar",
    rust = "rustc % && ./%:r",
    go = "go run %",
    sh = "bash %",
    dart = "dart %",
}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end
    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = bt,
    }
    local win = vim.api.nvim_open_win(buf, true, win_config)
    return { buf = buf, win = win }
end

local function send_command(cmd)
    -- Ensure terminal is open
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
            vim.bo[state.floating.buf].buflisted = false
        end
    end
    -- Get the terminal job id
    local chan = vim.b[state.floating.buf].terminal_job_id
    if chan then
        vim.api.nvim_chan_send(chan, cmd .. "\n")
    end
end

local function format_command(command)
    local filepath = vim.fn.expand "%:p" -- Full path to the file
    local dir = vim.fn.expand "%:h" -- Directory of the file
    local filename = vim.fn.expand "%:t" -- Filename with extension
    local fileWithoutExt = vim.fn.expand "%:t:r" -- Filename without extension

    return command
        :gsub("%$dir", dir)
        :gsub("%$filename", filename)
        :gsub("%$fileWithoutExt", fileWithoutExt)
        :gsub("%$filepath", filepath)
        :gsub("%%:r", fileWithoutExt) -- Existing %:r behavior
        :gsub("%%", filepath) -- Use full path for %%
end

function M.run()
    local filetype = vim.bo.filetype
    local command = run_commands[filetype]
    if not command then
        vim.notify("No run command defined for filetype: " .. filetype, vim.log.levels.WARN)
        return
    end
    -- Replace % with current file path
    command = format_command(command)
    send_command(command)
end

function M.toggle()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
            vim.bo[state.floating.buf].buflisted = false
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
    vim.cmd.startinsert()
end

function M.send_command(cmd)
    send_command(cmd)
end

-- Setup function to create commands
function M.setup()
    vim.api.nvim_create_user_command("Floaterminal", M.toggle, {})
    vim.api.nvim_create_user_command("FloaterminalSend", function(opts)
        M.send_command(opts.args)
    end, { nargs = "+" })
end

return M
