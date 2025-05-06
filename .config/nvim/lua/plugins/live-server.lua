return {
    "barrett-ruth/live-server.nvim",
    ft = { "html" },
    build = "npm i -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    config = true,
}
