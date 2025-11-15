-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
-- This is where you actually apply your config choices.
config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757',
  },
}
-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 12.5
config.font = wezterm.font {
  family = 'GeistMono Nerd Font',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
config.color_scheme = 'purplepeter'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- keybindings
config.keys = {
  { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = wezterm.action.ActivateTab(8) },
  { key = '0', mods = 'ALT', action = wezterm.action.ActivateTab(9) },

  -- tab-management
  { key = 'w', mods = 'ALT', action = wezterm.action.CloseCurrentTab{ confirm = true } },
  { key = 't', mods = 'ALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
}
-- Finally, return the configuration to wezterm:
return config
