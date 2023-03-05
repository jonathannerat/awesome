---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require "beautiful.theme_assets"
local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font = "FantasqueSansMono Nerd Font 10"

theme.color_red = "#f7768e"
theme.color_orange = "#ff9e64"
theme.color_yellow = "#e0af68"
theme.color_green = "#9ece6a"
theme.color_torquise = "#73daca"
theme.color_torquise_light = "#b4f9f8"
theme.color_torquise_dark = "#2ac3de"
theme.color_blue_light = "#7dcfff"
theme.color_blue = "#7aa2f7"
theme.color_purple = "#bb9af7"
theme.color_fg = "#c0caf5"
theme.color_fg_dark = "#a9b1d6"
theme.color_fg_darker = "#9aa5ce"
theme.color_dark1 = "#565f89"
theme.color_dark2 = "#414868"
theme.color_dark3 = "#24283b"
theme.color_dark4 = "#1a1b26"

theme.notification_icon_size = dpi(48)
theme.notification_width = dpi(250)
theme.notification_max_width = dpi(350)
theme.notification_font = "Roboto, Regular 10"
theme.bg_solid = theme.color_dark4
theme.bg_normal = theme.color_dark4
theme.bg_focus = theme.color_dark3
theme.bg_urgent = theme.color_dark4
theme.fg_normal = theme.color_fg
theme.fg_focus = theme.color_blue
theme.fg_urgent = theme.color_yellow
theme.fg_minimize = theme.color_fg
theme.border_width = dpi(2)
theme.border_normal = theme.color_dark3 .. "f0"
theme.border_focus = theme.color_purple .. "f0"
theme.border_marked = theme.color_yellow .. "f0"
theme.taglist_fg_focus = theme.color_dark4
theme.taglist_fg_empty = theme.color_dark2
theme.taglist_bg_focus = theme.color_blue
theme.useless_gap = 2

-- Generate taglist squares:
local taglist_square_size = dpi(3)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

theme.separator_thickness = 0.5

local gt = require("gears.table")
local naughty = require("naughty")

gt.crush(naughty.config, {
    icon_dirs = {
        "/usr/share/pixmaps/",
        "/usr/share/hicolor/",
        "/usr/share/icons/Papirus-Dark/",
    },
    icon_formats = { "png", "svg", }
})

gt.crush(naughty.config.presets, {
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
    }
})

local dbus = require("naughty.dbus")

dbus.config.mapping[1][2] = naughty.config.presets.low
dbus.config.mapping[2][2] = naughty.config.presets.normal
dbus.config.mapping[3][2] = naughty.config.presets.critical

return theme
