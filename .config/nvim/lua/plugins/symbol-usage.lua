return {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = {
        vt_position = "end_of_line",
        text_format = function(symbol)
            local res = {}

            if symbol.references then
                local usage = symbol.references == 1 and "usage" or "usages"
                table.insert(res, { (" 󰌹 %s %s"):format(symbol.references, usage), "Usage" })
            end

            return res
        end,
    },
}
