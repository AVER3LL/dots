-- Plugin Settings
vim.g.codeium_disable_bindings = 1
vim.g.codeium_enabled = true

vim.g.show_indent = false
vim.g.use_blink = false

-- Make the cursor a block
-- vim.opt.guicursor = "n-v-c-i:block"

-- Core UI and Appearance
vim.o.background = "dark"
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.signcolumn = "yes"
vim.o.laststatus = 0
vim.o.showmode = false
vim.opt.colorcolumn = { 81, 121 }
vim.opt.linespace = 2

-- Line Numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 2

-- Special Characters and Formatting
vim.opt.list = true
vim.opt.listchars = {
    nbsp = "⦸",
    tab = "  ",
    extends = "»",
    precedes = "«",
    trail = "·",
}
vim.opt.showbreak = "↳ " -- Cool character on line wrap
vim.opt.fillchars = {
    eob = " ", -- Suppress ~ at EndOfBuffer
    fold = " ", -- Hide trailing folding characters
    diff = "╱",
    foldopen = "",
    foldclose = "",
}

-- Indentation and Formatting
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.linebreak = true
vim.opt.formatoptions = table.concat {
    "2", -- Use the second line's indent vale when indenting (allows indented first line)
    "q", -- Formatting comments with gq
    "w", -- Trailing whitespace indicates a paragraph
    "j", -- Remove comment leader when makes sense (joining lines)
    "r", -- Insert comment leader after hitting Enter
    "o", -- Insert comment leader after hitting o or O
}

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Split and Window Behavior
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8
vim.o.backspace = "indent,eol,start"

-- Performance and Updates
vim.o.updatetime = 100
vim.o.timeoutlen = 400

-- History and Persistence
vim.o.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }
vim.opt.confirm = true

-- Folding (Treesitter)
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldtext = ""

-- Session Management
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

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
