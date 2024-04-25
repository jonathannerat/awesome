-- Suppress undefined globals
---@diagnostic disable-next-line: undefined-global
local client = client

local button = require "awful.button"
local layout = require "awful.layout"
local tag = require "awful.tag"
local taglist = require "awful.widget.taglist"
local beautiful = require "beautiful"
local gtable = require "gears.table"
local wibox = require "wibox"

local MouseButton = require("user.constants").MouseButton
local option = require "user.options"
local rounded_corners = require("user.utils.widget").rounded_corners

local MODKEY = option "modkey"
local tags = option "tags"

local taglist_buttons = gtable.join(
   button({ MODKEY }, MouseButton.LEFT, function(t)
      if client.focus then
         client.focus:move_to_tag(t)
      end
   end),
   button({ MODKEY }, MouseButton.RIGHT, function(t)
      if client.focus then
         client.focus:toggle_tag(t)
      end
   end),
   button({}, MouseButton.LEFT, function(t)
      t:view_only()
   end),
   button({}, MouseButton.RIGHT, tag.viewtoggle),
   button({}, MouseButton.SCROLL_UP, function(t)
      tag.viewnext(t.screen)
   end),
   button({}, MouseButton.SCROLL_DOWN, function(t)
      tag.viewprev(t.screen)
   end)
)

return function(s)
   if tags then
      tag(tags, s, layout.suit.tile)
   end

   return taglist {
      screen = s,
      filter = taglist.filter.noempty,
      buttons = taglist_buttons,
      widget_template = {
         widget = wibox.container.margin,
         left = 3,
         top = 3,
         bottom = 3,

         {
            widget = wibox.container.background,
            bg = beautiful.taglist_bg_occupied,
            shape = rounded_corners(3),
            shape_border_width = 1,
            shape_border_color = beautiful.border_normal,

            {
               widget = wibox.container.margin,
               left = 5,
               right = 5,
               top = 2,
               bottom = 2,

               {
                  id = "text_role",
                  widget = wibox.widget.textbox,
               },
            },
         },
      },
   }
end
-- vi: fdm=marker
