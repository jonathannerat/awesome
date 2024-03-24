local beautiful = require "beautiful"
local dpi = require("beautiful.xresources").apply_dpi
local layouts = require("awful.layout").layouts
local rounded_rect = require("gears.shape").rounded_rect
local tags = require "awful.tag"
local tmap = require("gears.table").map
local wibar = require "awful.wibar"
local wibox = require "wibox"
local widget = require "awful.widget"

local TagIcons = require("user.enums").TagIcons
local getopt = require("user.utils").getopt
local taglist = require "user.wibar.taglist"
local tasklist = require "user.wibar.tasklist"
local status = require "user.wibar.status"

local layout = wibox.layout
local systray = wibox.widget.systray()
local ordered_tags = tmap(function(k)
   return TagIcons[k]
end, getopt "tag_order")

local function get_widgets_for(screen)
   return {
      taglist = taglist(screen),
      tasklist = tasklist(screen),
      status = status,
      systray = systray,
      layoutbox = widget.layoutbox(screen),
   }
end

--- Place widgets[i+1] inside widgets[i] as a child
---@param widgets table[]
local function compose(widgets)
   local top

   for _, w in ipairs(widgets) do
      if top then
         top[1] = w
      end

      top = w
   end

   return widgets[1]
end

local function hfixed(spacing, ...)
   return {
      spacing = spacing,
      layout = layout.fixed.horizontal,
      ...,
   }
end

local function background(bg, shape, opts)
   opts = opts or {}
   opts.bg = bg or "#000000"
   opts.shape = shape
   opts.widget = wibox.container.background

   return opts
end

--- Create margin container
---@param a number all margins or top margin if b is nil
---@param b number? right margin or left/right if d is nil
---@param c number? bottom margin
---@param d number? right margin
---@return table
local function margin(a, b, c, d)
   local opts

   if not (b or c or d) then
      opts = {
         margins = a,
      }
   else
      if not (c or d) then
         c = a
         d = b
      elseif not d then
         d = b
      end
      opts = {
         top = a,
         right = b,
         bottom = c,
         left = d,
      }
   end

   opts.widget = wibox.container.margin

   return opts
end

local transparent_bg = "#00000000"
local wibar_gap = dpi(4)

return function(screen)
   tags(ordered_tags, screen, layouts[1])

   local screen_wibar = wibar.new {
      screen = screen,
      widget = wibox.container.background,
      bg = transparent_bg,
   }

   local widgets = get_widgets_for(screen)

   screen_wibar:setup {
      layout = layout.align.horizontal,

      compose { -- Left widgets
         margin(wibar_gap, wibar_gap, 0),
         background(beautiful.bg_solid, rounded_rect),
         widgets.taglist,
      },

      compose { -- Middle widgets
         margin(wibar_gap, wibar_gap, 0),
         background(beautiful.bg_solid, rounded_rect),
         compose {
            margin(0, 0, 0, dpi(5)),
            widgets.tasklist,
         }
      },

      compose { -- Right widgets
         margin(wibar_gap, wibar_gap, 0),
         background(beautiful.bg_solid, rounded_rect),
         hfixed(
            10,
            widgets.status,
            widgets.systray,
            compose {
               margin(0, dpi(5), 0, 0),
               widgets.layoutbox,
            }
         ),
      },
   }

   widgets.wibar = screen_wibar
   screen.my_widgets = widgets
end
