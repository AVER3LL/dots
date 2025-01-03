return {
    "barrett-ruth/live-server.nvim",
    ft = { "html", "htmldjango" },
    build = "npm i -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    config = true,
}
