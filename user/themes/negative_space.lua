-- vi: fdm=marker
local dpi = require("beautiful.xresources").apply_dpi
local getopt = require("user.utils").getopt
local gtcrush = require("gears.table").crush
local naughty = require "naughty"
local theme_assets = require "beautiful.theme_assets"
local themes_path = require("gears.filesystem").get_themes_dir()

local theme = {}

theme.font = getopt "font"

-- Color Pallete {{{
theme.color_red = "#FF5D62"
theme.color_orange = "#FFA066"
theme.color_yellow = "#E6C384"
theme.color_green = "#98BB6C"
theme.color_torquise = "#A3D4D5"
theme.color_torquise_light = "#A3D4D5"
theme.color_torquise_dark = "#7FB4CA"
theme.color_blue_light = "#7FB4CA"
theme.color_blue = "#7E9CD8"
theme.color_purple = "#957FB8"
theme.color_fg = "#DCD7BA"
theme.color_fg_dark = "#C8C093"
theme.color_fg_darker = "#C8C093"
theme.color_dark1 = "#363646"
theme.color_dark2 = "#2A2A37"
theme.color_dark3 = "#1F1F28"
theme.color_dark4 = "#16161D"
-- }}}

-- Notifications {{{
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
-- }}}

theme.bg_solid = theme.color_dark4
theme.bg_normal = theme.color_dark4
theme.bg_focus = theme.color_blue_light
theme.bg_urgent = theme.color_dark4
theme.fg_normal = theme.color_fg
theme.fg_focus = theme.color_dark3
theme.fg_urgent = theme.color_yellow
theme.fg_minimize = theme.color_fg
theme.border_width = dpi(2)
theme.border_normal = theme.color_dark2 .. "f0"
theme.border_focus = theme.color_blue .. "f0"
theme.border_marked = theme.color_yellow .. "f0"
theme.taglist_fg_focus = theme.color_dark4
theme.taglist_fg_empty = theme.color_dark2
theme.taglist_bg_focus = theme.color_blue

theme.wibar_position = getopt "wibar.position"
theme.wibar_height = getopt "wibar.height"
theme.wibar_position = getopt "wibar.position"
theme.useless_gap = dpi(2)

-- Generate taglist squares:
local taglist_square_size = dpi(3)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = getopt "icon.theme"

theme.separator_thickness = 0.5

gtcrush(naughty.config, {
   icon_dirs = getopt "icon.path",
   icon_formats = { "png", "svg" },
})

gtcrush(naughty.config.presets, {
   low = {
      fg = theme.color_fg_dark,
      bg = theme.bg_normal,
      border_color = theme.color_dark1,
      timeout = 15,
   },
   normal = {
      fg = theme.color_fg,
      bg = theme.bg_normal,
      border_color = theme.color_blue,
      timeout = 30,
   },
   critical = {
      fg = theme.color_dark2,
      bg = theme.color_red,
      border_color = theme.color_dark4,
   },
})

local dbus = require "naughty.dbus"

dbus.config.mapping[1][2] = naughty.config.presets.low
dbus.config.mapping[2][2] = naughty.config.presets.normal
dbus.config.mapping[3][2] = naughty.config.presets.critical

return theme
