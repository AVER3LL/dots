return {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic",
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
