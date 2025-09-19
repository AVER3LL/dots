vim.o.shiftwidth = 4

local jdtls = require "jdtls"

local extendedClientCapabilities = jdtls.extendedClientCapabilities

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_path = vim.fn.stdpath "data" .. "/jdtls-workspace/"
local workspace_dir = workspace_path .. project_name

local config = {

    name = "jdtls",

    cmd = {
        "jdtls",
        "-data",
        workspace_dir,
        "-Xmx2g",
        "-XX:TieredStopAtLevel=1",
        "-Xmx2g",
        "-XX:TieredStopAtLevel=1",
    },

    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

    settings = {
        java = {
            completion = {
                maxResults = 500,
            },
            foldingRange = {
                enabled = false, -- treesitter
            },
            selectionRange = {
                enabled = false, -- treesitter
            },
            referencesCodeLens = {
                enabled = false, -- slow
            },
            implementationsCodeLens = {
                enabled = false, -- slow
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            signatureHelp = {
                enabled = true,
                description = {
                    enabled = true,
                },
            },
        },
    },

    capabilities = require("lsp").capabilities,

    init_options = {
        shouldLanguageServerExitOnShutdown = true,
        bundles = {},
    },

    flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 300,
        exit_timeout = 500,
    },

    -- stop the aggressive completion triggering: disable ' ' and '*'
    on_init = function(client)
        client.server_capabilities.completionProvider.triggerCharacters = { ".", "@", "#" }
    end,

    handlers = {
        --- filter noisy notifications
        --- @param err lsp.ResponseError error
        --- @param result lsp.ProgressParams progress message
        --- @param ctx lsp.HandlerContext context
        ["$/progress"] = function(err, result, ctx)
            --- @type string?
            local msg = result.value and result.value["message"] or nil
            if msg and vim.startswith(msg, "Validate documents") then
                return
            end
            if msg and vim.startswith(msg, "Publish Diagnostics") then
                return
            end
            -- pass through to normal handler
            vim.lsp.handlers["$/progress"](err, result, ctx)
        end,
    },
}

jdtls.start_or_attach(config)
