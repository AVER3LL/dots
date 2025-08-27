-- Leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = tools.map

require("config.search-counter").setup { highlight = "Comment" }

map("n", "U", "<C-r>", { desc = "Redo" })

map("n", "<leader>nb", "<cmd>enew<CR>", { desc = "Buffer new" })

-- Indentation in Visual Mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- map("n", "<tab>", ":bnext<CR>", { desc = "Go to next buffer" })
-- map("n", "<S-tab>", ":bprevious<CR>", { desc = "Go to previous buffer" })

-- Window Splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab management
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Create a new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- Clear Highlights
map({ "n", "i", "s" }, "<esc>", function()
    if require("luasnip").expand_or_jumpable() then
        require("luasnip").unlink_current()
    end
    vim.cmd "noh"
    require("config.search-counter").clear_counter()
    return "<esc>"
end, { desc = "Escape, clear hlsearch, and stop snippet session", expr = true })

map("n", "<leader>no", "<cmd>noh<CR>", { desc = "General clear highlights" })

-- Split navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

map("n", "<C-S-Left>", "<C-w>H")
map("n", "<C-S-Right>", "<C-w>L")
map("n", "<C-S-Up>", "<C-w>K")
map("n", "<C-S-Down>", "<C-w>J")

-- Split Resizing
map("n", "<C-Up>", "<C-W>+", { desc = "Split increase height" })
map("n", "<C-Down>", "<C-W>-", { desc = "Split decrease height" })
map("n", "<C-Right>", "<C-W><", { desc = "Split decrease width" })
map("n", "<C-Left>", "<C-W>>", { desc = "Split increase width" })

-- Wrapped lines navigation
map({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move up" })
map({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down" })

-- Insert mode navigation
map("i", "<C-Backspace>", "<C-W>", { desc = "Delete word before cursor" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- Line Movement
map("n", "<A-S-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-S-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clipboard Operations
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from clipboard" })

map("v", "p", '"_dP') -- Replace visual selection without copying it

-- Centering
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "%", "%zz")

local terminal = require "config.floaterminal"
local terminal_mapping = '<A-">'

map("n", terminal_mapping, function()
    terminal.toggle()
end)

map("n", "<leader><leader>r", function()
    terminal.run()
end, { desc = "Run the current file" })

map("n", "<leader><leader>e", function()
    terminal.put_current_file "start"
end, { desc = "Put file path in terminal" })

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-termopen", { clear = true }),
    callback = function(event)
        vim.opt.number = false
        vim.opt.relativenumber = false
        local opts = { buffer = event.buf }
        map("t", "<esc>", [[<C-\><C-n>]], opts)
        map("t", terminal_mapping, function()
            terminal.toggle()
        end, opts)
    end,
})
