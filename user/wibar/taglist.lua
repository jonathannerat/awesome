-- Suppress undefined globals
---@diagnostic disable-next-line: undefined-global
local client = client

local button = require "awful.button"
local tags = require "awful.tag"
local widget = require "awful.widget"
local table_utils = require "gears.table"

local getopt = require("user.utils").getopt
local MouseButton = require("user.enums").MouseButton

local MODKEY = getopt "modkey"

return function(s)
   return widget.taglist {
      screen = s,
      filter = widget.taglist.filter.noempty,
      buttons = table_utils.join(
         button({MODKEY}, MouseButton.LEFT, function(t)
            if client.focus then
               client.focus:move_to_tag(t)
            end
         end),
         button({MODKEY}, MouseButton.RIGHT, function(t)
            if client.focus then
               client.focus:toggle_tag(t)
            end
         end),
         button({}, MouseButton.LEFT, function(t)
            t:view_only()
         end),
         button({}, MouseButton.RIGHT, tags.viewtoggle),
         button({}, MouseButton.SCROLL_UP, function(t)
            tags.viewnext(t.screen)
         end),
         button({}, MouseButton.SCROLL_DOWN, function(t)
            tags.viewprev(t.screen)
         end)
      ),
   }
end
