local dpi = require("beautiful.xresources").apply_dpi
local textclock = require("wibox.widget.textclock")

---@type Options
return {
   ui = {
      theme = "default",
      font = "monospace 10",
      useless_gap = dpi(2),
      status = {
         textclock("  %Y-%m-%d"),
         textclock("  %H:%M:%S", 1),
      },
   },

   notification = {
      icon_size = 48,
      width = 300,
      max_width = 400,
      font = "Roboto, Regular 10",
   },

   icon = {
      theme = "default",
      path = {
         "/usr/share/pixmaps/",
         "/usr/share/hicolor/",
      },
   },

   wibar = {
      height = 24,
      position = "top",
   },

   env = {
      OPENWEATHERMAP_API_KEY = "",
   },

   tags = {"1", "2", "3", "4", "5", "6", "7", "8", "9"},

   rules = {},

   modkey = "Mod1",

   battery = "BAT0",
}
