-- vi: fdm=marker
local option = require "user.options"
local gt = require "gears.table"
local fs = require "gears.filesystem"
local naughty = require "naughty"

local theme = {}

local palette = require "user.palette.kanagawa"

theme.font = option "ui.font"

theme.bg_normal = palette.sumiInk0
theme.fg_normal = palette.fujiWhite

theme.useless_gap = option "ui.useless_gap"
theme.border_width = 2
theme.border_normal = palette.sumiInk6
theme.border_focus = palette.crystalBlue
theme.border_marked = palette.carpYellow

theme.taglist_bg_focus = palette.sumiInk3
theme.taglist_fg_focus = palette.crystalBlue
theme.taglist_bg_urgent = palette.sumiInk3
theme.taglist_fg_urgent = palette.peachRed
theme.taglist_bg_occupied = palette.sumiInk3
theme.taglist_fg_occupied = palette.oldWhite

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_bg_focus = theme.border_focus
theme.tasklist_fg_focus = theme.fg_normal
theme.tasklist_bg_minimize = theme.border_normal
theme.tasklist_fg_minimize = theme.border_focus

theme.layoutlist_bg_normal = theme.bg_normal
theme.layoutlist_bg_selected = theme.border_focus

theme.notification_icon_size = option "notification.icon_size"
theme.notification_width = option "notification.width"
theme.notification_max_width = option "notification.max_width"
theme.notification_font = option "notification.font"

theme.wallpaper = option "wallpaper"

theme.icon_theme = option "icon.theme"

theme.separator_thickness = 0.5

-- You can use your own layout icons like this:
local themes_path = fs.get_themes_dir()
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

gt.crush(naughty.config, {
   icon_dirs = option "icon.path",
   icon_formats = { "png", "svg" },
   presets = {
      low = {
         bg = theme.bg_normal,
         fg = theme.fg_normal,
         border_color = theme.fg_normal,
         timeout = 10,
      },
      normal = {
         fg = palette.dragonWhite,
         bg = palette.sumiInk0,
         border_color = palette.crystalBlue,
         timeout = 20,
      },
      critical = {
         fg = palette.dragonBlack0,
         bg = palette.peachRed,
         border_color = palette.sumiInk3,
         timeout = 30,
      },
   },
})

return theme
