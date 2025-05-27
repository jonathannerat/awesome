-- vi: fdm=marker
-- Suppress undefined global warnings
---@diagnostic disable-next-line: undefined-global
local awesome, root, screen = awesome, root, screen

local luarocks_dir = os.getenv "XDG_DATA_HOME" .. "/luarocks/share/lua/" .. _VERSION:sub(-3)
package.path = package.path .. ";" .. luarocks_dir .. "/?.lua"
package.path = package.path .. ";" .. luarocks_dir .. "/?/init.lua"
pcall(require, "luarocks.loader")

local layout = require "awful.layout"
local rules = require "awful.rules"
local ascreen = require "awful.screen"
local spawn = require "awful.spawn"
local beautiful = require "beautiful"
local fs = require "gears.filesystem"
local wall = require "gears.wallpaper"
local option = require "user.options"

-- Functions {{{
--- Show critical notification
---@param title string
---@param text string
local function notify_error(title, text)
   local naughty = require "naughty"

   naughty.notify {
      preset = naughty.config.presets.critical,
      title = title,
      text = text,
   }
end

local function set_wallpaper(s)
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
         wallpaper = wallpaper(s)
      end
      wall.maximized(wallpaper, s, true)
   end
end
-- }}}

-- Error handling {{{
-- Before startup
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
-- }}}

-- Ensures there's always a client focused
require "awful.autofocus"

-- Enables Usage of awesome-client
require "awful.remote"

-- Autostart {{{
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
-- }}}

--- Initialize beautiful's theme -- {{{
local theme_found = false
local theme_name = option "ui.theme"
local THEME_PATH = {
   fs.get_configuration_dir() .. "/user/themes/%s.lua", -- single file theme
   fs.get_configuration_dir() .. "/user/themes/%s/theme.lua", -- folder theme
   fs.get_themes_dir() .. "%s/theme.lua", -- system theme
}

for _, p in ipairs(THEME_PATH) do
   local theme = p:format(theme_name)
   if beautiful.init(theme) then
      theme_found = true
      break
   end
end

if not theme_found then
   notify_error("Error loading theme", "Couldn't find file for theme: " .. theme_name)
end
-- }}}

layout.layouts = {
   layout.suit.tile,
   layout.suit.fair,
   layout.suit.max,
}

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local Wibar = require "user.wibar"
local padding = (beautiful.useless_gap or 0) * 2
ascreen.connect_for_each_screen(function(s)
   set_wallpaper(s)

   local w = Wibar.new {
      padding = {
         left = padding,
         top = padding,
         right = padding,
      },
   }

   w:setup(s)
end)

-- Setup mappings
root.keys(require("user.mappings").global)

-- Rules to apply to new clients (through the "manage" signal).
rules.rules = require "user.rules"

require "user.signals"
