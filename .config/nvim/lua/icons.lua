local M = {}

--- Diagnostic severities.
M.diagnostics = {
    ERROR = "󰅚 ",
    WARN = "󰀪 ",
    HINT = "󰌶 ",
    INFO = "󰋽 ",
}

M.diagnostics[1] = M.diagnostics.ERROR
M.diagnostics[2] = M.diagnostics.WARN
M.diagnostics[3] = M.diagnostics.INFO
M.diagnostics[4] = M.diagnostics.HINT

--- For folding.
M.arrows = {
    right = "",
    left = "",
    up = "",
    down = "",
}

M.modes = {
    normal = "", --󰗚
    insert = "", --󰉉
    visual = "", --󰉊
    command = "", --
    other = "",
}

M.kind_icons = {
    vscode = {
        Namespace = "󰌗",
        Text = "",
        Method = "",
        Function = "", -- 󰆧 , ƒ, 󰡱, 󰊕, 󰮊 ,󱒗 , 󰫢
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
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
    },

    normal = {
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
    },
}

--- LSP symbol kinds.
M.symbol_kinds = M.kind_icons.normal

--- Shared icons that don't really fit into a category.
M.misc = {
    bug = "",
    ellipsis = "…",
    git = "",
    branch = "",
    node = "╼",
    bullet = "•",
    dot = "",
    squire = "□",
    squire_filled = "■",
    squircle = "󱓻",
    document = "≡",
    lock = "", --
    ok = "✔",
    search = "   ",
    vertical_bar = "│",
    dashed_bar = "┊",

    lightbulb = "💡",

    thick_bar = " ▎",
    delete = " ",
}

return M
