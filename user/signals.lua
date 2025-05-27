-- Suppress undefined global
---@diagnostic disable-next-line: undefined-global
local awesome, client, screen = awesome, client, screen

local placement = require "awful.placement"
local beautiful = require "beautiful"
local surface = require "gears.surface"
local cairo = require("lgi").cairo
local geticonpath = require("awful.util").geticonpath
local wibox = require "wibox"
local option = require("user.options")

local DEFAULT_ICON = "/usr/share/icons/Papirus/64x64/apps/xfce-unknown.svg"

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
   -- Set the windows at the slave,
   -- i.e. put it at the end of others instead of setting it master.
   -- if not awesome.startup then awful.client.setslave(c) end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      placement.no_offscreen(c)
   end

   if c and c.valid and not c.icon then
      local fallback_icon = geticonpath(c.class or c.instance or "", { "svg", "png" }, option "icon.path") or DEFAULT_ICON
      local s = surface(fallback_icon)
      local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
      local cr = cairo.Context(img)

      cr:set_source_surface(s, 0, 0)
      cr:paint()
      c.icon = img._native
   end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local last_systray_screen = nil
local global_systray = wibox.widget.systray()
client.connect_signal("focus", function(c)
   c.border_color = beautiful.border_focus

   -- move systray to focused client's screen (if it hasn't changed)
   if last_systray_screen ~= c.screen then
      global_systray:set_screen(c.screen)
      global_systray:emit_signal "widget::redraw_needed"
      last_systray_screen = c.screen
   end
end)

client.connect_signal("unfocus", function(c)
   c.border_color = beautiful.border_normal
end)
