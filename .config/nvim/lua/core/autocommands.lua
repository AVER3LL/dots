local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

if vim.g.enable_signature then
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

-- Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation
autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup "lsp_blade_workaround",
    pattern = "*.blade.php",
    callback = function()
        vim.bo.filetype = "php"
    end,
})

-- Additional autocommand to switch back to 'blade' after LSP has attached
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

--Highlight when yanking (copying) text
autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup "kickstart-highlight-yank",
    callback = function()
        vim.hl.on_yank {
            timeout = 150,
            priority = 250,
        }
    end,
})

-- autocmd("BufEnter", {
--     callback = function()
--         if vim.bo.filetype == "markdown" and vim.bo.buftype == "nofile" then
--             vim.notify "innit"
--             vim.cmd [[ setlocal concealcursor=n ]]
--             vim.cmd [[ setlocal conceallevel=1 ]]
--             -- vim.wo.conceallevel = 3
--             -- vim.wo.concealcursor = "n"
--         end
--     end,
-- })

-- Do not comment new lines
autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- autocmd("FileType", {
--     group = augroup "mariasolos/treesitter_folding",
--     desc = "Enable Treesitter folding",
--     callback = function(args)
--         local bufnr = args.buf
--
--         -- Enable Treesitter folding when not in huge files and when Treesitter
--         -- is working.
--         if vim.bo[bufnr].filetype ~= "bigfile" and pcall(vim.treesitter.start, bufnr) then
--             vim.api.nvim_buf_call(bufnr, function()
--                 vim.wo[0][0].foldmethod = "expr"
--                 vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
--                 vim.cmd.normal "zx"
--             end)
--         else
--             -- Else just fallback to using indentation.
--             vim.wo[0][0].foldmethod = "indent"
--         end
--     end,
-- })

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
    group = augroup "close_with_q",
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
