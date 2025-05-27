local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local systray = wibox.widget.systray()

return {
   systray,

   top = dpi(4),
   bottom = dpi(4),
   widget = wibox.container.margin,
}
