local TRANSPARENT = "#00000000"
local beautiful = require "beautiful"
local wibar = require "awful.wibar"
local wibox = require "wibox"

local mytaglist = require "user.wibar.taglist"
local mytasklist = require "user.wibar.tasklist"
local mystatus = require "user.wibar.status"
local option = require "user.options"
local rounded_corners = require("user.utils.widget").rounded_corners

local Wibar = {
   padding = 0,
}
local mt = { __index = Wibar }

function Wibar.new(o)
   o = o or {}
   setmetatable(o, mt)
   return o
end

function Wibar:setup(s)
   self.wibar = wibar {
      screen = s,
      widget = wibox.container.background,
      bg = TRANSPARENT,
      position = option "wibar.position",
      height = option "wibar.height",
   }

   local bar = {
      layout = wibox.layout.align.horizontal,

      mytaglist(s),
      {
         widget = wibox.container.margin,
         left = 10,
         right = 10,

         mytasklist(s),
      },
      {
         widget = wibox.container.margin,
         right = 10,

         mystatus,
      },
   }

   local bg = {
      widget = wibox.container.background,
      bg = beautiful.bg_normal,
      shape = rounded_corners(5),
      shape_border_width = 1,
      shape_border_color = beautiful.border_normal,

      bar,
   }

   local gaps = { widget = wibox.container.margin, bg }

   if type(self.padding) == "table" then
      for k, v in pairs(self.padding) do
         gaps[k] = v
      end
   else
      gaps.margins = self.padding
   end

   self.wibar:setup(gaps)

   s.wibar = self.wibar
end

return Wibar
