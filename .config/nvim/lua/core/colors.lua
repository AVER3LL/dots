local autocmd = vim.api.nvim_create_autocmd
local sethl = function(...)
    vim.api.nvim_set_hl(0, ...)
end

local gethl = tools.resolve_hl

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd({ "ColorScheme", "VimEnter" }, {
    desc = "Custom color tweaks for clean nvim appearance",
    group = augroup "prepare-colors-averell",
    callback = function()
        sethl("Normal", {
            bg = gethl("Normal").bg or vim.g.bg_color,
            fg = gethl("Normal").fg,
        })

        local colors = {
            error = gethl("DiagnosticError").fg or "#E05F6A",
            warn = gethl("DiagnosticWarn").fg or "#E0AF68",
            info = gethl("DiagnosticInfo").fg or "#56B6C2",
            hint = gethl("DiagnosticHint").fg or "#9A9AA1",
            background = gethl("Normal").bg or vim.g.bg_color,
            foreground = gethl("Normal").fg,
            comment = gethl("Comment").fg,
            cursorline = tools.colors.adjust_brightness(
                gethl("Normal").bg,
                vim.o.background == "dark" and 1.25 or 0.95
            ),
            pmenu = tools.style == "clear" and gethl("Pmenu").bg
                or tools.colors.darken(gethl("Normal").bg, vim.o.background == "dark" and 0.4 or 0.2),
            fun = gethl("Function").fg or "#375FAD",
            str = gethl("String").fg or "#7CA855",
            constant = gethl("Constant").fg,
            parenthesis = vim.o.background == "dark" and "#39ff14" or "#ff007f",
            subtle = tools.colors.blend(gethl("Normal").fg, gethl("Normal").bg, 0.15),
        }

        colors.cursorline = vim.list_contains({ "vercel", "moonfly" }, vim.g.colors_name)
                and tools.colors.lighten(gethl("Normal").bg, 1)
            or colors.cursorline

        -- Basic UI elements
        sethl("NonText", { fg = tools.colors.blend(colors.foreground, colors.background, 0.3) })
        sethl("Cursor", { bg = tools.colors.blend(colors.foreground, colors.background, 0.6) })
        -- sethl("Cursor", { bg = "#FF9E4A" })
        sethl("HighlightUrl", { underline = true })
        sethl("AlphaButton", { bg = colors.constant, bold = true, fg = colors.background })
        sethl("Laravel", { fg = "#F53003" })
        sethl("MatchParen", { bg = "NONE", fg = colors.parenthesis })

        -- Diagnostics in gutter (no background)
        sethl("DiagnosticSignError", { bg = "NONE", fg = colors.error })
        sethl("DiagnosticSignWarn", { bg = "NONE", fg = colors.warn })
        sethl("DiagnosticSignInfo", { bg = "NONE", fg = colors.info })
        sethl("DiagnosticSignHint", { bg = "NONE", fg = colors.hint })

        -- Look of inlay hints
        sethl("LspInlayHint", {
            fg = tools.colors.blend(colors.foreground, colors.background, 0.7),
            bg = tools.colors.blend(colors.foreground, colors.background, 0.05),
            italic = true,
        })

        -- Fold markers
        sethl("Folded", {
            bg = tools.colors.adjust_brightness(colors.background, vim.o.background == "light" and 0.95 or 1.3),
            fg = tools.colors.blend(colors.foreground, colors.background, 0.6),
        })

        -- Diagnostic underlines
        sethl("DiagnosticUnderlineError", { underdotted = true, sp = colors.error })
        sethl("DiagnosticUnderlineWarn", { underdotted = true, sp = colors.warn })
        sethl("DiagnosticUnderlineInfo", { underdotted = true, sp = colors.info })
        sethl("DiagnosticUnderlineHint", { underdotted = true, sp = colors.hint })

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
        sethl("NvimTreeNormalNC", { bg = colors.background })
        sethl("NvimTreeEndOfBuffer", { bg = colors.background })

        sethl("MiniPickMatchCurrent", { bg = colors.cursorline })
        local effective_style = vim.list_contains({ "vercel", "moonfly" }, vim.g.colors_name) and "clear" or tools.style

        sethl("SnacksPickerListCursorLine", { link = "SnacksPickerPreviewCursorLine" })
        sethl("SnacksPickerCursorLine", { link = "SnacksPickerPreviewCursorLine" })

        -- Style-specific completion highlights
        if effective_style == "flat" then
            -- local lighter_pmenu = tools.colors.adjust_brightness(colors.pmenu, 0.9)
            local lighter_pmenu = tools.colors.blend(colors.pmenu, colors.background, 0.9)
            local lighter_pmenu2 = tools.colors.blend(colors.pmenu, colors.background, 0.25)
            local black = "#17161C"

            sethl("MiniPickNormal", { bg = colors.pmenu, fg = colors.foreground })
            sethl("MiniPickBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl("MiniPickBorderBusy", { bg = colors.pmenu, fg = colors.pmenu })
            sethl("MiniPickBorderText", { link = "DiagnosticVirtualTextInfo" })
            sethl("MiniPickPromptPrefix", { bg = colors.pmenu, fg = gethl("Special").fg, default = true })
            sethl("MiniPickIconFile", { bg = colors.pmenu, fg = colors.comment })
            sethl("MiniPickMatchRanges", { fg = gethl("Special").fg, bold = true })
            sethl("MiniPickPrompt", { bg = colors.pmenu, fg = colors.foreground })

            -- TODO: update the colors here for the preview, input and result
            -- see => https://github.com/gisketch/dotfyles/blob/main/lua/plugins/colorscheme.lua
            -- sethl("SnacksPickerTitle", { link = "DiagnosticVirtualTextInfo" })
            sethl("SnacksPickerInput", { bg = lighter_pmenu, fg = colors.foreground })
            sethl("SnacksPickerInputBorder", { bg = lighter_pmenu, fg = lighter_pmenu })
            -- sethl("SnacksPickerInputTitle", { fg = colors.pmenu, bg = colors.fun, bold = true })
            sethl("SnacksPickerInputTitle", { fg = black, bg = colors.fun, bold = true })

            sethl("SnacksPickerList", { bg = lighter_pmenu2 })
            sethl("SnacksPickerListBorder", { bg = lighter_pmenu2, fg = lighter_pmenu2 })
            sethl("SnacksPickerListTitle", { fg = gethl("Special").fg, bg = lighter_pmenu2 })

            sethl("SnacksPickerPrompt", { bg = lighter_pmenu, fg = gethl("Special").fg })

            -- sethl("SnacksPickerPreviewTitle", { fg = colors.pmenu, bg = gethl("Identifier").fg })
            sethl("SnacksPickerPreviewTitle", { fg = black, bg = gethl("Identifier").fg, bold = true })
            sethl("SnacksPicker", { bg = colors.pmenu, fg = colors.foreground })
            sethl("SnacksPickerBorder", { bg = colors.pmenu, fg = colors.pmenu })
            -- sethl("SnacksPickerInputBorder", { bg = colors.pmenu, fg = colors.pmenu })

            sethl("SnacksInputNormal", { bg = colors.pmenu, fg = colors.foreground })
            sethl("SnacksInputBorder", { bg = colors.pmenu, fg = colors.pmenu })

            -- TODO: Investigate onedark's shenanigans
            -- mysethl("SnacksPickerBorder", { bg = colors.pmenu, fg = colors.pmenu })

            sethl("BlinkCmpSignatureHelp", { bg = lighter_pmenu2 })
            sethl("BlinkCmpSignatureHelpBorder", { bg = colors.pmenu, fg = colors.pmenu })

            -- local menu_bg = tools.colors.adjust_brightness(colors.background, 0.75)
            sethl("BlinkCmpMenu", { bg = colors.pmenu })
            sethl("BlinkCmpMenuBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl("BlinkCmpLabelDetail", { bg = colors.pmenu, fg = colors.comment, italic = true, bold = true })
            sethl(
                "BlinkCmpLabelDescription",
                { bg = colors.pmenu, fg = tools.colors.adjust_brightness(colors.foreground, 0.4), italic = true }
            )

            local doc_bg = tools.colors.adjust_brightness(colors.background, 0.87)
            sethl("BlinkCmpDocBorder", { bg = doc_bg, fg = doc_bg })
            sethl("BlinkCmpDoc", { bg = doc_bg })
            sethl("BlinkCmpSource", { bg = "NONE", fg = tools.colors.blend(colors.foreground, colors.pmenu, 0.4) })
            sethl("BlinkCmpDocSeparator", { bg = doc_bg, fg = tools.colors.adjust_brightness(colors.foreground, 0.7) })

            sethl("LspInfoBorder", { bg = colors.pmenu, fg = colors.pmenu })
            sethl("NormalFloat", { bg = colors.pmenu })
            sethl("FloatBorder", { fg = colors.pmenu, bg = colors.pmenu })
            sethl("WhichKeyBorder", { bg = colors.pmenu, fg = colors.pmenu })
        elseif effective_style == "clear" then
            local dimmed_fg = tools.colors.blend(colors.foreground, colors.background, 0.8)

            sethl(
                "WinSeparator",
                { bg = colors.background, fg = tools.colors.blend(colors.foreground, colors.background, 0.1) }
            )

            sethl("BlinkCmpMenuBorder", { bg = colors.background, fg = colors.subtle })
            sethl("BlinkCmpDocBorder", { bg = colors.background, fg = colors.subtle })
            sethl("BlinkCmpSignatureHelpBorder", { bg = colors.background, fg = colors.subtle })

            sethl("BlinkCmpMenu", { bg = colors.background })

            sethl("BlinkCmpDoc", { bg = colors.background })
            sethl("BlinkCmpSignatureHelp", { bg = colors.background })
            sethl("BlinkCmpLabelDescription", { bg = colors.background, fg = dimmed_fg })
            sethl("BlinkCmpLabel", { bg = colors.background, fg = dimmed_fg })
            sethl("BlinkCmpLabelDetail", { bg = colors.background, fg = colors.comment, italic = true, bold = true })
            sethl("BlinkCmpSource", { bg = "NONE", fg = colors.comment })
            sethl("LspInfoBorder", { bg = colors.background })
            sethl("NormalFloat", { bg = colors.background })
            sethl("FloatBorder", { fg = colors.subtle, bg = colors.background })
            sethl("SnacksPickerBorder", { fg = colors.subtle, bg = colors.background })
            sethl("WhichKeyNormal", { bg = colors.background })
            sethl("SnacksPickerInputBorder", { bg = colors.background, fg = colors.subtle })
        end

        sethl("FloaTerminalBorder", {
            bg = colors.background,
            fg = colors.background,
        })

        local kinds = {
            Constant = "Constant",
            Function = "Function",
            Identifier = "Identifier",
            Field = "Identifier",
            Variable = "Variable",
            Snippet = "Special",
            Text = "String",
            Structure = "Structure",
            Type = "Type",
            Keyword = "Keyword",
            Method = "Function",
            Constructor = "Special",
            Folder = "Directory",
            Module = "Include",
            Property = "Identifier",
            Enum = "Type",
            Unit = "Number",
            Class = "Type",
            File = "Directory",
            Interface = "Type",
            Color = "Special",
            Reference = "Tag",
            EnumMember = "Constant",
            Struct = "Structure",
            Value = "Number",
            Event = "Special",
            Operator = "Operator",
            TypeParameter = "Type",
            Copilot = "String",
            Codeium = "String",
            TabNine = "Special",
            SuperMaven = "Function",
        }

        for kind, base_group in pairs(kinds) do
            sethl("BlinkCmpKind" .. kind, { fg = gethl(base_group).fg })
        end

        sethl("BlinkCmpLabelMatch", { fg = gethl("Special").fg, bold = true })

        sethl("LspSignatureActiveParameter", { bg = colors.str, bold = true, fg = colors.background })

        if tools.transparent then
            sethl(
                "WinSeparator",
                { bg = colors.background, fg = tools.colors.blend(colors.foreground, colors.background, 0.3) }
            )
        end

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
        sethl("WinBar", { bg = tools.colors.darken(colors.background, 0.15) })
        sethl("WinBarNC", { bg = tools.colors.darken(colors.background, 0.10) })
        sethl("SCBorder", { bg = tools.colors.darken(colors.background, 0.15) })
        sethl("SCNormal", { bg = tools.colors.darken(colors.background, 0.15) })
        sethl("SCTitle", { bg = colors.fun, fg = tools.colors.darken(colors.background, 0.15), bold = true })

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

        sethl("Visual", {
            bg = vim.o.background == "dark" and "#1e3a5f" or "#ADCBEF",
            fg = "NONE",
        })

        -- Common completion highlights
        -- sethl("BlinkCmpMenuSelection", { bg = colors.fun, fg = colors.background })

        sethl("BlinkCmpMenuSelection", { bg = gethl("Visual").bg })
        -- sethl("BlinkCmpMenuSelection", { bg = tools.colors.blend(colors.foreground, colors.pmenu, 0.3) })

        -- Git and usage
        sethl(
            "GitSignsCurrentLineBlame",
            { fg = tools.colors.adjust_brightness(colors.foreground, 0.8), italic = true }
        )
        sethl("Usage", { link = "Comment" })
        sethl("SnacksPickerDir", { fg = tools.colors.adjust_brightness(colors.foreground, 0.6) })
    end,
})

autocmd("InsertEnter", {
    desc = "Change cursor color on insert enter",
    -- group = augroup "averell/cursor-thing",
    callback = function()
        local colors = {
            background = gethl("Normal").bg,
            cursor = gethl("Constant").fg or "#7CA855",
        }

        sethl("Cursor", { bg = tools.colors.blend(colors.cursor, colors.background, 0.9) })
    end,
})

autocmd("InsertLeave", {
    desc = "Change cursor color on insert leave",
    -- group = augroup "averell/cursor-thing",
    callback = function()
        local colors = {
            foreground = gethl("Normal").fg,
            background = gethl("Normal").bg,
        }

        sethl("Cursor", { bg = tools.colors.blend(colors.foreground, colors.background, 0.6) })
    end,
})
