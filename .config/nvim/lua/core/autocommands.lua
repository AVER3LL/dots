local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn
local api = vim.api
local o = vim.o

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

local kitty_socket = os.getenv "KITTY_LISTEN_ON" or "unix:/tmp/mykitty"
local kitty_group = augroup "KityGroup"

local function kitty_command(args)
    local cmd = vim.list_extend({ "kitty", "@", "--to", kitty_socket }, args)
    vim.system(cmd)
end

autocmd("VimEnter", {
    group = kitty_group,
    desc = "Remove kitty's padding upon entering",
    callback = function()
        kitty_command { "set-spacing", "margin=0" }
    end,
})

autocmd("BufWritePre", {
    desc = "Autocreate a dir when saving a file",
    group = augroup "auto_create_dir",
    callback = function(event)
        if event.match:match "^%w%w+:[\\/][\\/]" then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        fn.mkdir(fn.fnamemodify(file, ":p:h"), "p")
    end,
})

autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
    desc = "Fix scrolloff when you are at the EOF",
    group = augroup "ScrollEOF",
    callback = function()
        if api.nvim_win_get_config(0).relative ~= "" then
            return -- Ignore floating windows
        end

        local win_height = fn.winheight(0)
        local scrolloff = math.min(o.scrolloff, math.floor(win_height / 2))
        local visual_distance_to_eof = win_height - fn.winline()

        if visual_distance_to_eof < scrolloff then
            local win_view = fn.winsaveview()
            fn.winrestview { topline = win_view.topline + scrolloff - visual_distance_to_eof }
        end
    end,
})

autocmd("VimLeavePre", {
    group = kitty_group,
    desc = "Reset kitty's padding before leaving",
    callback = function()
        kitty_command { "set-spacing", "margin=default" }
    end,
})

autocmd("BufReadPre", {
    desc = "Auto jump to last position",
    group = augroup "auto-last-position",
    callback = function(args)
        local position = api.nvim_buf_get_mark(args.buf, [["]])
        local winid = fn.bufwinid(args.buf)
        pcall(api.nvim_win_set_cursor, winid, position)
    end,
})

autocmd({ "ColorScheme", "UIEnter" }, {
    desc = "Corrects terminal background color according to colorscheme",
    callback = function()
        if tools.resolve_hl("Normal").bg then
            io.write(string.format("\027]11;#%06x\027\\", tools.resolve_hl("Normal").bg))
        end
    end,
})
autocmd("UILeave", {
    callback = function()
        -- io.write "\027]111\027\\"

        local hex = vim.g.bg_color:gsub("#", "")
        local num = tonumber(hex, 16)
        io.write(string.format("\027]11;#%06x\027\\", num))
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup "lsp_blade_workaround",
    desc = "Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation",
    pattern = "*.blade.php",
    callback = function()
        vim.bo.filetype = "php"
    end,
})

autocmd("LspAttach", {
    group = augroup "lsp_blade_workaround",
    desc = "Additional autocommand to switch back to 'blade' after LSP has attached",
    pattern = "*.blade.php",
    callback = function(args)
        vim.schedule(function()
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf

            if client and client.name == "intelephense" then
                -- Set filetype using treesitter or vim.filetype API
                vim.bo[bufnr].filetype = "blade"
                -- Optionally set syntax manually (though unnecessary if filetype is correct)
                vim.treesitter.start(bufnr, "blade")
            end
        end)
    end,
})

autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup "kickstart-highlight-yank",
    callback = function()
        vim.hl.on_yank {
            timeout = 150,
            priority = 250,
        }
    end,
})

-- Do not comment new lines
autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- autocmd("FileType", {
--     group = augroup "mariasolos/treesitter_folding",
--     desc = "Enable Treesitter folding",
--     callback = function(args)
--         local bufnr = args.buf
--
--         -- Enable Treesitter folding when not in huge files and when Treesitter
--         -- is working.
--         if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
--             vim.api.nvim_buf_call(bufnr, function()
--                 vim.wo[0][0].foldmethod = "expr"
--                 vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
--                 vim.cmd.normal "zx"
--             end)
--         else
--             -- Else just fallback to using indentation.
--             vim.wo[0][0].foldmethod = "indent"
--         end
--     end,
-- })

autocmd("VimResized", {
    desc = "Auto-resize windows when Vim is resized",
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
    group = augroup "json_conceal",
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Notifications when a macro starts
autocmd("RecordingEnter", {
    desc = "Notify when we start recording a macro",
    callback = function()
        local reg = vim.fn.reg_recording()
        vim.notify("Recording macro @" .. reg, vim.log.levels.INFO, { title = "Macro" })
    end,
})

autocmd("RecordingLeave", {
    callback = function()
        vim.notify("Stopped recording macro", vim.log.levels.INFO, { title = "Macro" })
    end,
})

-- close some filetypes with <q>
autocmd("FileType", {
    group = augroup "close_with_q",
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "scratch",
        "spectre_panel",
        "grug-far",
        "vim",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
