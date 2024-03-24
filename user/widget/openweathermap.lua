local geoclue = require "user.utils.geoclue"
local lain_widget = require "lain.widget"

local api_key = require("user.utils").getopt "OPENWEATHERMAP_API"
local location = geoclue.where_am_i()

return lain_widget.weather {
   APPID = api_key,
   lat = location.lat,
   lon = location.lon,
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

      if math.abs(temp - feels_like) < 1 then
         widget:set_text(("%s %.1f°C"):format(description, temp))
      else
         widget:set_text(("%s %.1f°C (%.1f°C)"):format(description, temp, feels_like))
      end
   end,
}
