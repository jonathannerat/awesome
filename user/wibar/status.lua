local fixed = require "wibox.layout.fixed"
local separator = require "wibox.widget.separator"
local textclock = require "wibox.widget.textclock"

local openweathermap = require "user.widget.openweathermap"
local battery = require "user.widget.battery"

return { -- Status with separator
   layout = fixed.horizontal,
   spacing = 15,
   spacing_widget = separator,

   openweathermap { timeout = 10 * 60, initial_text = "󰥖  Loading…" },
   battery(),
   textclock " %b %d, %a",
   textclock(" %H:%M", 10),
}
