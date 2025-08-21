return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local jdtls = require "jdtls"

            local extendedClientCapabilities = jdtls.extendedClientCapabilities

            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_path = vim.fn.stdpath "data" .. "/jdtls-workspace/"
            local workspace_dir = workspace_path .. project_name

            local mason_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
            local launcher_path = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
            local config_path = mason_path .. "/config_linux/"

            local config = {

                cmd = {
                    "java",
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Dlog.protocol=true",
                    "-Dlog.level=ALL",
                    "-Xmx1g",
                    "--add-modules=ALL-SYSTEM",
                    "--add-opens",
                    "java.base/java.util=ALL-UNNAMED",
                    "--add-opens",
                    "java.base/java.lang=ALL-UNNAMED",
                    "-jar",
                    launcher_path,
                    "-configuration",
                    config_path,
                    "-data",
                    workspace_dir,
                },

                root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        extendedClientCapabilities = extendedClientCapabilities,
                        -- updateBuildConfiguration = "disabled",
                        maven = {
                            downloadSources = true,
                        },
                        referencesCodeLens = {
                            enabled = true,
                        },
                        references = {
                            includeDecompiledSources = true,
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "all", -- literals, all, none
                            },
                        },
                        format = {
                            enabled = false,
                        },
                    },
                },

                init_options = {
                    bundles = {},
                },
            }

            jdtls.start_or_attach(config)
        end,
    },
}
