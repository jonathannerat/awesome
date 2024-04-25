local timer = require "gears.timer"
local textbox = require "wibox.widget.textbox"

local CHARGING_ICONS = {
   [0] = "󰢟 ",
   [10] = "󰢜 ",
   [20] = "󰂆 ",
   [30] = "󰂇 ",
   [40] = "󰂈 ",
   [50] = "󰢝 ",
   [60] = "󰂉 ",
   [70] = "󰢞 ",
   [80] = "󰂊 ",
   [90] = "󰂋 ",
   [100] = "󰂅 ",
}

local DISCHARGING_ICONS = {
   [0] = "󰂎 ",
   [10] = "󰁺 ",
   [20] = "󰁻 ",
   [30] = "󰁼 ",
   [40] = "󰁽 ",
   [50] = "󰁾 ",
   [60] = "󰁿 ",
   [70] = "󰂀 ",
   [80] = "󰂁 ",
   [90] = "󰂂 ",
   [100] = "󰁹 ",
}

return function(args)
   args = args or {}
   local timeout = args.timeout or 60
   local batname = args.battery or "BAT0"

   local widget = textbox()
   local t = timer { timeout = timeout }

   local batfolder = "/sys/class/power_supply/" .. batname .. "/"

   t:connect_signal("timeout", function()
      t:stop()
      local capacity = math.min(io.open(batfolder .. "capacity"):read "n", 100)
      local status = io.open(batfolder .. "status"):read "l"

      local icons = (status == "Charging" and CHARGING_ICONS or DISCHARGING_ICONS)
      local text = icons[math.floor(capacity / 10) * 10]
      text = text .. tostring(capacity) .. "%"

      widget:set_text(text)
      t:again()
   end)

   t:start()
   t:emit_signal "timeout"

   return widget
end
