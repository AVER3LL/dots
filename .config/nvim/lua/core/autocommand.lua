local autocmd = vim.api.nvim_create_autocmd

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

vim.g.autosave_enabled = false

local function toggle_autosave()
    vim.g.autosave_enabled = not vim.g.autosave_enabled
    if vim.g.autosave_enabled then
        vim.notify("Autosave enabled", vim.log.levels.INFO)
    else
        vim.notify("Autosave disabled", vim.log.levels.INFO)
    end
end

vim.api.nvim_create_user_command("ToggleAutosave", toggle_autosave, {})

vim.keymap.set("n", "<leader>ta", toggle_autosave, {
    desc = "toggle autosave",
    silent = true,
})

-- Autosave as you type, but keep original undo point on mark 'Z'
vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
        if vim.g.autosave_enabled then
            local buf = vim.api.nvim_get_current_buf()
            local filetype = vim.bo[buf].filetype
            local ignore_ft = { "TelescopePrompt", "neo-tree", "NvimTree" }
            if not vim.tbl_contains(ignore_ft, filetype) then
                vim.cmd "silent! write"
            end
        end
    end,
})

-- vim.api.nvim_create_autocmd("ColorScheme", {
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
