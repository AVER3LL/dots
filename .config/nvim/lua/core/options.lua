vim.g.enable_signature = true

vim.o.conceallevel = 2

vim.o.cmdheight = 0
vim.o.laststatus = 0

vim.o.mouse = "a"

vim.o.showmode = false

vim.o.termguicolors = true

vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:Cursor/Cursor"

-- vim.o.guicursor = "n-v-c-sm:block,"
--     .. "i-ci-ve:block-blinkwait300-blinkon400-blinkoff250,"
--     .. "r-cr-o:hor20,"
--     .. "a:Cursor/Cursor"

vim.o.cursorline = true
vim.o.cursorlineopt = "number"

vim.wo.signcolumn = "yes"
vim.o.numberwidth = 2

vim.o.number = false
vim.o.relativenumber = false

vim.o.ruler = true

vim.o.list = true
vim.opt.listchars = {
    nbsp = "⦸",
    tab = "  ",
    extends = "»",
    precedes = "«",
    trail = "·",
    -- eol = "↴", -- ⏎, ¬, ↴
}
vim.o.showbreak = "↳ " -- Cool character on line wrap
vim.opt.fillchars = {
    eob = " ", -- Suppress ~ at EndOfBuffer
    fold = " ", -- Hide trailing folding characters
    diff = "╱",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
}

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smarttab = true

-- Diff mode settings.
-- Setting the context to a very large number disables folding.
vim.opt.diffopt:append "vertical,context:99"

vim.o.copyindent = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.wrap = false
vim.o.linebreak = true
vim.o.breakindent = true

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "nosplit" -- preview incremental substitute

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8
vim.o.backspace = "indent,eol,start"

vim.o.updatetime = 250
vim.o.timeoutlen = 800
vim.o.ttimeoutlen = 10

-- History and Persistence
vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undoreload = 10000
vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }
vim.o.confirm = true

vim.opt.formatoptions = table.concat {
    "2", -- Use the second line's indent vale when indenting (allows indented first line)
    "q", -- Formatting comments with gq
    "w", -- Trailing whitespace indicates a paragraph
    "j", -- Remove comment leader when makes sense (joining lines)
    "r", -- Insert comment leader after hitting Enter
    "o", -- Insert comment leader after hitting o or O
}

-- Session Management
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- folding
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldtext = ""

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
