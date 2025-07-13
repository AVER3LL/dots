local o, g, opt = vim.o, vim.g, vim.opt

-- Plugin Settings
g.codeium_disable_bindings = 1
g.codeium_enabled = true

g.fold_indicator = true

g.show_line_number = false
g.show_relative_line_number = true

--- @type "flat" | "clear"
g.style = "clear"

require("config.looks").set_border "square"

g.enable_signature = true

g.show_indent = false
g.use_blink = true
g.markdown_recommended_style = 0

o.conceallevel = 2

-- Enable the mouse
o.mouse = "a"

-- Disable horizontal scrolling
o.mousescroll = "ver:3,hor:0"
o.cmdheight = 0

-- Core UI and Appearance
opt.background = "dark"
o.termguicolors = true
o.cursorline = true
o.cursorlineopt = "number"
o.signcolumn = "yes"
o.laststatus = 0
-- opt.statusline = " %f %m %= %l:%c ♥ "
o.statusline = " %<%f %h%m%r %= %y [%{&fileformat}] %l:%c %P ♥ "
o.showmode = false
-- opt.colorcolumn = { 81, 121 }

-- Line Numbers
o.number = g.show_line_number
o.relativenumber = g.show_line_number and g.show_relative_line_number
o.numberwidth = 2
o.ruler = false

-- Special Characters and Formatting
o.list = true
o.jumpoptions = "view"
opt.listchars = {
    nbsp = "⦸",
    tab = "  ",
    extends = "»",
    precedes = "«",
    trail = "·",
    eol = "↴", -- ⏎, ¬, ↴
}
o.showbreak = "↳ " -- Cool character on line wrap
opt.fillchars = {
    eob = " ", -- Suppress ~ at EndOfBuffer
    fold = " ", -- Hide trailing folding characters
    diff = "╱",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
}

-- Indentation and Formatting
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.smarttab = true

o.copyindent = true
o.smartindent = true
o.autoindent = true

o.wrap = true
o.linebreak = true
o.breakindent = true
opt.formatoptions = table.concat {
    "2", -- Use the second line's indent vale when indenting (allows indented first line)
    "q", -- Formatting comments with gq
    "w", -- Trailing whitespace indicates a paragraph
    "j", -- Remove comment leader when makes sense (joining lines)
    "r", -- Insert comment leader after hitting Enter
    "o", -- Insert comment leader after hitting o or O
}

-- Search
o.ignorecase = true
o.smartcase = true
o.inccommand = "nosplit" -- preview incremental substitute

-- Split and Window Behavior
o.splitright = true
o.splitbelow = true
o.scrolloff = 10
o.sidescrolloff = 8
o.backspace = "indent,eol,start"

-- Performance and Updates
o.updatetime = 250
o.timeoutlen = 300
o.ttimeoutlen = 10

-- History and Persistence
o.undofile = true
o.undolevels = 1000
o.undoreload = 10000
opt.shada = { "!", "'1000", "<50", "s10", "h" }
o.confirm = true

-- Folding (Treesitter)
o.foldcolumn = g.show_line_number and "1" or "0"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.foldtext = ""

-- Session Management
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Netrw Configuration
vim.cmd "let g:netrw_liststyle = 3"
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Disable Default Providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- UI Polish
opt.shortmess:append "sI"
