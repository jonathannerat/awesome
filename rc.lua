-- vi: fdm=marker
-- Suppress undefined global warnings
---@diagnostic disable-next-line: undefined-global
local awesome, root = awesome, root

pcall(require, "luarocks.loader")

local fs = require "gears.filesystem"
local spawn = require "awful.spawn"
local layout = require "awful.layout"
local rules = require "awful.rules"
local beautiful = require "beautiful"
local screens = require "awful.screen"

local utils = require "user.utils"
local getopt = utils.getopt
local notify_error = utils.notify_error

local theme_paths = {
   fs.get_configuration_dir() .. "/user/themes/%s.lua", -- single file theme
   fs.get_configuration_dir() .. "/user/themes/%s/theme.lua", -- folder theme
   fs.get_themes_dir() .. "%s/theme.lua", -- system theme
}

--- Initialize beautiful's theme
---@param theme_name string Name of the theme file inside `<config>/user/themes` folder
local function init_theme(theme_name) -- {{{
   local theme_path

   for _, p in ipairs(theme_paths) do
      theme_path = p:format(theme_name)
      if fs.file_readable(theme_path) then
         break
      end
      theme_path = nil
   end

   if theme_path then
      beautiful.init(theme_path)
   else
      notify_error("Error loading theme", "Couldn't find file for theme: " .. theme_name)
   end
end -- }}}

-- ***********
-- * STARTUP *
-- ***********

-- Ensures there's always a client focused
require "awful.autofocus"

-- Enables Usage of awesome-client
require "awful.remote"

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

init_theme(getopt "theme")

layout.layouts = {
   layout.suit.tile,
   layout.suit.fair,
   layout.suit.max,
}

screens.connect_for_each_screen(require "user.wibar")

-- Setup mappings
root.keys(require("user.mappings").global)

-- Rules to apply to new clients (through the "manage" signal).
rules.rules = require "user.rules"

require "user.signals"
