local M = {}

--- Diagnostic severities.
M.diagnostics = {
    ERROR = "󰈸",
    WARN = "",
    HINT = "",
    INFO = "󰋽",
}

--- For folding.
M.arrows = {
    right = "",
    left = "",
    up = "",
    down = "",
}

--- LSP symbol kinds.
M.symbol_kinds = {
    Namespace = "󰌗",
    Text = "󰉿",
    Method = "󰊕",
    Function = "󰊕", -- 󰆧 , ƒ, 󰡱, 󰊕, 󰮊 ,󱒗 , 󰫢
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈚",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    Table = "",
    Object = "󰅩",
    Tag = "",
    Array = "[]",
    Boolean = "",
    Number = "",
    Null = "󰟢",
    Supermaven = "",
    String = "󰉿",
    Calendar = "",
    Watch = "󰥔",
    Package = "",
    Copilot = "",
    Codeium = "",
    TabNine = "",
    BladeNav = "",
}

--- Shared icons that don't really fit into a category.
M.misc = {
    bug = "",
    ellipsis = "…",
    git = "",
    branch = "",
    node = "╼",
    bullet = "•",
    document = "≡",
    lock = "",
    search = "   ",
    vertical_bar = "│",
    dashed_bar = "┊",

    thick_bar = " ▎",
    delete = " ",
}

return M
