local layout = require "awful.layout"
local table_utils = require "gears.table"
local tags = require "awful.tag"
local wibar = require "awful.wibar"
local wibox = require "wibox"
local widget = require "awful.widget"

local buttons = require "user.wibar.buttons"
local Tag = require("user.enums").Tag
local constants = require "user.constants"

local wibox_layout = wibox.layout
local systray = wibox.widget.systray()

local ordered_tags = table_utils.map(function(k)
   return Tag[k]
end, constants.TAGS)

return function(screen)
   tags(ordered_tags, screen, layout.layouts[1])

   local taglist = widget.taglist {
      screen = screen,
      filter = widget.taglist.filter.noempty,
      buttons = buttons.taglist,
   }

   local tasklist = widget.tasklist {
      screen = screen,
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
         layout = wibox_layout.align.vertical
      },
   }

   local topbar = wibar.new {
      screen = screen,
      position = "top",
      height = 24,
   }

   local my_widgets = {
      prompt = widget.prompt(),
      systray = systray,
      taglist = taglist,
      tasklist = tasklist,
      wibar = topbar,
   }

   screen.my_widgets = my_widgets

   topbar:setup {
      layout = wibox_layout.align.horizontal,

      { -- Left widgets
         layout = wibox_layout.fixed.horizontal,

         taglist,
         my_widgets.prompt,
      },

      -- Middle
      {
         tasklist,

         left = 5,
         widget = wibox.container.margin,
      },

      { -- Right widgets
         require "user.wibar.status",
         systray,
         widget.layoutbox(screen),

         layout = wibox_layout.fixed.horizontal,
         spacing = 10,
      },
   }
end
