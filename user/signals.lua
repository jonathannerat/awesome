-- Suppress undefined global
local awesome = awesome
local client = client

local placement = require "awful.placement"
local beautiful = require "beautiful"

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
   -- Set the windows at the slave,
   -- i.e. put it at the end of others instead of setting it master.
   -- if not awesome.startup then awful.client.setslave(c) end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      placement.no_offscreen(c)
   end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
   c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local last_systray_screen = nil
client.connect_signal("focus", function(c)
   c.border_color = beautiful.border_focus

   -- move systray to focused client's screen (if it hasn't changed)
   if last_systray_screen ~= c.screen then
      local systray = c.screen.my_widgets.systray
      systray:set_screen(c.screen)
      systray:emit_signal "widget::redraw_needed"
      last_systray_screen = c.screen
   end
end)

client.connect_signal("unfocus", function(c)
   c.border_color = beautiful.border_normal
end)
