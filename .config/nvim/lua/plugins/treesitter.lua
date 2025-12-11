-- Highlight, edit, and navigate code.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        version = false,
        build = ":TSUpdate",
        init = function()
            local ensure_installed = {
                "c",
                "lua",
                "markdown",
                "markdown_inline",
                "query",
                "vim",
                "vimdoc",
                -- NOTE: the above are natively installed since neovim 0.12
                "bash",
                "diff",
                "dockerfile",
                "gitignore",
                "git_config",
                "luadoc",
                "regex",
                "toml",
                "yaml",
                "csv",
                "java",
                "python",
                "html",
                "css",
                "javascript",
                "typescript",
                "json",
                "php",
                "phpdoc",
                "blade",
                "cpp",
                "fish",
                "gitcommit",
                "go",
                "graphql",
                "hyprlang",
                "javadoc",
                "json5",
                "jsonc",
                "rasi",
                "rust",
                "kitty",
                "scss",
                "tsx",
            }

            local isnt_installed = function(lang)
                return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
            end
            local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
            if #to_install > 0 then
                require("nvim-treesitter").install(to_install)
            end

            -- Ensure tree-sitter enabled after opening a file for target language
            local filetypes = {}
            for _, lang in ipairs(ensure_installed) do
                for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
                    table.insert(filetypes, ft)
                end
            end
            local ts_start = function(ev)
                vim.treesitter.start(ev.buf)
            end

            -- WARN: Do not use "*" here - snacks.nvim is buggy and vim.notify triggers FileType events internally causing infinite callback loops
            -- vim.api.nvim_create_autocmd("FileType", {
            --     desc = "Start treesitter",
            --     group = vim.api.nvim_create_augroup("start_treesitter", { clear = true }),
            --     pattern = filetypes,
            --     callback = ts_start,
            -- })

            -- Copied this here https://github.com/MeanderingProgrammer/treesitter-modules.nvim
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter.setup", {}),
                callback = function(args)
                    local buf = args.buf
                    local filetype = args.match

                    -- you need some mechanism to avoid running on buffers that do not
                    -- correspond to a language (like oil.nvim buffers), this implementation
                    -- checks if a parser exists for the current language
                    local language = vim.treesitter.language.get_lang(filetype) or filetype
                    if not vim.treesitter.language.add(language) then
                        return
                    end

                    -- replicate `fold = { enable = true }`
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

                    -- replicate `highlight = { enable = true }`
                    vim.treesitter.start(buf, language)

                    -- replicate `indent = { enable = true }`
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    -- `incremental_selection = { enable = true }` cannot be easily replicated
                end,
            })
        end,
        config = function()
            require("nvim-treesitter").setup()
        end,
    },
}

