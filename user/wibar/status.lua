local wibox = require "wibox"
local lain_widget = require "lain.widget"

local cycleclock = require "user.widget.cycleclock"

return { -- Status with separator
   widget = wibox.container.margin,
   left = 10,

   {
      layout = wibox.layout.fixed.horizontal,
      spacing = 15,
      spacing_widget = wibox.widget.separator,

      lain_widget.fs {
         settings = function()
            widget:set_text(
               (" /: %d%%   /home: %d%%"):format(fs_now["/"].percentage, fs_now["/home"].percentage)
            )
         end,
      },
      lain_widget.weather {
         APPID = "05ce015e771c1ff5fd1dead73bc780c0",
         lat = -34.6526296,
         lon = -58.4147098,
         notification_text_fun = function(wn)
            local day = os.date("%a %d (%I%p)", wn["dt"])
            local temp = math.floor(wn["main"]["temp"])
            local desc = wn["weather"][1]["description"]
            return string.format("<b>%s</b>: %s, %d ", day, desc, temp)
         end,
         settings = function()
            local description = weather_now["weather"][1]["description"]:lower()
            local temp = weather_now["main"]["temp"]
            local feels_like = weather_now["main"]["feels_like"]
            widget:set_text(("%s %.1f°C (%.1f°C)"):format(description, temp, feels_like))
         end,
      },
      cycleclock { " %a %d   %H:%M", " %B %d, %A   %H:%M" },
   },
}
