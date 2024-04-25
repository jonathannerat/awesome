-- Suppress undefined globals
---@diagnostic disable-next-line: undefined-global
local client = client

local button = require "awful.button"
local tasklist = require "awful.widget.tasklist"
local wibox = require "wibox"

local tasklist_buttons = button({}, 1, function(c)
   if c == client.focus then
      c.minimized = true
   else
      c:emit_signal("request::activate", "tasklist", { raise = true })
   end
end)

return function(s)
   return {
      layout = wibox.layout.align.horizontal,

      tasklist {
         screen = s,
         filter = tasklist.filter.currenttags,
         buttons = tasklist_buttons,
         layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
         },
         widget_template = {
            layout = wibox.layout.align.vertical,

            {
               widget = wibox.container.margin,
               top = 3,
               {
                  wibox.widget.base.make_widget(),
                  forced_height = 2,
                  id = "background_role",
                  widget = wibox.container.background,
               },
            },
            {
               widget = wibox.container.margin,
               top = 2,
               bottom = 2,
               {
                  widget = wibox.container.place,
                  halign = "center",

                  {
                     id = "icon_role",
                     widget = wibox.widget.imagebox,
                  },
               },
            },
            nil,
         },
      },
      {
         widget = wibox.container.margin,
         left = 10,

         tasklist {
            screen = s,
            filter = tasklist.filter.focused,
            widget_template = {
               id = "text_role",
               widget = wibox.widget.textbox,
            },
         },
      },
      nil,
   }
end
