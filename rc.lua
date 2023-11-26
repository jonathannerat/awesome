-- Suppress undefined global warnings
local awesome = awesome
local root = root

local fs = require "gears.filesystem"
local spawn = require "awful.spawn"
local layout = require "awful.layout"
local rules = require "awful.rules"
local naughty = require "naughty"
local beautiful = require "beautiful"
local awful_screen = require "awful.screen"
local awful_wibar = require "awful.wibar"

local custom = require("user.utils").custom

--- Show critical notification
---@param title string
---@param text string
local function notify_error(title, text)
   naughty.notify {
      preset = naughty.config.presets.critical,
      title = title,
      text = text,
   }
end

--- Initialize beautiful's theme
---@param theme_name string Name of the theme file inside `<config>/user/themes` folder
local function init_theme(theme_name)
   local theme_path = ("%s/user/themes/%s.lua"):format(fs.get_configuration_dir(), theme_name)

   if not fs.file_readable(theme_path) then
      theme_path = ("%s%s/theme.lua"):format(fs.get_themes_dir(), theme_name)
   end

   if fs.file_readable(theme_path) then
      beautiful.init(theme_path)
   else
      notify_error("Error loading theme", ("File '%s' is not readable"):format(theme_path))
   end
end

local function handle_errors()
   -- Errors before startup
   if awesome.startup_errors then
      notify_error("Oops, there were errors during startup!", awesome.startup_errors)
   end

   -- Errors after startup
   local in_error = false
   awesome.connect_signal("debug::error", function(err)
      -- Make sure we don't go into an endless error loop
      if in_error then
         return
      end
      in_error = true
      notify_error("Opps, an error happened", tostring(err))
      in_error = false
   end)
end

-- ***********
-- * STARTUP *
-- ***********

handle_errors()

-- Autostart apps on login
spawn "dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY"
spawn.with_shell [[
   if ! command -v xrdb >/dev/null; then
      >&2 echo "awesome error: missing xrdb"
      exit 1
   fi

   if ! command -v dex >/dev/null; then
      >&2 echo "awesome error: missing dex"
      exit 1
   fi

   if [ "$(xrdb -get awesome.started)" != "true" ]; then
      echo "awesome.started:true" | xrdb -merge
      dex --environment Awesome --autostart
   fi
]]

-- Ensures there's always a client focused
require "awful.autofocus"

-- Enables usage of awesome-client
require "awful.remote"

init_theme(custom "theme")

layout.layouts = {
   layout.suit.tile,
   layout.suit.tile.bottom,
   layout.suit.fair,
   layout.suit.max,
}

local wibar_config = require "user.wibar"

-- Create a wibar for each screen and add it
awful_screen.connect_for_each_screen(function(screen)
   wibar_config.setup(screen)
end)

-- Setup mappings
root.keys(require("user.mappings").global)

-- Rules to apply to new clients (through the "manage" signal).
rules.rules = require "user.rules"

require "user.signals"
