local wibox = require "wibox"
local lain_widget = require "lain.widget"
local cycleclock = require "user.widget.cycleclock"
local custom = require("user.utils").custom

return { -- Status with separator
   widget = wibox.container.margin,
   left = 10,

   {
      layout = wibox.layout.fixed.horizontal,
      spacing = 15,
      spacing_widget = wibox.widget.separator,

      lain_widget.fs {
         settings = function()
            widget:set_text((" %d%%"):format(fs_now["/"].percentage))
         end,
      },
      require "user.widget.openweathermap",
      cycleclock { "%a %H:%M", " %B %d, %A  %H:%M" },
   },
}
