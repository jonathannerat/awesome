-- Suppress undefined globals
---@diagnostic disable-next-line: undefined-global
local client = client

local button = require "awful.button"
local tasklist = require "awful.widget.tasklist"
local clienticon = require "awful.widget.clienticon"
local table_utils = require "gears.table"
local layout = require "wibox.layout"
local widget = require "wibox.widget"
local container = require "wibox.container"

local MouseButton = require("user.enums").MouseButton

return function(s)
   return tasklist {
      screen = s,
      filter = tasklist.filter.currenttags,
      buttons = table_utils.join(
         button({}, MouseButton.LEFT, function(c)
            if c == client.focus then
               c.minimized = true
            else
               c:emit_signal("request::activate", "tasklist", { raise = true })
            end
         end),
         button({}, MouseButton.RIGHT, function()
            require("awful.menu").client_list { theme = { width = 250 } }
         end)
      ),
      layout = {
         layout = layout.fixed.horizontal,
      },
      widget_template = {
         layout = layout.fixed.vertical,
         spacing = 3,
         create_callback = function(self, c)
            self:get_children_by_id("clienticon")[1].client = c
         end,

         {
            widget = container.margin,
            left = 5,
            right = 5,


            {
               widget = container.background,
               id = "background_role",
               forced_height = 3,

               widget.base.make_widget(),
            },
         },
         {
            widget = container.margin,
            left = 2,
            {
               id = "clienticon",
               widget = clienticon,
            },
         }
      },
   }
end
