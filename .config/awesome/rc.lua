pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox")

local beautiful = require("beautiful")

local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
-- local debian = require("debian.menu")
-- local has_fdo, freedesktop = pcall(require, "freedesktop")
local weatherApi = require("weatherApi")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")

local my_table = awful.util.table or gears.table

if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
                             -- Make sure we don't go into an endless error loop
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened!",
                                              text = tostring(err) })
                             in_error = false
   end)
end

-- Themes define colours, icons, font and wallpapers.
local theme_path = string.format("%s/.config/awesome/themes/default/theme.lua", os.getenv("HOME"))
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
local terminal     = "alacritty"
local editor       = os.getenv("EDITOR") or "nvim"
local editor_cmd   = terminal .. " -e " .. editor
local ctrlkey      = "Control"
local browser      = "microsoft-edge"
local file_manager = "thunar"
local editor       = "code"
local emacs        = "emacsclient -c -a 'emacs' "


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
local altkey = "Mod1"

awful.layout.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.max,
   awful.layout.suit.floating,
   awful.layout.suit.magnifier,
   -- awful.layout.suit.tile.left,
   -- awful.layout.suit.max.fullscreen,
   awful.layout.suit.tile.bottom,
   -- awful.layout.suit.tile.top,
   -- awful.layout.suit.fair,
   -- awful.layout.suit.fair.horizontal,
   -- awful.layout.suit.spiral,
   -- awful.layout.suit.spiral.dwindle,
   -- awful.layout.suit.corner.nw,
   -- awful.layout.suit.corner.ne,
   -- awful.layout.suit.corner.sw,
   -- awful.layout.suit.corner.se,
}

-- mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
   awful.button({ }, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
         if client.focus then
            client.focus:move_to_tag(t)
         end
   end),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
         if client.focus then
            client.focus:toggle_tag(t)
         end
   end),
   awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
   awful.button({ }, 1, function (c)
         if c == client.focus then
            c.minimized = true
         else
            c:emit_signal(
               "request::activate",
               "tasklist",
               {raise = true}
            )
         end
   end),
   awful.button({ }, 3, function()
         awful.menu.client_list({ theme = { width = 250 } })
   end),
   awful.button({ }, 4, function ()
         awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function ()
         awful.client.focus.byidx(-1)
end))

-- local function set_wallpaper(s)
--    -- Wallpaper
--    if beautiful.wallpaper then
--       local wallpaper = beautiful.wallpaper
--       -- If wallpaper is a function, call it with the screen
--       if type(wallpaper) == "function" then
--          wallpaper = wallpaper(s)
--       end
--       gears.wallpaper.maximized(wallpaper, s, true)
--    end
-- end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
      -- Wallpaper
      -- set_wallpaper(s)

      -- Each screen has its own tag table.
      awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}, s, awful.layout.layouts[1])

      -- Create a promptbox for each screen
      s.mypromptbox = awful.widget.prompt()
      -- Create an imagebox widget which will contain an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      s.mylayoutbox = awful.widget.layoutbox(s)
      s.mylayoutbox:buttons(gears.table.join(
                               awful.button({ }, 1, function () awful.layout.inc( 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(-1) end),
                               awful.button({ }, 4, function () awful.layout.inc( 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(-1) end)))
      -- Create a taglist widget
      s.mytaglist = awful.widget.taglist {
         screen  = s,
         filter  = awful.widget.taglist.filter.all,
         buttons = taglist_buttons
      }

      -- Create a tasklist widget
      s.mytasklist = awful.widget.tasklist {
         screen  = s,
         filter  = awful.widget.tasklist.filter.currenttags,
         buttons = tasklist_buttons
      }

      -- Create the wibox
      s.mywibox = awful.wibar({ position = "top", screen = s, height=20 })

      -- Add widgets to the wibox
      s.mywibox:setup {
         layout = wibox.layout.align.horizontal,
         { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
         },
         s.mytasklist, -- Middle widget
         { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            wibox.widget.systray(),
			weather_widget({
			   api_key              =weatherApi.key,
			   coordinates          = {7.7653, 113.1546},
               time_format_12h      = true,
			   -- units                = 'metric',
			   -- both_units_widget    = false,
			   font_name            = 'JetBrainsMono Nerd Font',
			   icons                = 'VitalyGorbachev',
			   icons_extension      = '.svg',
			   show_hourly_forecast = true,
			}),
            mytextclock,
            s.mylayoutbox,
         },
      }
end)

awful.util.taglist_buttons = my_table.join(
   awful.button({}, 1, function(t) t:view_only() end),
   awful.button({ modkey }, 1, function(t)
         if client.focus then
            client.focus:move_to_tag(t)
         end
   end),
   awful.button({}, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, function(t)
         if client.focus then
            client.focus:toggle_tag(t)
         end
   end),
   awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
   awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
   awful.button({}, 1, function(c)
         if c == client.focus then
            c.minimized = true
         else
            c:emit_signal("request::activate", "tasklist", { raise = true })
         end
   end),
   awful.button({}, 3, function()
         local instance = nil

         return function()
            if instance and instance.wibox.visible then
               instance:hide()
               instance = nil
            else
               instance = awful.menu.clients({ theme = { width = 250 } })
            end
         end
   end),
   awful.button({}, 4, function() awful.client.focus.byidx(1) end),
   awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

globalkeys = gears.table.join(
   -- APPS
   -- General keybindings
   awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
      { description = "Launch terminal", group = "Apps" }),
   awful.key({ modkey, }, "b", function() awful.spawn(browser) end,
      { description = "Launch browser", group = "Apps" }),
   awful.key({ modkey, }, "e", function() awful.spawn(file_manager) end,
      { description = "Launch file manager", group = "Apps" }),
   awful.key({ modkey, "Shift" }, "F5", awesome.restart,
      { description = "Reload awesome", group = "Awesome" }),
   awful.key({ modkey, }, "s", function() awful.spawn.with_shell("flameshot gui") end,
      { description = "Flameshot GUI Screenshot", group = "Apps" }),
   awful.key({ modkey, "Shift" }, "s", hotkeys_popup.show_help,
      { description = "Show help", group = "Awesome" }),
   awful.key({ modkey, "Shift" }, "b", function()
		 for s in screen do
			s.mywibox.visible = not s.mywibox.visible
			if s.mybottomwibox then
			   s.mybottomwibox.visible = not s.mybottomwibox.visible
			end
		 end
   end, { description = "Show/hide wibox (bar)", group = "awesome" }),

   -- {{{ DMENU
   awful.key({ modkey }, "d", function() awful.util.spawn("dm_run.py") end,
      { description = "Run launcher", group = "Dmenu" }),
   awful.key({ modkey, }, "x", function() awful.spawn.with_shell("dm-logout") end,
      { description = "Quit awesome", group = "Awesome" }),

   -- Dmscripts
   awful.key({ modkey }, "p",
      function()
         local grabber
         grabber = awful.keygrabber.run(
            function(_, key, event)
               if event == "release" then return end

			   if key == "b" then awful.spawn.with_shell("dm-setbg")
			   elseif key == "x" then awful.spawn.with_shell("dm-logout")
			   elseif key == "p" then awful.spawn.with_shell("gpick -s")
			   elseif key == "h" then awful.spawn.with_shell("dm-hub")
			   elseif key == "m" then awful.spawn.with_shell("dm-man")
			   elseif key == "o" then awful.spawn.with_shell("dm-note")
			   elseif key == "r" then awful.spawn.with_shell("dm-radio")
			   elseif key == "s" then awful.spawn.with_shell("dm-record")
			   elseif key == "c" then awful.spawn.with_shell("dm-confedit")
			   elseif key == "f" then awful.spawn.with_shell("dm-websearch")
			   elseif key == "w" then awful.spawn.with_shell("dm-weather")
			   elseif key == "n" then awful.spawn.with_shell("dm-wifi")
			   end
               awful.keygrabber.stop(grabber)
            end
         )
      end,
      { description = "followed by [b, x, p, h, m, o, r, s, c, w, f, n]", group = "Dmenu" }
   ),
   -- }}}

   -- {{{ SYSTEM SETTINGS AND CONTROLS
   awful.key({ modkey }, "i",
      function()
         local grabber
         grabber = awful.keygrabber.run(
            function(_, key, event)
               if event == "release" then return end

               if key == "n" then awful.spawn.with_shell("nm-connection-editor")
               elseif key == "a" then awful.spawn.with_shell("pavucontrol")
               end
               awful.keygrabber.stop(grabber)
            end
         )
      end,
      { description = "followed by [n]etwork, [a]udio, [b]ackground", group = "System Settings" }
   ),

   -- Brightness control
   awful.key({}, "XF86MonBrightnessUp", function() awful.spawn.with_shell("brightnesscontrol.sh i") end,
      { description = "Brightness +5%", group = "System Control" }),
   awful.key({}, "XF86MonBrightnessDown", function() awful.spawn.with_shell("brightnesscontrol.sh d") end,
      { description = "Brightness -5%", group = "System Control" }),

   -- Volume control
   awful.key({}, "XF86AudioRaiseVolume",
      function()
         awful.spawn.with_shell("volumecontrol.sh -o i")
         -- beautiful.volume.update()
      end,
      { description = "Volume +5%", group = "System Control" }
   ),
   awful.key({}, "XF86AudioLowerVolume",
      function()
         awful.spawn.with_shell("volumecontrol.sh -o d")
         -- beautiful.volume.update()
      end,
      { description = "Volume -5%", group = "System Control" }
   ),
   awful.key({}, "XF86AudioMute",
      function()
         awful.spawn.with_shell("volumecontrol.sh -o m")
         -- beautiful.volume.update()
      end,
      { description = "Mute/unmute", group = "System Control" }
   ),
   -- }}}

   -- {{{ CODE EDITOR
   awful.key({ modkey }, "c",
      function()
         local grabber
         grabber = awful.keygrabber.run(
            function(_, key, event)
               if event == "release" then return end

               if key == "c" then
                  awful.spawn.with_shell(editor)
               elseif key == "e" then
                  awful.spawn.with_shell(emacs)
               elseif key == "a" then
                  awful.spawn.with_shell(emacs ..
                                         "--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/\")'")
               elseif key == "b" then
                  awful.spawn.with_shell(emacs .. "--eval '(ibuffer)'")
               elseif key == "d" then
                  awful.spawn.with_shell(emacs .. "--eval '(dired nil)'")
               elseif key == "m" then
                  awful.spawn.with_shell("mousepad") -- if you have, probably
               end
               awful.keygrabber.stop(grabber)
            end
         )
      end,
      { description = "followed by VS[c]ode, [e]macs, [a, b, d], [m]ousepad", group = "Editor" }
   ),
   -- }}}

   -- {{{ WORKSPACE/TAG KEY
   -- Toggle view between 2 latest tag ALT+TAB
   awful.key({ altkey, }, "Tab", awful.tag.history.restore,
      { description = "go back", group = "Tag" }),
   -- Tag browsing with modkey (all Tag)
   awful.key({ modkey, }, "Left", awful.tag.viewprev,
      { description = "view previous all", group = "Tag" }),
   awful.key({ modkey, }, "Right", awful.tag.viewnext,
      { description = "view next all", group = "Tag" }),

   -- {{{ SCREEN
   awful.key({ modkey, ctrlkey }, ".", function() awful.screen.focus_relative(1) end,
      { description = "focus the next screen", group = "Screen" }),
   awful.key({ modkey, ctrlkey }, ",", function() awful.screen.focus_relative(-1) end,
      { description = "focus the previous screen", group = "Screen" }),
   -- }}}

   -- {{{ CLIENT
   -- Default client focus
   awful.key({ modkey, }, "j",
      function() awful.client.focus.byidx(1) end,
      { description = "Focus next by index", group = "Client" }),
   awful.key({ modkey, }, "k", function() awful.client.focus.byidx(-1) end,
      { description = "Focus previous by index", group = "Client" }),
   awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
      { description = "Swap with next client by index", group = "Client" }),
   awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
      { description = "Swap with previous client by index", group = "Client" }),
   awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
      { description = "Jump to urgent client", group = "Client" }),
   awful.key({ altkey, "Shift" }, "Tab",
      function()
         awful.client.focus.history.previous()
         if client.focus then client.focus:raise() end
      end,
      { description = "Go back", group = "Client" }
   ),

   awful.key({ modkey, ctrlkey }, "n",
      function()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      { description = "Restore minimized", group = "Client" }
   ),
   -- }}}

   -- {{{ LAYOUT
   -- Layout manipulation
   awful.key({ modkey }, "l", function() awful.tag.incmwfact(0.05) end,
      { description = "increase master width factor", group = "Layout" }),
   awful.key({ modkey }, "h", function() awful.tag.incmwfact(-0.05) end,
      { description = "decrease master width factor", group = "Layout" }),
   awful.key({ modkey, "Shift" }, "Up", function() awful.tag.incnmaster(1, nil, true) end,
      { description = "increase the number of master clients", group = "Layout" }),
   awful.key({ modkey, "Shift" }, "Down", function() awful.tag.incnmaster(-1, nil, true) end,
      { description = "decrease the number of master clients", group = "Layout" }),
   awful.key({ modkey, ctrlkey }, "h", function() awful.tag.incncol(1, nil, true) end,
      { description = "increase the number of columns", group = "Layout" }),
   awful.key({ modkey, ctrlkey }, "l", function() awful.tag.incncol(-1, nil, true) end,
      { description = "decrease the number of columns", group = "Layout" }),
   awful.key({ modkey, }, "Tab", function() awful.layout.inc(1) end,
      { description = "select next", group = "Layout" }),
   awful.key({ modkey, "Shift" }, "Tab", function() awful.layout.inc(-1) end,
      { description = "select previous", group = "Layout" }),

   -- Dropdown application
   awful.key({ modkey, }, "F12", function() awful.screen.focused().quake:toggle() end,
      { description = "dropdown application", group = "Super" }),

   -- }}}

   -- GLOBAL CLIPBOARD
   -- Copy primary to clipboard (terminals to gtk)
   awful.key({ modkey, "Shift" }, "c", function() awful.spawn.with_shell("xsel | xsel -i -b") end,
      { description = "copy terminal to gtk", group = "hotkeys" }),
   -- Copy clipboard to primary (gtk to terminals)
   awful.key({ modkey, "Shift" }, "v", function() awful.spawn.with_shell("xsel -b | xsel") end,
      { description = "copy gtk to terminal", group = "hotkeys" }),
   awful.key({ altkey, "Shift" }, "x",
      function()
         awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
         }
      end,
      { description = "lua execute prompt", group = "awesome" }
   )
)

clientkeys = gears.table.join(
   awful.key({ modkey }, "q", function(c) c:kill() end,
      { description = "close", group = "hotkeys" }),
   awful.key({ modkey, "Shift" }, "space", awful.client.floating.toggle,
      { description = "toggle floating", group = "Client" }),
   awful.key({ modkey, }, "BackSpace", function(c) c:swap(awful.client.getmaster()) end,
      { description = "move to master", group = "Client" }),
   awful.key({ modkey, "Shift" }, "t", function(c) c.ontop = not c.ontop end,
      { description = "toggle keep on top", group = "Client" }),
   awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
      { description = "move to screen", group = "Client" }),
   awful.key({ modkey, }, "n",
      function(c)
         -- The client currently has the input focus, so it cannot be
         -- minimized, since minimized clients can't have the focus.
         c.minimized = true
      end,
      { description = "minimize", group = "Client" }
   ),
   awful.key({ modkey, }, "f",
      function (c)
         c.fullscreen = not c.fullscreen
         c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}
   ),
   awful.key({ modkey, }, "m",
      function (c)
         c.maximized = not c.maximized
         c:raise()
      end ,
      {description = "(un)maximize", group = "client"}
   ),
   awful.key({ modkey, "Control" }, "m",
      function (c)
         c.maximized_vertical = not c.maximized_vertical
         c:raise()
      end ,
      {description = "(un)maximize vertically", group = "client"}
   ),
   awful.key({ modkey, "Shift" }, "m",
      function (c)
         c.maximized_horizontal = not c.maximized_horizontal
         c:raise()
      end ,
      {description = "(un)maximize horizontally", group = "client"}
   )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
   globalkeys = gears.table.join(
	  globalkeys,
	  -- View tag only.
	  awful.key({ modkey }, "#" .. i + 9,
		 function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
			   tag:view_only()
			end
		 end,
		 {description = "view tag #"..i, group = "tag"}
      ),
	  -- Toggle tag display.
	  awful.key({ modkey, "Control" }, "#" .. i + 9,
		 function ()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
			   awful.tag.viewtoggle(tag)
			end
		 end,
		 {description = "toggle tag #" .. i, group = "tag"}
      ),
	  -- Move client to tag.
	  awful.key({ modkey, "Shift" }, "#" .. i + 9,
		 function ()
			if client.focus then
			   local tag = client.focus.screen.tags[i]
			   if tag then
				  client.focus:move_to_tag(tag)
			   end
			end
		 end,
		 {description = "move focused client to tag #"..i, group = "tag"}
      ),
	  -- Toggle tag on focused client.
	  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
		 function ()
			if client.focus then
			   local tag = client.focus.screen.tags[i]
			   if tag then
				  client.focus:toggle_tag(tag)
			   end
			end
		 end,
		 {description = "toggle focused client on tag #" .. i, group = "tag"}
      )
   )
end

clientbuttons = gears.table.join(
   awful.button({ }, 1, function (c)
         c:emit_signal("request::activate", "mouse_click", {raise = true})
   end),
   awful.button({ modkey }, 1, function (c)
         c:emit_signal("request::activate", "mouse_click", {raise = true})
         if not c.floating then c.floating = true end
         awful.mouse.client.move(c)
   end),
   awful.button({ modkey }, 3, function (c)
         c:emit_signal("request::activate", "mouse_click", {raise = true})
         if not c.floating then c.floating = true end
         awful.mouse.client.resize(c)
   end)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   {
	  rule = { },
	  properties = {
		 border_width = beautiful.border_width,
		 border_color = beautiful.border_normal,
		 focus = awful.client.focus.filter,
		 raise = true,
		 keys = clientkeys,
		 buttons = clientbuttons,
		 screen = awful.screen.preferred,
		 placement = awful.placement.no_overlap+awful.placement.no_offscreen,
		 size_hints_honor = false,
	  },
   },

   -- Floating clients.
   {
	  rule_any = {
		 instance = {
			"DTA",  -- Firefox addon DownThemAll.
			"copyq",  -- Includes session name in class.
			"pinentry",
		 },
		 class = {
			"Arandr",
            "Yad",
			"Blueman-manager",
			"Gpick",
			"Kruler",
			"MessageWin",  -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Wpa_gui",
			"veromix",
			"xtightvncviewer"},

         -- Note that the name property shown in xprop might be set slightly after creation of the client
         -- and the name shown there might not match defined rules here.
         name = {
            "Event Tester",  -- xev.
         },
         role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "ConfigManager",  -- Thunderbird's about:config.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
         }
      },
      properties = { floating = true }
   },
   -- Add titlebars to normal clients and dialogs
   {
      rule_any = {type = { "normal", "dialog" }},
      properties = { titlebars_enabled = false }
   },
   {
      rule = { class = "Vlc" },
      properties = { maximized = true }
   },
   {
      rule = { class = "Microsoft-edge" },
      properties = { screen = 1, tag = "2" }
   },
}

-- Signal function to execute when a new client appears.
client.connect_signal(
   "manage",
   function (c)
	  -- Set the windows at the slave,
	  -- i.e. put it at the end of others instead of setting it master.
	  -- if not awesome.startup then awful.client.setslave(c) end
	  if awesome.startup
		 and not c.size_hints.user_position
		 and not c.size_hints.program_position then
		 -- Prevent clients from being unreachable after screen count changes.
		 awful.placement.no_offscreen(c)
	  end
   end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
   "request::titlebars",
   function(c)
	  -- buttons for the titlebar
	  local buttons = gears.table.join(
		 awful.button({ }, 1, function()
			   c:emit_signal("request::activate", "titlebar", {raise = true})
			   awful.mouse.client.move(c)
		 end),
		 awful.button({ }, 3, function()
			   c:emit_signal("request::activate", "titlebar", {raise = true})
               awful.mouse.client.resize(c)
         end)
      )

      awful.titlebar(c) : setup {
         { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
         },
         { -- Middle
            { -- Title
               align  = "center",
               widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
         },
         { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
         },
         layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                         c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- No border for maximized clients
function border_adjust(c)
   if c.maximized then -- no borders if only 1 client visible
	  c.border_width = 0
   elseif #awful.screen.focused().clients > 1 then
	  c.border_width = beautiful.border_width
	  c.border_color = beautiful.border_focus
   end
end
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.with_shell("nm-applet &")
awful.spawn.with_shell("pasystray &")
awful.spawn.with_shell("/usr/bin/emacs --daemon &")
