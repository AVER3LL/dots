---@class vim.lsp.Config
local basedpyright = {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                inlayHints = {
                    callArgumentNames = true,
                },
                diagnosticSeverityOverrides = {
                    reportUnknownVariableType = "none",
                    reportUnknownMemberType = "none",
                    reportImplicitRelativeImport = "none",
                    reportMissingTypeStubs = "none",
                    reportAttributeAccessIssue = "none",
                },
            },
        },
    },
}

return basedpyright
