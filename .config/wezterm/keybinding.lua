local wezterm = require 'wezterm'
local act = wezterm.action

local keybinding = {}

local function private_helper()
   wezterm.log_error 'keybindign loaded!'
end

function keybinding.apply_to_config(config)
   private_helper()
   config.disable_default_key_bindings = true
   -- timeout_milliseconds defaults to 1000 (here 2000ms) and can be omitted
   -- This is main leader key
   config.leader = { key = 'g', mods = 'CTRL', timeout_milliseconds = 2000 }
   config.keys = {
      -- here we put keybinding. for example below, press ctrl+w will go to
      -- window mode in key tables, then in key tables we can press ctrl+w to
      -- go to resize_pane in the same key tables then we press h j k l to
      -- resize pane.
      {
         key = 'w',
         mods = 'ALT',
         action = act.ActivateKeyTable {
            name = 'window_mode',
            one_shot = false,
         },
      },

      -- Copy and Paste
      { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
      { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },

      -- resizing font
      { key = '-', mods = 'CTRL',       action = act.DecreaseFontSize },
      { key = '=', mods = 'CTRL',       action = act.IncreaseFontSize },
      { key = '0', mods = 'CTRL',       action = act.ResetFontSize },

      -- tab
      { key = 't', mods = 'CTRL',       action = act.SpawnTab 'CurrentPaneDomain' },
      { key = 'w', mods = 'CTRL',       action = act.CloseCurrentTab { confirm = true } },
      -- tab navigation
      { key = '1', mods = 'ALT',        action = act.ActivateTab(0) },
      { key = '2', mods = 'ALT',        action = act.ActivateTab(1) },
      { key = '3', mods = 'ALT',        action = act.ActivateTab(2) },
      { key = '4', mods = 'ALT',        action = act.ActivateTab(3) },
      { key = '5', mods = 'ALT',        action = act.ActivateTab(4) },
      { key = '6', mods = 'ALT',        action = act.ActivateTab(-4) },
      { key = '7', mods = 'ALT',        action = act.ActivateTab(-3) },
      { key = '8', mods = 'ALT',        action = act.ActivateTab(-2) },
      { key = '9', mods = 'ALT',        action = act.ActivateTab(-1) },

      { key = 'Tab', mods = 'CTRL',     action = act.ActivateTabRelative(1) },
      { key = 'h', mods = 'SHIFT|CTRL',  action = act.MoveTabRelative(-1) },
      { key = 'l', mods = 'SHIFT|CTRL',  action = act.MoveTabRelative(1) },

      -- search
      { key = 'f', mods = 'CTRL',       action = act.Search { CaseInSensitiveString = '' } },

      -- zooming pane
      { key = 'm', mods = 'ALT',        action = wezterm.action.TogglePaneZoomState },
      -- Some modes
      {
         key = 'v',
         mods = 'ALT',
         action = act.ActivateKeyTable {
            name = 'scroll_mode',
            one_shot = false,
         },
      },
      { key = 'c', mods = 'ALT',        action = act.ActivateCopyMode },
   }

   -- Show which key table is active in the status area
   wezterm.on('update-right-status', function(window)
      local name = window:active_key_table()
      if name then
         name = 'TABLE: ' .. name
      end
      window:set_right_status(name or '')
   end)

   config.key_tables = {
      -- Defines the keys that are active in our resize-pane mode.
      -- Since we're likely to want to make multiple adjustments,
      -- we made the activation one_shot=false. We therefore need
      -- to define a key assignment for getting out of this mode.
      -- 'resize_pane' here corresponds to the name="resize_pane" in
      -- the key assignments above.

      -- LEVEL 1
      window_mode = {
         {
            key = 'r',
            mods = 'ALT',
            action = act.ActivateKeyTable {
               name = 'resize_pane',
               one_shot = false,
            },
         },

         { key = 'l', action = act.ActivatePaneDirection 'Right' },
         { key = 'h', action = act.ActivatePaneDirection 'Left' },
         { key = 'k', action = act.ActivatePaneDirection 'Up' },
         { key = 'j', action = act.ActivatePaneDirection 'Down' },

         -- rotate pane
         { key = 'r', action = act.RotatePanes 'Clockwise' },
         { key = 'R', mods = 'SHIFT', action = act.RotatePanes 'CounterClockwise' },

         -- split window|window
         {
            key = 'v',
            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
         },
         -- split =
         {
            key = 's',
            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
         },
         -- close pane
         {
            key = 'c',
            action = wezterm.action.CloseCurrentPane { confirm = true },
         },
         -- escape from this mode
         { key = 'Escape', action = 'PopKeyTable' },
      },

      scroll_mode = {
         -- scrolling
         { key = 'k', action = act.ScrollByLine(-5) },
         { key = 'j', action = act.ScrollByLine(5) },
         { key = 'Escape', action = 'PopKeyTable' },
      },

      -- LEVEL 2
      resize_pane = {
         { key = 'h',      action = act.AdjustPaneSize { 'Left', 3 } },
         { key = 'l',      action = act.AdjustPaneSize { 'Right', 3 } },
         { key = 'k',      action = act.AdjustPaneSize { 'Up', 3 } },
         { key = 'j',      action = act.AdjustPaneSize { 'Down', 3 } },

         -- Cancel the mode by pressing escape
         { key = 'Escape', action = 'PopKeyTable' },
      },
   }
end

return keybinding
