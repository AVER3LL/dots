return {
    "mason-org/mason.nvim",
    lazy = true,
    opts = {
        ui = {
            icons = {
                package_pending = " ",
                package_installed = " ",
                package_uninstalled = " ",
            },
        },
        max_concurrent_installers = 10,
    },
}
