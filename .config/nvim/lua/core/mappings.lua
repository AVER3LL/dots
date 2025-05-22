-- Leader key setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap helper function
local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Open Lazy" })

map("n", "<leader>wt", function()
    local current = vim.o.laststatus
    if current == 0 then
        vim.o.laststatus = 3
        vim.notify("Statusline enabled", vim.log.levels.INFO, { title = "Statusline" })
    else
        vim.o.laststatus = 0
        vim.notify("Statusline Disabled", vim.log.levels.INFO, { title = "Statusline" })
    end
end, { desc = "Toggle statusline" })

map("n", "<leader><leader>l", function()
    local toggleSigns = require("utils").ToggleDiagnosticIcons
    -- Deactivate line numbers
    if vim.wo.number then
        vim.g.show_line_number = false
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.foldcolumn = "0"
        toggleSigns()
    else
        vim.g.show_line_number = true
        vim.opt.number = true
        vim.opt.relativenumber = false
        vim.opt.foldcolumn = "1"
        toggleSigns()
    end
end, { desc = "Toggle line numbers" })

local M = {}

map("n", "<tab>", ":bnext<CR>", { desc = "Go to next buffer" })
map("n", "<S-tab>", ":bprevious<CR>", { desc = "Go to previous buffer" })

-- Indentation in Visual Mode
map("v", "<", "<gv")
map("v", ">", ">gv")

M.bufferlin = function()
    -- Go to next or last buffer
    map("n", "<tab>", ":BufferLineCycleNex<CR>", { desc = "Go to next buffer" })
    map("n", "<S-tab>", ":BufferLineCyclePre<CR>", { desc = "Go to previous buffer" })

    map("n", "<leader>b", "<cmd>BufferLinePic<CR>", { desc = "Pick buffer" })

    -- Re-order to previous/next
    map("n", "<leader>gp", ":BufferLineMovePrev<CR>", { silent = true })
    map("n", "<leader>gn", ":BufferLineMoveNext<CR>", { silent = true })
    -- map("n", "<leader>cba", "<cmd>BufferLineCloseOthers<CR>", {
    --     desc = "Close all buffers but the current one",
    -- })

    map("n", "&", "<cmd>BufferLineGoToBuffer 1<cr>")
    map("n", "é", "<cmd>BufferLineGoToBuffer 2<cr>")
    map("n", '"', "<cmd>BufferLineGoToBuffer 3<cr>")
end

M.debugger = function()
    map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breakpoint" })
    map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
    map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
    map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
end

M.tmux = function()
    map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Move to left split" })
    map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Move to bottom split" })
    map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Move to top split" })
    map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Move to right split" })
end

map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

M.noice = function()
    map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
end

local toggle_terminal_mapping = '<A-">'

-- Plugin & Utility Toggles
map("n", "<leader><leader>ct", function()
    if vim.g.codeium_enabled then
        vim.g.codeium_enabled = false
        vim.notify("Codeium disabled", vim.log.levels.INFO, { title = "Codeium" })
    else
        vim.g.codeium_enabled = true
        vim.notify("Codeium enabled", vim.log.levels.INFO, { title = "Codeium" })
    end
end, { desc = "Toggle Codeium" })

-- Toggle supermaven
map("n", "<leader><leader>cs", "<cmd>supermavenToggle<cr>", { desc = "Toggle Supermaven" })

map("n", "<leader>tl", function()
    -- Handle cyberdream toggle
    if vim.g.colors_name == "cyberdream" then
        vim.cmd "CyberdreamToggleMode"
        return
    end

    -- Handle monokai-pro variants
    if string.match(vim.g.colors_name or "", "^monokai%-pro") then
        if vim.g.colors_name == "monokai-pro-light" then
            vim.cmd "colorscheme monokai-pro-octagon"
        else
            vim.cmd "colorscheme monokai-pro-light"
        end
        return
    end

    -- Default light/dark toggle behavior
    vim.o.background = (vim.o.background == "dark") and "light" or "dark"
end, { desc = "Light Dark Toggle" })

-- Basic Navigation
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move up" })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down" })

map("n", "gl", "$", { desc = "Move to end of line" })
map("n", "gh", "_", { desc = "Move to end of line" })

-- Commenting
map("n", "<leader>v", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<leader>v", "gc", { desc = "Toggle comment", remap = true })

-- Word Wrap
map("n", "<leader>ww", "<cmd>set wrap!<CR>", { desc = "Toggle word wrap" })

-- Insert Mode Navigation
map("i", "<C-b>", "<ESC>^i", { desc = "Move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move to end of line" })
map("i", "<C-Backspace>", "<C-W>", { desc = "Delete word before cursor" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- Clear Highlights
map({ "i", "s", "n" }, "<esc>", function()
    if require("luasnip").expand_or_jumpable() then
        require("luasnip").unlink_current()
    end
    vim.cmd "noh"
    return "<esc>"
end, { desc = "Escape, clear hlsearch, and stop snippet session", expr = true })
map("n", "<leader>no", "<cmd>noh<CR>", { desc = "General clear highlights" })

-- Clipboard Operations
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from clipboard" })

-- Window Splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Center buffer
map("n", "<leader><leader>n", "<cmd>NoNeckPain<CR>", { desc = "Center windows" })

-- Split Resizing
map("n", "<C-Up>", "<C-W>+", { desc = "Split increase height" })
map("n", "<C-Down>", "<C-W>-", { desc = "Split decrease height" })
map("n", "<C-Right>", "<C-W><", { desc = "Split decrease width" })
map("n", "<C-Left>", "<C-W>>", { desc = "Split increase width" })

-- Git Commands
map("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git blame the current line" })
map("n", "<leader>gd", ":Gitsigns preview_hunk <CR>", { desc = "Git diff the current hunk" })
map(
    "n",
    "<leader>gg",
    ":lua require('gitsigns').diffthis(nil, { vertical = true }) <CR>",
    { desc = "Git diff the current file" }
)

-- Redo
map("n", "U", "<C-r>", { desc = "Redo" })

-- Tab Management
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Create a new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tt", "<cmd>tabnew %<CR>", { desc = "Open current buffer in another tab" })

-- Buffer Management
-- map("n", "<tab>", ":bnext<CR>", { desc = "Go to next buffer" })
-- map("n", "<S-tab>", ":bprevious<CR>", { desc = "Go to previous buffer" })

map("n", "<leader>nb", "<cmd>enew<CR>", { desc = "Buffer new" })
-- map("n", "<leader>x", "<cmd>Bdelete<CR>", { desc = "Buffer delete" })

map("n", "<leader>x", function()
    Snacks.bufdelete()
end, { desc = "Buffer delete" })

map("n", "<leader>cba", function()
    Snacks.bufdelete.other()
end, { desc = "Close all buffers but the current one" })

-- Centering
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "%", "%zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

-- Line Movement
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Word Movement
map("n", "<A-h>", "b<C-v>ehdwgeP", { desc = "Move word left" })
map("n", "<A-l>", "dawwP", { desc = "Move word right" })
map("v", "<A-h>", "<Left>dvhP`[v`]", { desc = "Move selection left" })
map("v", "<A-l>", "<Right>dp`[v`]", { desc = "Move selection right" })

-- Formatting
map("n", "<leader>fm", function()
    require("conform").format { async = true, lsp_format = "fallback" }
end, { desc = "Format files" })

-- File Tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvimtree focus window" })

-- Telescope
-- map("n", "<leader>ff", "<cmd>lua Snacks.picker.files() <CR>", { desc = "Snacks find files" })
-- map("n", "<leader>fg", "<cmd>lua Snacks.picker.git_files() <CR>", { desc = "Snacks find git files" })
-- map("n", "<leader>fw", "<cmd>lua Snacks.picker.grep() <CR>", { desc = "Snacks live grep" })
-- map("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers() <CR>", { desc = "Snacks find buffers" })
-- map("n", "<leader>th", "<cmd>lua Snacks.picker.colorschemes() <CR>", { desc = "Snacks find colorscheme" })

-- map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })
-- map("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Telescope find git files" })
-- map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
-- map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {
--     desc = "Telescope find in current buffer",
-- })
-- map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find oldfiles" })
-- map(
--     "n",
--     "<leader>fc",
--     -- "<cmd>lua require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }<cr>",
--     "<cmd>lua require('telescope.builtin').find_files { cwd = '~/dotfiles/.config/nvim' }<cr>",
--     { desc = "Find config file" }
-- )

-- map("n", "<leader>z", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {
--     desc = "Telescope find in current buffer",
-- })
-- map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
-- map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Telescope find keymaps" })
-- map("n", "<leader>th", "<cmd>Telescope colorscheme<CR>", { desc = "Telescope colorscheme" })
-- map("n", "<leader>fy", ":Yazi toggle<cr>", { desc = "Open yazi" })

-- Session Management
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session" })
map("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })

local terminal = require "config.floaterminal"
map("n", toggle_terminal_mapping, function()
    terminal.toggle()
end, { desc = "Toggle terminal" })

-- map("n", "<leader><leader>r", function()
--     require("config.code-runner").run_file()
-- end, { desc = "Run the current file" })

map("n", "<leader><leader>r", function()
    terminal.run()
end, { desc = "Run the current file" })

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-termopen", { clear = true }),
    callback = function(event)
        vim.opt.number = false
        vim.opt.relativenumber = false
        local opts = { buffer = event.buf }
        map("t", "<esc>", [[<C-\><C-n>]], opts)
        map("t", "<A-i>", [[<C-\><C-n>]], opts)
        map("t", toggle_terminal_mapping, function()
            terminal.toggle()
        end, { noremap = true, silent = true })
        map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        -- map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end,
})

return M
