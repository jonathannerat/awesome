---@type Options
return {
   theme = "default",
   font = "monospace 10",

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
      useless_gap = 0,
   },

   tag_order = {
      "TERMINAL",
      "BROWSER",
      "MUSIC",
      "CHAT",
      "GAMES",
   },

   modkey = "Mod1",
}
