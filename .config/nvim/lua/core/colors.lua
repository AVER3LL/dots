local autocmd = vim.api.nvim_create_autocmd
local sethl = function(...)
    vim.api.nvim_set_hl(0, ...)
end

local function gethl(name)
    return vim.api.nvim_get_hl(0, { name = name })
end

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd("ColorScheme", {
    desc = "Custom color tweaks for clean nvim appearance",
    group = augroup "prepare-colors-averell",
    callback = function()
        local colors = {
            error = gethl("DiagnosticError").fg or "#E05F6A",
            warn = gethl("DiagnosticWarn").fg or "#E0AF68",
            info = gethl("DiagnosticInfo").fg or "#56B6C2",
            hint = gethl("DiagnosticHint").fg or "#9A9AA1",
            -- folded = gethl "Folded",
            background = gethl("Normal").bg,
            foreground = gethl("Normal").fg,
            comment = gethl("Comment").fg,
            -- cursorline = gethl("CursorLine").bg,
            cursorline = vim.o.background == "dark" and tools.adjust_brightness(gethl("Normal").bg, 1.25)
                or tools.adjust_brightness(gethl("Normal").bg, 0.95),
            pmenu = tools.style == "clear" and gethl("Pmenu").bg or tools.adjust_brightness(gethl("Normal").bg, 0.75),
            fun = gethl("Function").fg or "#375FAD",
            str = gethl("String").fg or "#7CA855",
            constant = gethl("Constant").fg,
            parenthesis = vim.o.background == "dark" and "#39ff14" or "#ff007f",
        }

        colors.cursorline = vim.list_contains({ "vercel", "moonfly" }, vim.g.colors_name)
                and tools.adjust_brightness(gethl("Normal").bg, 2)
            or colors.cursorline

        -- Basic UI elements
        sethl("Cursor", { bg = tools.blend(colors.background, colors.foreground, 0.80) })
        sethl("HighlightUrl", { underline = true })
        sethl("AlphaButton", { bg = colors.constant, bold = true, fg = colors.background })
        sethl("Laravel", { fg = "#F53003" })
        sethl("MatchParen", { bg = "NONE", fg = colors.parenthesis })

        -- Diagnostics in gutter (no background)
        sethl("DiagnosticSignError", { bg = "NONE", fg = colors.error })
        sethl("DiagnosticSignWarn", { bg = "NONE", fg = colors.warn })
        sethl("DiagnosticSignInfo", { bg = "NONE", fg = colors.info })
        sethl("DiagnosticSignHint", { bg = "NONE", fg = colors.hint })

        sethl("LspInlayHint", {
            fg = tools.blend(colors.background, colors.foreground, 0.7),
            bg = tools.blend(colors.background, colors.foreground, 0.05),
            italic = true,
        })

        sethl("Folded", {
            bg = tools.adjust_brightness(colors.background, vim.o.background == "light" and 0.95 or 1.3),
            fg = tools.blend(colors.background, colors.foreground, 0.6),
        })

        -- Diagnostic underlines
        sethl("DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
        sethl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warn })
        sethl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
        sethl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

        -- LSP line number highlights
        sethl("LspDiagnosticsLineNrError", { fg = colors.error })
        sethl("LspDiagnosticsLineNrWarning", { fg = colors.warn })
        sethl("LspDiagnosticsLineNrInformation", { fg = colors.info })
        sethl("LspDiagnosticsLineNrHint", { fg = colors.hint })

        -- Search highlights
        sethl("HlSearchNear", { bg = "NONE", fg = colors.hint })
        sethl("HlSearchLens", { bg = "NONE", fg = colors.hint })
        sethl("HlSearchLensNear", { bg = "NONE", fg = colors.hint })

        -- Tree explorer cleanup
        sethl("NvimTreeNormal", { bg = colors.background })
        sethl("NvimTreeEndOfBuffer", { bg = colors.background })

        sethl("MiniPickMatchCurrent", { bg = colors.cursorline })
        local effective_style = vim.list_contains({ "vercel", "moonfly" }, vim.g.colors_name) and "clear" or tools.style

        sethl("SnacksPickerListCursorLine", { link = "SnacksPickerPreviewCursorLine" })
        sethl("SnacksPickerCursorLine", { link = "SnacksPickerPreviewCursorLine" })

        -- Style-specific completion highlights
        if effective_style == "flat" then
            sethl("MiniPickNormal", { bg = colors.pmenu, fg = colors.foreground })
            sethl("MiniPickBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl("MiniPickBorderBusy", { bg = colors.pmenu, fg = colors.pmenu })
            sethl("MiniPickBorderText", { link = "DiagnosticVirtualTextInfo" })
            sethl("MiniPickPromptPrefix", { bg = colors.pmenu, fg = gethl("Special").fg, default = true })
            sethl("MiniPickIconFile", { bg = colors.pmenu, fg = colors.comment })
            sethl("MiniPickMatchRanges", { fg = gethl("Special").fg, bold = true })
            sethl("MiniPickPrompt", { bg = colors.pmenu, fg = colors.foreground })

            sethl("SnacksPickerTitle", { link = "DiagnosticVirtualTextInfo" })

            sethl("SnacksInputNormal", { bg = colors.pmenu, fg = colors.foreground })
            sethl("SnacksInputBorder", { bg = colors.pmenu, fg = colors.pmenu })

            -- TODO: Investigate onedark's shenanigans
            -- mysethl("SnacksPickerBorder", { bg = colors.pmenu, fg = colors.pmenu })

            sethl("BlinkCmpSignatureHelp", { bg = colors.pmenu })
            sethl("BlinkCmpSignatureHelpBorder", { bg = colors.pmenu, fg = colors.pmenu })

            -- local menu_bg = tools.adjust_brightness(colors.background, 0.75)
            sethl("BlinkCmpMenu", { bg = colors.pmenu })
            sethl("BlinkCmpMenuBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl(
                "BlinkCmpLabelDescription",
                { bg = colors.pmenu, fg = tools.adjust_brightness(colors.foreground, 0.4), italic = true }
            )

            local doc_bg = tools.adjust_brightness(colors.background, 0.87)
            sethl("BlinkCmpDocBorder", { bg = doc_bg, fg = doc_bg })
            sethl("BlinkCmpDoc", { bg = doc_bg })
            sethl("BlinkCmpDocSeparator", { bg = doc_bg, fg = tools.adjust_brightness(colors.foreground, 0.7) })

            sethl("LspInfoBorder", { bg = colors.pmenu })
            sethl("NormalFloat", { bg = colors.pmenu })
            sethl("FloatBorder", { fg = colors.pmenu, bg = colors.pmenu })
        elseif effective_style == "clear" then
            local border_fg = tools.blend(colors.background, colors.foreground, 0.5)

            sethl("WinSeparator", { bg = colors.background, fg = border_fg })

            sethl("BlinkCmpMenuBorder", { bg = colors.background, fg = border_fg })
            sethl("BlinkCmpDocBorder", { bg = colors.background, fg = border_fg })
            sethl("BlinkCmpSignatureHelpBorder", { bg = colors.background, fg = border_fg })
            sethl("BlinkCmpMenu", { bg = colors.background })
            sethl("BlinkCmpDoc", { bg = colors.background })
            sethl("BlinkCmpSignatureHelp", { bg = colors.background })
            sethl("BlinkCmpLabelDescription", { bg = colors.background, fg = border_fg })
            sethl("BlinkCmpLabel", { bg = colors.background, fg = border_fg })
            sethl("BlinkCmpSource", { bg = "NONE", fg = colors.comment })
            sethl("LspInfoBorder", { bg = colors.background })
            sethl("NormalFloat", { bg = colors.background })
            sethl("FloatBorder", { fg = border_fg, bg = colors.background })
            sethl("SnacksPickerBorder", { fg = border_fg, bg = colors.background })
            sethl("WhichKeyNormal", { bg = colors.background })
            sethl("SnacksPickerInputBorder", { bg = colors.background, fg = border_fg })
        end
        sethl("LspSignatureActiveParameter", { bg = colors.str, bold = true, fg = colors.background })

        -- Cursor line handling
        if vim.o.cursorlineopt == "number" then
            sethl("CursorLine", { bg = "NONE" })
            sethl("CursorLineNr", { bg = "NONE" })
            sethl("CursorLineSign", { bg = "NONE" })
            sethl("CursorLineFold", { bg = "NONE" })
            sethl("FoldColumn", { bg = "NONE", fg = colors.comment })
            sethl("SignColumn", { bg = "NONE" })
            sethl("ColorColumn", { bg = "NONE" })
            sethl("CursorColumn", { bg = "NONE" })
        else
            sethl("CursorLineNr", { bg = colors.cursorline, fg = colors.constant })
            sethl("CursorLine", { bg = colors.cursorline })
        end

        -- Window bars and misc
        sethl("WinBar", { bg = tools.adjust_brightness(colors.background, 0.85) })
        sethl("WinBarNC", { bg = tools.adjust_brightness(colors.background, 0.95) })

        sethl("@markup.raw.block.markdown", { bg = "NONE" })
        -- mysethl("TinyInlineDiagnosticVirtualTextArrow", { bg = "NONE" })
        sethl("FloatTitle", { bg = colors.background })

        -- Multi-cursor
        sethl("MultiCursorCursor", { reverse = true })
        sethl("MultiCursorVisual", { link = "Visual" })
        sethl("MultiCursorSign", { link = "SignColumn" })
        sethl("MultiCursorMatchPreview", { link = "Search" })
        sethl("MultiCursorDisabledCursor", { reverse = true })
        sethl("MultiCursorDisabledVisual", { link = "Visual" })
        sethl("MultiCursorDisabledSign", { link = "SignColumn" })
        sethl("FloaTerminalBorder", {
            bg = colors.background,
            fg = colors.background,
        })

        sethl("Visual", {
            bg = vim.o.background == "dark" and "#1e3a5f" or "#ADCBEF",
            fg = "NONE",
        })

        -- Common completion highlights
        -- mysethl("BlinkCmpMenuSelection", { bg = colors.fun, fg = colors.background })
        sethl("BlinkCmpMenuSelection", {
            -- bg = vim.o.background == "dark" and tools.adjust_brightness(colors.fun, 0.4)
            --     or tools.adjust_brightness(colors.background, 0.87),
            bg = gethl("Visual").bg,
        })

        -- Git and usage
        sethl("GitSignsCurrentLineBlame", { fg = tools.adjust_brightness(colors.foreground, 0.8), italic = true })
        sethl("Usage", { link = "Comment" })
        sethl("SnacksPickerDir", { fg = tools.adjust_brightness(colors.foreground, 0.6) })
    end,
})
