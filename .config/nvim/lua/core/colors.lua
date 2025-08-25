local autocmd = vim.api.nvim_create_autocmd
local sethl = vim.api.nvim_set_hl

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
            background = gethl("Normal").bg,
            foreground = gethl("Normal").fg,
            comment = gethl("Comment").fg,
            cursorline = gethl("CursorLine").bg,
            pmenu = tools.style == "clear" and gethl("Pmenu").bg or tools.adjust_brightness(gethl("Normal").bg, 0.75),
            fun = gethl("Function").fg or "#375FAD",
            str = gethl("String").fg or "#7CA855",
            constant = gethl("Constant").fg,
            parenthesis = vim.o.background == "dark" and "#39ff14" or "#ff007f",
        }

        -- Basic UI elements
        sethl(0, "Cursor", { bg = colors.foreground })
        sethl(0, "HighlightUrl", { underline = true })
        sethl(0, "AlphaButton", { bg = colors.constant, bold = true, fg = colors.background })
        sethl(0, "LaravelLogo", { fg = "#F53003" })
        sethl(0, "MatchParen", { bg = "NONE", fg = colors.parenthesis })

        -- Diagnostics in gutter (no background)
        sethl(0, "DiagnosticSignError", { bg = "NONE", fg = colors.error })
        sethl(0, "DiagnosticSignWarn", { bg = "NONE", fg = colors.warn })
        sethl(0, "DiagnosticSignInfo", { bg = "NONE", fg = colors.info })
        sethl(0, "DiagnosticSignHint", { bg = "NONE", fg = colors.hint })

        -- Diagnostic underlines
        sethl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
        sethl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warn })
        sethl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
        sethl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

        -- LSP line number highlights
        sethl(0, "LspCursorLineNrError", { bg = colors.cursorline, fg = colors.error })
        sethl(0, "LspCursorLineNrWarning", { bg = colors.cursorline, fg = colors.warn })
        sethl(0, "LspCursorLineNrInformation", { bg = colors.cursorline, fg = colors.info })
        sethl(0, "LspCursorLineNrHint", { bg = colors.cursorline, fg = colors.hint })
        sethl(0, "LspDiagnosticsLineNrError", { fg = colors.error })
        sethl(0, "LspDiagnosticsLineNrWarning", { fg = colors.warn })
        sethl(0, "LspDiagnosticsLineNrInformation", { fg = colors.info })
        sethl(0, "LspDiagnosticsLineNrHint", { fg = colors.hint })

        -- Search highlights
        sethl(0, "HlSearchNear", { bg = "NONE", fg = colors.hint })
        sethl(0, "HlSearchLens", { bg = "NONE", fg = colors.hint })
        sethl(0, "HlSearchLensNear", { bg = "NONE", fg = colors.hint })

        -- Tree explorer cleanup
        sethl(0, "NvimTreeLineNr", { bg = gethl("NvimTreeNormal").bg })
        sethl(0, "NvimTreeWinSeparator", { bg = gethl("NvimTreeNormal").bg, fg = gethl("NvimTreeNormal").bg })
        sethl(0, "NeoTreeWinSeparator", { bg = gethl("NeoTreeNormal").bg, fg = gethl("NeoTreeNormal").bg })
        sethl(0, "NvimTreeEndOfBuffer", { bg = gethl("NvimTreeNormal").bg })
        sethl(0, "NvimTreeSignColumn", { bg = "NONE" })

        local effective_style = (vim.g.colors_name == "vercel") and "clear" or tools.style

        -- Style-specific completion highlights
        if effective_style == "flat" then
            sethl(0, "SnacksInputNormal", { bg = colors.pmenu, fg = colors.foreground })
            sethl(0, "SnacksInputBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl(0, "BlinkCmpSignatureHelp", { bg = colors.pmenu })
            sethl(0, "BlinkCmpSignatureHelpBorder", { bg = colors.pmenu, fg = colors.pmenu })

            -- local menu_bg = tools.adjust_brightness(colors.background, 0.75)
            sethl(0, "BlinkCmpMenu", { bg = colors.pmenu })
            sethl(0, "BlinkCmpMenuBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl(
                0,
                "BlinkCmpLabelDescription",
                { bg = colors.pmenu, fg = tools.adjust_brightness(colors.foreground, 0.4), italic = true }
            )

            local doc_bg = tools.adjust_brightness(colors.background, 0.87)
            sethl(0, "BlinkCmpDocBorder", { bg = doc_bg, fg = doc_bg })
            sethl(0, "BlinkCmpDoc", { bg = doc_bg })
            sethl(0, "BlinkCmpDocSeparator", { bg = doc_bg, fg = tools.adjust_brightness(colors.foreground, 0.7) })

            sethl(0, "LspInfoBorder", { bg = colors.pmenu })
            sethl(0, "NormalFloat", { bg = colors.pmenu })
            sethl(0, "FloatBorder", { fg = colors.pmenu, bg = colors.pmenu })
        elseif effective_style == "clear" then
            local border_fg = tools.adjust_brightness(colors.foreground, 0.6)
            sethl(0, "BlinkCmpMenuBorder", { bg = colors.background, fg = border_fg })
            sethl(0, "BlinkCmpDocBorder", { bg = colors.background, fg = border_fg })
            sethl(0, "BlinkCmpSignatureHelpBorder", { bg = colors.background, fg = border_fg })
            sethl(0, "BlinkCmpMenu", { bg = colors.background })
            sethl(0, "BlinkCmpDoc", { bg = colors.background })
            sethl(0, "BlinkCmpSignatureHelp", { bg = colors.background })
            sethl(0, "BlinkCmpLabelDescription", { bg = colors.background, fg = border_fg })
            sethl(0, "BlinkCmpSource", { bg = "NONE", fg = colors.comment })
            sethl(0, "LspInfoBorder", { bg = colors.background })
            sethl(0, "NormalFloat", { bg = colors.background })
            sethl(0, "FloatBorder", { fg = border_fg, bg = colors.background })
            sethl(0, "WhichKeyNormal", { bg = colors.background })
            sethl(0, "SnacksPickerInputBorder", { bg = colors.background, fg = gethl("SnacksPickerInputTitle").fg })
        end

        -- Common completion highlights
        sethl(0, "BlinkCmpMenuSelection", { bg = colors.fun, fg = colors.background })
        sethl(0, "LspSignatureActiveParameter", { bg = colors.str, bold = true, fg = colors.background })

        -- Cursor line handling
        if vim.o.cursorlineopt == "number" then
            sethl(0, "CursorLineNr", { bg = "NONE" })
            sethl(0, "CursorLineSign", { bg = "NONE" })
            sethl(0, "CursorLineFold", { bg = "NONE" })
            sethl(0, "FoldColumn", { bg = "NONE", fg = colors.comment })
            sethl(0, "SignColumn", { bg = "NONE" })
            sethl(0, "ColorColumn", { bg = "NONE" })
            sethl(0, "CursorColumn", { bg = "NONE" })
        else
            sethl(0, "CursorLineNr", { bg = colors.cursorline, fg = colors.constant, bold = true })
            sethl(0, "GitSignsAddCul", { bg = colors.cursorline, fg = tools.resolve_hl "GitSignsAdd" })
            sethl(0, "GitSignsChangeCul", { bg = colors.cursorline, fg = tools.resolve_hl "GitSignsChange" })
            sethl(0, "GitSignsDeleteCul", { bg = colors.cursorline, fg = tools.resolve_hl "GitSignsDelete" })
        end

        -- Window bars and misc
        sethl(0, "WinBar", { bg = tools.adjust_brightness(colors.background, 0.75) })
        sethl(0, "WinBarNC", { bg = tools.adjust_brightness(colors.background, 0.90) })
        sethl(0, "@markup.raw.block.markdown", { bg = "NONE" })
        sethl(0, "TinyInlineDiagnosticVirtualTextArrow", { bg = "NONE" })
        sethl(0, "FloatTitle", { bg = colors.background })

        -- Multi-cursor
        sethl(0, "MultiCursorCursor", { reverse = true })
        sethl(0, "MultiCursorVisual", { link = "Visual" })
        sethl(0, "MultiCursorSign", { link = "SignColumn" })
        sethl(0, "MultiCursorMatchPreview", { link = "Search" })
        sethl(0, "MultiCursorDisabledCursor", { reverse = true })
        sethl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        sethl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

        -- Git and usage
        sethl(0, "GitSignsCurrentLineBlame", { fg = tools.adjust_brightness(colors.foreground, 0.8), italic = true })
        sethl(0, "Usage", { link = "Comment" })
        sethl(0, "SnacksPickerDir", { fg = tools.adjust_brightness(colors.foreground, 0.6) })

        -- LSP semantic highlights
        sethl(0, "@lsp.type.class", { link = "Structure" })
        sethl(0, "@lsp.type.decorator", { link = "Function" })
        sethl(0, "@lsp.type.enum", { link = "Type" })
        sethl(0, "@lsp.type.enumMember", { link = "Constant" })
        sethl(0, "@lsp.type.function", { link = "@function" })
        sethl(0, "@lsp.type.interface", { link = "Structure" })
        sethl(0, "@lsp.type.macro", { link = "@macro" })
        sethl(0, "@lsp.type.method", { link = "@function.method" })
        sethl(0, "@lsp.type.namespace", { link = "@module" })
        sethl(0, "@lsp.type.parameter", { link = "@variable.parameter" })
        sethl(0, "@lsp.type.property", { link = "@property" })
        sethl(0, "@lsp.type.struct", { link = "Structure" })
        sethl(0, "@lsp.type.type", { link = "@type" })
        sethl(0, "@lsp.type.typeParamater", { link = "TypeDef" })
        sethl(0, "@lsp.type.variable", { link = "@variable" })
    end,
})
