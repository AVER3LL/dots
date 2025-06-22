local autocmd = vim.api.nvim_create_autocmd
local sethl = vim.api.nvim_set_hl
local gethl = vim.api.nvim_get_hl

--- @type "flat" | "clear"
local style = "flat"

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

local signature = true

if signature then
    autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if client then
                local signatureProvider = client.server_capabilities.signatureHelpProvider
                if signatureProvider and signatureProvider.triggerCharacters then
                    require("config.signature").setup(client, args.buf)
                end
            end
        end,
    })
end

local the_group = augroup "lsp_blade_workaround"
-- Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation
autocmd({ "BufRead", "BufNewFile" }, {
    group = the_group,
    pattern = "*.blade.php",
    callback = function()
        vim.bo.filetype = "php"
    end,
})

-- Additional autocomman to switch back to 'blade' after LSP has attached
autocmd("LspAttach", {
    pattern = "*.blade.php",
    callback = function(args)
        vim.schedule(function()
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf

            if client and client.name == "intelephense" then
                -- Set filetype using treesitter or vim.filetype API
                vim.bo[bufnr].filetype = "blade"
                -- Optionally set syntax manually (though unnecessary if filetype is correct)
                vim.treesitter.start(bufnr, "blade")
            end
        end)
    end,
})

-- make $ part of the keyword for php
autocmd("FileType", {
    pattern = "php",
    callback = function()
        vim.opt_local.iskeyword:append "$"
    end,
})

-- Don't auto comment new line when pressing o, O or <CR>
-- autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

--Highlight when yanking (copying) text
autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank {
            timeout = 150,
            priority = 250,
        }
    end,
})

autocmd("FileType", {
    group = vim.api.nvim_create_augroup("mariasolos/treesitter_folding", { clear = true }),
    desc = "Enable Treesitter folding",
    callback = function(args)
        local bufnr = args.buf

        -- Enable Treesitter folding when not in huge files and when Treesitter
        -- is working.
        if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
            vim.api.nvim_buf_call(bufnr, function()
                vim.wo[0][0].foldmethod = "expr"
                vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.cmd.normal "zx"
            end)
        else
            -- Else just fallback to using indentation.
            vim.wo[0][0].foldmethod = "indent"
        end
    end,
})

--- Function written solely by an AI. The purpose was to get
--- a color that could be used for borders no matter the theme
local function adjust_brightness(color, amount)
    -- Extract RGB components
    local r = bit.rshift(color, 16) % 256
    local g = bit.rshift(color, 8) % 256
    local b = color % 256

    -- Apply brightness adjustment directly
    -- Positive amount brightens, negative darkens
    r = math.min(255, math.max(0, math.floor(r * amount)))
    g = math.min(255, math.max(0, math.floor(g * amount)))
    b = math.min(255, math.max(0, math.floor(b * amount)))

    -- Convert back to hex
    return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
end

autocmd("ColorScheme", {
    desc = "Tweaks some color to make nvim clean",
    group = vim.api.nvim_create_augroup("prepare-colors-averell", { clear = true }),
    callback = function()
        local error_fg = gethl(0, { name = "DiagnosticError" }).fg
        local warn_fg = gethl(0, { name = "DiagnosticWarn" }).fg
        local info_fg = gethl(0, { name = "DiagnosticInfo" }).fg
        local hint_fg = gethl(0, { name = "DiagnosticHint" }).fg
        local pmenu_bg = gethl(0, { name = "Pmenu" }).bg

        -- Highlight line numbers with diagnostics
        sethl(0, "LspDiagnosticsLineNrError", { fg = error_fg })
        sethl(0, "LspDiagnosticsLineNrWarning", { fg = warn_fg })
        sethl(0, "LspDiagnosticsLineNrInformation", { fg = info_fg })
        sethl(0, "LspDiagnosticsLineNrHint", { fg = hint_fg })

        sethl(0, "HlSearchNear", { bg = "NONE", fg = hint_fg })
        sethl(0, "HlSearchLens", { bg = "NONE", fg = hint_fg })
        sethl(0, "HlSearchLensNear", { bg = "NONE", fg = hint_fg })

        -- Cleaning the gutter
        sethl(0, "DiagnosticSignError", { bg = "NONE" })
        sethl(0, "DiagnosticSignWarn", { bg = "NONE" })
        sethl(0, "DiagnosticSignInfo", { bg = "NONE" })
        sethl(0, "DiagnosticSignHint", { bg = "NONE" })

        -- Cleans tinyInlineDiagnostic
        sethl(0, "TinyInlineDiagnosticVirtualTextArrow", { bg = "NONE" })

        -- Add underlined diagnostics regardless of theme
        sethl(0, "DiagnosticUnderlineError", { undercurl = true, sp = error_fg })
        sethl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = warn_fg })
        sethl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = info_fg })
        sethl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = hint_fg })

        -- Modern looking floating windows
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        local normal_fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg
        local comment_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
        local sel_bg = gethl(0, { name = "PmenuSel" }).bg

        -- Clean nvim-tree
        sethl(0, "NvimTreeLineNr", { bg = gethl(0, { name = "NvimTreeNormal" }).bg })
        sethl(0, "NvimTreeWinSeparator", { bg = normal_bg, fg = normal_bg })
        sethl(0, "NvimTreeEndOfBuffer", { bg = gethl(0, { name = "NvimTreeNormal" }).bg })
        sethl(0, "NvimTreeSignColumn", { bg = "NONE" })

        if style == "flat" then
            sethl(0, "BlinkCmpMenuBorder", { bg = pmenu_bg, fg = pmenu_bg })
            sethl(0, "BlinkCmpDocBorder", { bg = pmenu_bg, fg = pmenu_bg })
            sethl(0, "BlinkCmpDocSeparator", { bg = pmenu_bg, fg = adjust_brightness(normal_fg, 0.7) })
            sethl(0, "BlinkCmpSignatureHelp", { bg = "NONE", fg = normal_bg })

            -- sethl(0, "BlinkCmpMenuSelection", { link = "PmenuSel", bold = true })
            sethl(0, "BlinkCmpMenuSelection", { bg = adjust_brightness(pmenu_bg, 0.9), bold = true })
            sethl(0, "BlinkCmpMenu", { bg = pmenu_bg })
            sethl(0, "BlinkCmpDoc", { bg = pmenu_bg })

            sethl(0, "LspInfoBorder", { bg = pmenu_bg })
            -- sethl(0, "SnacksPickerBorder", { bg = normal_bg, fg = adjust_brightness(normal_fg, 0.3) })
            sethl(0, "NormalFloat", { bg = pmenu_bg })
            sethl(0, "FloatBorder", { fg = pmenu_bg, bg = pmenu_bg })
        elseif style == "clear" then
            sethl(0, "BlinkCmpMenuBorder", { bg = normal_bg, fg = adjust_brightness(normal_fg, 0.7) })
            sethl(0, "BlinkCmpDocBorder", { bg = normal_bg, fg = adjust_brightness(normal_fg, 0.7) })
            sethl(0, "BlinkCmpMenu", { bg = normal_bg })
            sethl(0, "BlinkCmpDoc", { bg = normal_bg })

            sethl(0, "LspInfoBorder", { bg = normal_bg })
            sethl(0, "NormalFloat", { bg = normal_bg })
            sethl(0, "FloatBorder", { fg = adjust_brightness(normal_fg, 0.7), bg = normal_bg })
        end

        sethl(0, "WinBar", { bg = normal_bg })
        sethl(0, "WinBarNC", { bg = normal_bg })

        sethl(0, "FloatTitle", { bg = normal_bg })

        sethl(0, "Comment", { fg = "#008c7d", italic = true })

        -- Matching parentheses colors
        local paren_color = (vim.o.background == "dark") and "#39ff14" or "#ff007f"
        sethl(0, "MatchParen", { bg = "NONE", fg = paren_color })

        -- Remove background color from line numbers
        sethl(0, "CursorLineNr", { bg = "NONE" })
        sethl(0, "CursorLineSign", { bg = "NONE" })
        sethl(0, "CursorLineFold", { bg = "NONE" })
        sethl(0, "FoldColumn", { bg = "NONE", fg = comment_fg })
        sethl(0, "SignColumn", { bg = "NONE" })
        sethl(0, "ColorColumn", { bg = "NONE" })
        sethl(0, "CursorColumn", { bg = "NONE" })

        -- vim.cmd "highlight Winbar guibg=none"
    end,
})

-- Auto-resize windows when Vim is resized
autocmd("VimResized", {
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
    group = augroup "json_conceal",
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Notifications when a macro starts
autocmd("RecordingEnter", {
    callback = function()
        local reg = vim.fn.reg_recording()
        vim.notify("Recording macro @" .. reg, vim.log.levels.INFO, { title = "Macro" })
    end,
})

autocmd("RecordingLeave", {
    callback = function()
        vim.notify("Stopped recording macro", vim.log.levels.INFO, { title = "Macro" })
    end,
})

-- close some filetypes with <q>
autocmd("FileType", {
    group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "scratch",
        "spectre_panel",
        "grug-far",
        "vim",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
