-- Suppress undefined global
local awesome = awesome
local root = root

-- Standard awesome library
local fs = require "gears.filesystem"
local spawn = require "awful.spawn"
local layout = require "awful.layout"
local screen = require "awful.screen"
local rules = require "awful.rules"

-- Notification library
local naughty = require "naughty"
-- Theme handling library
local beautiful = require "beautiful"

spawn "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"

spawn.with_shell [[
   if [ "$(xrdb -get awesome.started)" != "true" ]; then
      echo "awesome.started:true" | xrdb -merge;
      dex --environment Awesome --autostart;
   fi
]]

require "awful.autofocus"
require "awful.remote"

-- ## Error checking
-- ### Before startup
if awesome.startup_errors then
   naughty.notify {
      preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors,
   }
end

-- ### After startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function(err)
      -- Make sure we don't go into an endless error loop
      if in_error then
         return
      end
      in_error = true

      naughty.notify {
         preset = naughty.config.presets.critical,
         title = "Oops, an error happened!",
         text = tostring(err),
      }
      in_error = false
   end)
end

-- ## Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme = fs.get_configuration_dir() .. "/user/themes/default.lua"
beautiful.init(theme)

layout.layouts = {
   layout.suit.tile,
   layout.suit.tile.bottom,
   layout.suit.fair,
   layout.suit.max,
}

-- Create a wibox for each screen and add it
screen.connect_for_each_screen(require "user.wibar")

-- Set keys
root.keys(require("user.mappings").global)

-- ## Rules
-- Rules to apply to new clients (through the "manage" signal).
rules.rules = require "user.rules"

require "user.signals"
