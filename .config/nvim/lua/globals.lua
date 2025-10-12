_G.tools = {}

--- @type "rounded" | "single" | "solid" | "none" | "bold" | "double" | "shadow"
tools.border = "single"

--- @type "flat" | "clear"
tools.style = "clear"

tools.transparent = false

tools.change_background = function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end

    if vim.g.colors_name == "onedark" then
        local ok, onedark = pcall(require, "onedark")
        if ok then
            onedark.toggle()
        end
    end
end

--- Blend two colors together
--- @param bg number|string Background color (hex number or string)
--- @param fg number|string Foreground color (hex number or string)
--- @param amount? number Blend amount (0.0 = bg only, 1.0 = fg only, default: 0.5)
--- @return number Blended color as hex number
tools.blend = function(bg, fg, amount)
    amount = amount or 0.5
    amount = math.max(0, math.min(1, amount))

    -- Convert colors to numbers if they're strings
    if type(bg) == "string" then
        bg = tonumber(bg:gsub("#", ""), 16) or 0
    elseif type(bg) ~= "number" then
        bg = 0
    end

    if type(fg) == "string" then
        fg = tonumber(fg:gsub("#", ""), 16) or 0
    elseif type(fg) ~= "number" then
        fg = 0
    end

    -- Clamp to valid color range
    bg = math.max(0, math.min(0xFFFFFF, bg))
    fg = math.max(0, math.min(0xFFFFFF, fg))

    -- Extract RGB components
    local bg_r = math.floor(bg / 65536) % 256
    local bg_g = math.floor(bg / 256) % 256
    local bg_b = bg % 256

    local fg_r = math.floor(fg / 65536) % 256
    local fg_g = math.floor(fg / 256) % 256
    local fg_b = fg % 256

    -- Blend components
    local r = math.floor(bg_r + (fg_r - bg_r) * amount)
    local g = math.floor(bg_g + (fg_g - bg_g) * amount)
    local b = math.floor(bg_b + (fg_b - bg_b) * amount)

    -- Combine back to hex
    return r * 65536 + g * 256 + b
end

--- @param mode string | table
--- @param lhs string
--- @param rhs string | fun(): string?
--- @param opts? table
tools.map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, lhs, rhs, opts)
end

tools.adjust_brightness = function(color, amount)
    -- Convert string hex to number if needed
    if type(color) == "string" then
        color = tonumber(color:gsub("#", ""), 16) or 0
    elseif type(color) ~= "number" then
        color = 0
    end

    -- Clamp inputs to valid ranges
    color = math.max(0, math.min(0xFFFFFF, color))
    amount = math.max(0, math.min(10, amount or 1))

    -- Extract RGB components
    local r = math.floor(color / 65536) % 256
    local g = math.floor(color / 256) % 256
    local b = color % 256

    -- Apply brightness adjustment
    r = math.min(255, math.floor(r * amount))
    g = math.min(255, math.floor(g * amount))
    b = math.min(255, math.floor(b * amount))

    -- Combine back to hex
    return r * 65536 + g * 256 + b
end

tools.resolve_hl = function(name)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    if hl.link then
        return tools.resolve_hl(hl.link)
    end
    return hl
end

tools.toggle_numbers = function()
    if vim.wo.number then
        -- vim.g.show_line_number = false
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.foldcolumn = "0"
    else
        -- vim.g.show_line_number = true
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.foldcolumn = "1"
    end
end

tools.diagnostics_available = function()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg:supports_method(diagnostics) then
            return true
        end
    end

    return false
end

---@param kind "numeric"|"boolean"
tools.transparent_background = function(kind)
    if kind == "numeric" then
        return tools.transparent and 1 or 0
    end

    return tools.transparent
end

tools.hl_str = function(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end
