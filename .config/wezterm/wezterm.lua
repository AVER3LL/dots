local wezterm = require("wezterm")
local commands = require("commands")

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

-- font settings
config.font_size = 15
config.line_height = 1.5
-- config.font = wezterm.font("JetBrainsMono NF")
config.font = wezterm.font("Monaspace Neon")

-- Colors
-- config.colors = {
-- 	cursor_bg = "white",
-- 	cursor_border = "white",
-- }

-- Appearance
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.color_scheme = "Apple System Colors"
-- config.default_cursor_style = "BlinkingBar",
-- config.cursor_thickness = 2,
-- config.cursor_blink_rate = 600,

-- Misceallanious settings
config.max_fps = 60
config.prefer_egl = true
config.enable_kitty_graphics = true
config.enable_kitty_keyboard = true

config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Custom commands
wezterm.on("augment-command-palette", function(_)
	return commands
end)

return config
