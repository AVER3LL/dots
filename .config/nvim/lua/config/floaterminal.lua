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
    lua = "lua $filepath",
    javascript = "node $filepath",
    php = "php $filepath",
    typescript = "tsc $filename && node $filenameWithoutExt.js",
    cpp = "g++ $filepath -o $filenameWithoutExt && ./$filenameWithoutExt",
    c = "gcc $filepath -o $filenameWithoutExt && ./$filenameWithoutExt",
    java = "cd $dir && javac $filename && java $filenameWithoutExt",
    kotlin = "cd $dir && kotlinc $filename -include-runtime -d $filenameWithoutExt.jar && java -jar $filenameWithoutExt.jar",
    rust = "rustc $filepath && ./$filenameWithoutExt",
    tex = "~/Documents/memoire-2025/Template-Licence-3-Latex/compile_latex.sh $filename",
    go = "go run $filepath",
    sh = "bash $filepath",
    dart = "dart $filepath",
    html = "xdg-open $filepath", -- ouvrir dans le navigateur sous Linux
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
    local filenameWithoutExt = vim.fn.expand "%:t:r" -- Filename without extension

    return command
        :gsub("%$dir", dir)
        :gsub("%$filename", filename)
        :gsub("%$filenameWithoutExt", filenameWithoutExt)
        :gsub("%$filepath", filepath)
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
