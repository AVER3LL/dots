local autocmd = vim.api.nvim_create_autocmd

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

-- don't auto comment new line
-- autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

--Highlight when yanking (copying) text
autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank {
            timeout = 150,
        }
    end,
})

autocmd("ColorScheme", {
    callback = function()
        -- Highlight line numbers with diagnostics
        vim.api.nvim_set_hl(0, "LspDiagnosticsLineNrError", { link = "DiagnosticSignError" })
        vim.api.nvim_set_hl(0, "LspDiagnosticsLineNrWarning", { link = "DiagnosticSignWarn" })
        vim.api.nvim_set_hl(0, "LspDiagnosticsLineNrInformation", { link = "DiagnosticSignInfo" })
        vim.api.nvim_set_hl(0, "LspDiagnosticsLineNrHint", { link = "DiagnosticSignHint" })

        -- Modern looking floating windows
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        local normal_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
        vim.api.nvim_set_hl(0, "LspInfoBorder", { bg = normal_bg })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = normal_fg, bg = normal_bg })
        vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE", fg = normal_fg })

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
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup "json_conceal",
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
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
        "spectre_panel",
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

-- autocmd("ColorScheme", {
--     callback = function()
--         vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E29B1F" })
--         vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#D46EC6" })
--         vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#179BD7" })
--         vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#FFCF08" })
--         vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#DA6CB1" })
--         vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#ca72e1" })
--         vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#5ccfe1" })
--     end,
-- })
