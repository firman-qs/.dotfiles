local wezterm = require("wezterm")
local keybinding = require("keybinding")
local config = {}

config.color_scheme = "Modus-Vivendi-Deuteranopia"
config.font = wezterm.font_with_fallback({
   "JetBrainsMono Nerd Font",
})
config.line_height = 1.1
config.font_size = 12.0

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.colors = {
   tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = "#1e2326",

      -- The active tab is the one that has focus in the window
      active_tab = {
         -- The color of the background area for the tab
         bg_color = "#2d353b",
         -- The color of the text for the tab
         fg_color = "#d3c6aa",

         -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
         -- label shown for this tab.
         -- The default is "Normal"
         intensity = "Normal",

         -- Specify whether you want "None", "Single" or "Double" underline for
         -- label shown for this tab.
         -- The default is "None"
         underline = "None",

         -- Specify whether you want the text to be italic (true) or not (false)
         -- for this tab.  The default is false.
         italic = false,

         -- Specify whether you want the text to be rendered with strikethrough (true)
         -- or not for this tab.  The default is false.
         strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
         bg_color = "#222222",
         fg_color = "#808080",

         -- The same options that were listed under the `active_tab` section above
         -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
         bg_color = "#3b3052",
         fg_color = "#909090",
         italic = true,

         -- The same options that were listed under the `active_tab` section above
         -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
         bg_color = "#1e2326",
         fg_color = "#808080",

         -- The same options that were listed under the `active_tab` section above
         -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
         bg_color = "#222222",
         fg_color = "#909090",
         italic = true,

         -- The same options that were listed under the `active_tab` section above
         -- can also be used for `new_tab_hover`.
      },
   },
}

config.window_background_opacity = 0.95

config.window_padding = {
   left = 0,
   right = 0,
   top = 0,
   bottom = "0cell",
}

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
keybinding.apply_to_config(config)

return config
