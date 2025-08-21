local autocmd = vim.api.nvim_create_autocmd
local sethl = vim.api.nvim_set_hl

local function gethl(name)
    return vim.api.nvim_get_hl(0, { name = name })
end

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd("ColorScheme", {
    desc = "Tweaks some color to make nvim clean",
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

            pmenu = gethl("Pmenu").bg,
            fun = gethl("Function").fg or "#375FAD",
            str = gethl("String").fg,

            parenthesis = (vim.o.background == "dark") and "#39ff14" or "#ff007f",
        }

        -- Change the color of the cursor
        sethl(0, "Cursor", { bg = colors.foreground })
        -- if vim.o.background == "light" then
        -- end

        sethl(0, "LspCursorLineNrError", { bg = colors.cursorline, fg = colors.error })
        sethl(0, "LspCursorLineNrWarning", { bg = colors.cursorline, fg = colors.warn })
        sethl(0, "LspCursorLineNrInformation", { bg = colors.cursorline, fg = colors.info })
        sethl(0, "LspCursorLineNrHint", { bg = colors.cursorline, fg = colors.hint })

        sethl(0, "HighlightUrl", { underline = true })

        -- sethl(0, "CurrentWord", { bg = "NONE", bold = true })
        -- sethl(0, "AlphaButton", { bg = gethl(0, { name = "Number" }).fg, bold = true, fg = colors.background })

        sethl(0, "AlphaButton", {
            bg = gethl("Constant").fg,
            bold = true,
            fg = colors.background,
        })

        sethl(0, "LaravelLogo", { fg = "#F53003" })

        -- Highlight line numbers with diagnostics
        sethl(0, "LspDiagnosticsLineNrError", { fg = colors.error })
        sethl(0, "LspDiagnosticsLineNrWarning", { fg = colors.warn })
        sethl(0, "LspDiagnosticsLineNrInformation", { fg = colors.info })
        sethl(0, "LspDiagnosticsLineNrHint", { fg = colors.hint })

        sethl(0, "HlSearchNear", { bg = "NONE", fg = colors.hint })
        sethl(0, "HlSearchLens", { bg = "NONE", fg = colors.hint })
        sethl(0, "HlSearchLensNear", { bg = "NONE", fg = colors.hint })

        -- Cleaning the gutter
        sethl(0, "DiagnosticSignError", { bg = "NONE", fg = colors.error })
        sethl(0, "DiagnosticSignWarn", { bg = "NONE", fg = colors.warn })
        sethl(0, "DiagnosticSignInfo", { bg = "NONE", fg = colors.info })
        sethl(0, "DiagnosticSignHint", { bg = "NONE", fg = colors.hint })

        -- Doing this because of monokai-pro shenanigans
        -- sethl(0, "NonText", { fg = tools.adjust_brightness(colors.foreground, 0.7) })

        -- Cleans tinyInlineDiagnostic
        sethl(0, "TinyInlineDiagnosticVirtualTextArrow", { bg = "NONE" })

        -- Add underlined diagnostics regardless of theme
        sethl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.error })
        sethl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warn })
        sethl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
        sethl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint })

        -- Clean nvim-tree
        sethl(0, "NvimTreeLineNr", { bg = gethl("NvimTreeNormal").bg })
        sethl(0, "NvimTreeWinSeparator", { bg = colors.background, fg = colors.background })
        sethl(0, "NvimTreeEndOfBuffer", { bg = gethl("NvimTreeNormal").bg })
        sethl(0, "NvimTreeSignColumn", { bg = "NONE" })

        if tools.style == "flat" then
            sethl(0, "SnacksInputNormal", { bg = colors.pmenu, fg = colors.foreground })
            sethl(0, "SnacksInputBorder", { bg = colors.pmenu, fg = colors.pmenu })

            sethl(0, "BlinkCmpSignatureHelp", { bg = colors.pmenu })
            sethl(0, "BlinkCmpSignatureHelpBorder", { bg = colors.pmenu, fg = colors.pmenu })
            -- sethl(0, "SnacksPickerNormal", { bg = colors.pmenu, fg = adjust_brightness(colors.foreground, 0.5) })

            -- sethl(0, "BlinkCmpSignatureHelpActiveParameter", { bg = colors.pmenu })

            sethl(0, "BlinkCmpMenu", { bg = tools.adjust_brightness(colors.background, 0.75) })
            sethl(0, "BlinkCmpMenuBorder", {
                bg = tools.adjust_brightness(colors.background, 0.75),
                fg = tools.adjust_brightness(colors.background, 0.75),
            })
            sethl(0, "BlinkCmpLabelDescription", {
                bg = tools.adjust_brightness(colors.background, 0.75),
                fg = tools.adjust_brightness(colors.foreground, 0.4),
                italic = true,
            })

            sethl(0, "BlinkCmpDocBorder", {
                bg = tools.adjust_brightness(colors.background, 0.87),
                fg = tools.adjust_brightness(colors.background, 0.87),
            })
            sethl(0, "BlinkCmpDoc", { bg = tools.adjust_brightness(colors.background, 0.87) })
            sethl(0, "BlinkCmpDocSeparator", {
                bg = tools.adjust_brightness(colors.background, 0.87),
                fg = tools.adjust_brightness(colors.foreground, 0.7),
            })

            sethl(0, "LspInfoBorder", { bg = colors.pmenu })
            sethl(0, "NormalFloat", { bg = colors.pmenu })
            sethl(0, "FloatBorder", { fg = colors.pmenu, bg = colors.pmenu })
        elseif tools.style == "clear" then
            sethl(
                0,
                "BlinkCmpMenuBorder",
                { bg = colors.background, fg = tools.adjust_brightness(colors.foreground, 0.6) }
            )
            sethl(
                0,
                "BlinkCmpDocBorder",
                { bg = colors.background, fg = tools.adjust_brightness(colors.foreground, 0.6) }
            )
            sethl(
                0,
                "BlinkCmpSignatureHelpBorder",
                { bg = colors.background, fg = tools.adjust_brightness(colors.foreground, 0.6) }
            )
            sethl(0, "BlinkCmpMenu", { bg = colors.background })
            sethl(0, "BlinkCmpDoc", { bg = colors.background })
            sethl(0, "BlinkCmpSignatureHelp", { bg = colors.background })
            sethl(
                0,
                "BlinkCmpLabelDescription",
                { bg = colors.background, fg = tools.adjust_brightness(colors.foreground, 0.6) }
            )

            sethl(0, "BlinkCmpSource", { bg = "NONE", fg = colors.comment })

            sethl(0, "LspInfoBorder", { bg = colors.background })
            sethl(0, "NormalFloat", { bg = colors.background })
            sethl(0, "FloatBorder", { fg = tools.adjust_brightness(colors.foreground, 0.6), bg = colors.background })
            -- sethl(0, "@spell.markdown", { fg = tools.adjust_brightness(colors.foreground, 0.5), bg = colors.background })

            -- Doing this because of tokyonight
            sethl(0, "WhichKeyNormal", { bg = colors.background })
            sethl(0, "SnacksPickerInputBorder", { bg = colors.background, fg = gethl("SnacksPickerInputTitle").fg })
        end

        sethl(0, "WinBar", { bg = tools.adjust_brightness(colors.background, 0.75) })
        sethl(0, "WinBarNC", { bg = tools.adjust_brightness(colors.background, 0.90) })

        sethl(0, "@markup.raw.block.markdown", { bg = "NONE" })

        sethl(0, "MultiCursorCursor", { reverse = true })
        sethl(0, "MultiCursorVisual", { link = "Visual" })
        sethl(0, "MultiCursorSign", { link = "SignColumn" })
        sethl(0, "MultiCursorMatchPreview", { link = "Search" })
        sethl(0, "MultiCursorDisabledCursor", { reverse = true })
        sethl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        sethl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

        sethl(0, "GitSignsCurrentLineBlame", { fg = tools.adjust_brightness(colors.foreground, 0.8), italic = true })
        -- sethl(0, "Usage", { fg = tools.adjust_brightness(colors.foreground, 0.6) })
        sethl(0, "Usage", { link = "Comment" })
        sethl(0, "SnacksPickerDir", { fg = tools.adjust_brightness(colors.foreground, 0.6) })

        sethl(0, "FloatTitle", { bg = colors.background })

        -- sethl(0, "BlinkCmpMenuSelection", { bg = tools.adjust_brightness(colors.fun, 0.4) })
        sethl(0, "BlinkCmpMenuSelection", { bg = colors.fun, fg = colors.background })

        sethl(0, "LspSignatureActiveParameter", { bg = colors.str, bold = true, fg = colors.background })

        -- sethl(0, "Comment", { fg = "#008c7d", italic = true })

        -- Matching parentheses colors
        sethl(0, "MatchParen", { bg = "NONE", fg = colors.parenthesis })

        -- Remove background color from line numbers
        if vim.o.cursorlineopt == "number" then
            sethl(0, "CursorLineNr", { bg = "NONE" })
            sethl(0, "CursorLineSign", { bg = "NONE" })
            sethl(0, "CursorLineFold", { bg = "NONE" })
            sethl(0, "FoldColumn", { bg = "NONE", fg = colors.comment })
            sethl(0, "SignColumn", { bg = "NONE" })
            sethl(0, "ColorColumn", { bg = "NONE" })
            sethl(0, "CursorColumn", { bg = "NONE" })
        else
            sethl(0, "CursorLineNr", {
                bg = gethl("CursorLine").bg,
                fg = gethl("Constant").fg,
                bold = true,
            })
            -- When a line does not have a sign, we dont have a background for the gitsign part
            sethl(0, "GitSignsAddCul", { bg = colors.cursorline, fg = tools.resolve_hl "GitSignsAdd" })
            sethl(0, "GitSignsChangeCul", { bg = colors.cursorline, fg = tools.resolve_hl "GitSignsChange" })
            sethl(0, "GitSignsDeleteCul", { bg = colors.cursorline, fg = tools.resolve_hl "GitSignsDelete" })
        end

        -- treesitter highlights
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
