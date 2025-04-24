-- Plugin Settings
vim.g.codeium_disable_bindings = 1
vim.g.codeium_enabled = false
vim.g.fold_indicator = true
vim.g.show_line_number = true

vim.g.show_indent = false
vim.g.use_blink = true
vim.g.markdown_recommended_style = 0

vim.opt.conceallevel = 2

-- Core UI and Appearance
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 0
vim.opt.statusline = " %f %m %= %l:%c ♥ "
vim.opt.showmode = false
-- vim.opt.colorcolumn = { 81, 121 }

-- Line Numbers
vim.opt.number = vim.g.show_line_number
vim.opt.relativenumber = vim.g.show_line_number
vim.opt.numberwidth = 2
vim.opt.ruler = false

-- Special Characters and Formatting
vim.opt.list = true
vim.opt.jumpoptions = "view"
vim.opt.listchars = {
    nbsp = "⦸",
    tab = "  ",
    extends = "»",
    precedes = "«",
    trail = "·",
    eol = "↴", -- ⏎, ¬, ↴
}
vim.opt.showbreak = "↳ " -- Cool character on line wrap
vim.opt.fillchars = {
    eob = " ", -- Suppress ~ at EndOfBuffer
    fold = " ", -- Hide trailing folding characters
    diff = "╱",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
}

-- Indentation and Formatting
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.copyindent = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.formatoptions = table.concat {
    "2", -- Use the second line's indent vale when indenting (allows indented first line)
    "q", -- Formatting comments with gq
    "w", -- Trailing whitespace indicates a paragraph
    "j", -- Remove comment leader when makes sense (joining lines)
    "r", -- Insert comment leader after hitting Enter
    "o", -- Insert comment leader after hitting o or O
}

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit" -- preview incremental substitute

-- Split and Window Behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.backspace = "indent,eol,start"

-- Performance and Updates
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10

-- History and Persistence
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }
vim.opt.confirm = true

-- Folding (Treesitter)
vim.opt.foldcolumn = vim.g.show_line_number and "1" or "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldtext = ""

-- Session Management
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Netrw Configuration
vim.cmd "let g:netrw_liststyle = 3"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable Default Providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Path Configuration
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- UI Polish
vim.opt.shortmess:append "sI"
