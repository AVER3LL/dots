_G.tools = {}

--- @type "rounded" | "single" | "solid" | "none" | "bold" | "double" | "shadow"
tools.border = "single"

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
        -- If it's a link, resolve recursively
        return tools.resolve_hl(hl.link)
    else
        return hl.fg
    end
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

tools.hl_str = function(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end
