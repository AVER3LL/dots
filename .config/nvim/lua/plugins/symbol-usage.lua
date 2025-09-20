return {
    "Wansmer/symbol-usage.nvim",
    enabled = false,
    event = "BufReadPre",
    opts = {
        vt_position = "end_of_line",
        text_format = function(symbol)
            local res = {}

            if symbol.references then
                local usage = symbol.references <= 1 and "usage" or "usages"
                local num = symbol.references == 0 and "no" or symbol.references
                table.insert(res, { (" 󰌹  %s %s"):format(num, usage), "Usage" })
            end

            return res
        end,
    },
}
