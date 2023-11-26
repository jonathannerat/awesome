local layout = require "awful.layout"
local table_utils = require "gears.table"
local tags = require "awful.tag"
local awful_wibar = require "awful.wibar"
local wibox = require "wibox"
local widget = require "awful.widget"

local buttons = require "user.wibar.buttons"
local TagIcons = require("user.enums").TagIcons
local custom = require("user.utils").custom

local wibox_layout = wibox.layout
local global_systray = wibox.widget.systray()

local ordered_tags = table_utils.map(function(k)
   return TagIcons[k]
end, custom "tags")

local function taglist_widget(s)
   return widget.taglist {
      screen = s,
      filter = widget.taglist.filter.noempty,
      buttons = buttons.taglist,
   }
end

local function tasklist_widget(s)
   return widget.tasklist {
      screen = s,
      filter = widget.tasklist.filter.currenttags,
      buttons = buttons.tasklist,
      layout = {
         layout = wibox_layout.fixed.horizontal,
      },
      widget_template = {
         {
            wibox.widget.base.make_widget(),

            forced_height = 2,
            id = "background_role",
            widget = wibox.container.background,
         },
         {
            {
               id = "clienticon",
               widget = widget.clienticon,
            },

            top = 2,
            left = 2,
            widget = wibox.container.margin,
         },
         nil,

         create_callback = function(self, c)
            self:get_children_by_id("clienticon")[1].client = c
         end,
         layout = wibox_layout.align.vertical,
      },
   }
end

local function wibar_widgets(screen)
   return {
      taglist = taglist_widget(screen),
      prompt = widget.prompt(),
      tasklist = tasklist_widget(screen),
      status = require "user.wibar.status",
      systray = global_systray,
      layoutbox = widget.layoutbox(screen),
   }
end

return {
   setup = function(screen)
      tags(ordered_tags, screen, layout.layouts[1])

      local wibar = awful_wibar.new {
         screen = screen,
         position = custom "wibar_position",
         height = custom "wibar_height",
      }

      local widgets = wibar_widgets(screen)

      wibar:setup {
         layout = wibox_layout.align.horizontal,

         { -- Left widgets
            widgets.taglist,
            widgets.prompt,

            layout = wibox_layout.fixed.horizontal,
         },

         -- Middle
         {
            widgets.tasklist,

            left = 5,
            widget = wibox.container.margin,
         },

         { -- Right widgets
            widgets.status,
            widgets.systray,
            widgets.layoutbox,

            layout = wibox_layout.fixed.horizontal,
            spacing = 10,
         },
      }

      widgets.wibar = wibar
      screen.my_widgets = widgets
   end,
}
