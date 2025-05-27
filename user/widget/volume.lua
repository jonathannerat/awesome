local timer = require "gears.timer"
local textbox = require "wibox.widget.textbox"
local spawn = require "awful.spawn"

return function(args)
   args = args or {}
   local timeout = args.timeout or 60

   local widget = textbox()
   local t = timer { timeout = timeout }

   t:connect_signal("timeout", function()
      t:stop()
      spawn.easy_async_with_shell("echo \"$(pamixer --get-volume) $(pamixer --get-mute)\"", function (output)
         local icon = "󰕿 "
         local volume, is_mute = output:match("(%S+) (%S+)")

         volume = tonumber(volume)
         is_mute = is_mute == "true"

         if 33 < volume and volume <= 66 then
            icon = "󰖀 "
         elseif 66 < volume then
            icon = "󰕾 "
         end

         if is_mute then
            icon = "󰝟 "
         end

         local text = icon .. tostring(volume) .. "%"

         widget:set_text(text)
      end)
      t:again()
   end)

   t:start()
   t:emit_signal "timeout"

   return widget
end
