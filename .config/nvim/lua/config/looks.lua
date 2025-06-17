local M = {}

--- Generate square border characters with highlight group
--- @param hl_name string|nil Highlight group name for the border
--- @return table Array of border character and highlight pairs in clockwise order starting from top-left
M.square = function(hl_name)
    return {
        { "┌", hl_name }, -- top-left
        { "─", hl_name }, -- top
        { "┐", hl_name }, -- top-right
        { "│", hl_name }, -- right
        { "┘", hl_name }, -- bottom-right
        { "─", hl_name }, -- bottom
        { "└", hl_name }, -- bottom-left
        { "│", hl_name }, -- left
    }
end

--- Generate rounded border characters with highlight group
--- @param hl_name string|nil Highlight group name for the border
--- @return table Array of border character and highlight pairs in clockwise order starting from top-left
M.rounded = function(hl_name)
    return {
        { "╭", hl_name }, -- top-left
        { "─", hl_name }, -- top
        { "╮", hl_name }, -- top-right
        { "│", hl_name }, -- right
        { "╯", hl_name }, -- bottom-right
        { "─", hl_name }, -- bottom
        { "╰", hl_name }, -- bottom-left
        { "│", hl_name }, -- left
    }
end

--- Generate thick border characters with highlight group
--- @param hl_name string|nil Highlight group name for the border
--- @return table Array of border character and highlight pairs in clockwise order starting from top-left
M.thick = function(hl_name)
    return {
        { "┏", hl_name }, -- top-left
        { "━", hl_name }, -- top
        { "┓", hl_name }, -- top-right
        { "┃", hl_name }, -- right
        { "┛", hl_name }, -- bottom-right
        { "━", hl_name }, -- bottom
        { "┗", hl_name }, -- bottom-left
        { "┃", hl_name }, -- left
    }
end

-- Default border style
M.current_border = M.square

--- Set the current border style by name
--- @param border_type "rounded"|"square"|"thick" The border style to use
--- @throws Error if border_type is not recognized
M.set_border = function(border_type)
    if border_type == "rounded" then
        M.current_border = M.rounded
    elseif border_type == "square" then
        M.current_border = M.square
    elseif border_type == "thick" then
        M.current_border = M.thick
    else
        error("Unknown border type: " .. tostring(border_type))
    end
end

--- Convert current border format for telescope usage
--- Telescope expects a different order than our internal format
--- @return table Array of border characters in telescope's expected order
M.current_border_telescope = function()
    local border = M.current_border()
    -- Telescope expects: top, right, bottom, left, top-left, top-right, bottom-right, bottom-left
    -- Our order is:      TL,  T,     TR,     R,    BR,       B,         BL,           L
    --                    1,   2,     3,      4,    5,        6,         7,            8
    return {
        border[2][1], -- top
        border[4][1], -- right
        border[6][1], -- bottom
        border[8][1], -- left
        border[1][1], -- top-left
        border[3][1], -- top-right
        border[5][1], -- bottom-right
        border[7][1], -- bottom-left
    }
end

--- Get the Neovim border type string for the current border
--- Used with Neovim's native border option in floating windows
--- @return "rounded"|"single" Border type string for Neovim's border option
M.border_type = function()
    local border_map = {
        [M.rounded] = "rounded",
        [M.square] = "single",
        [M.thick] = "single", -- thick uses single style for neovim
    }

    return border_map[M.current_border] or "single"
end

--- Get the name of the current border style
--- @return "rounded"|"square"|"thick" The current border style name
M.get_current_border_name = function()
    local border_map = {
        [M.rounded] = "rounded",
        [M.square] = "square",
        [M.thick] = "thick",
    }

    return border_map[M.current_border] or "square"
end

return M
