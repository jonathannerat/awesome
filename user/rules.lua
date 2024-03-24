local mouse = require "awful.mouse"
local beautiful = require "beautiful"
local client_mappings = require("user.mappings").client
local placement = require "awful.placement"
local screen = require "awful.screen"

local dpi = require("beautiful.xresources").apply_dpi
local join = require("gears.table").join
local button = require "awful.button"

local enums = require "user.enums"
local TagIcons = enums.TagIcons
local MouseButton = enums.MouseButton

local MODKEY = require("user.utils").getopt "modkey"

-- ## Key bindings

local client_buttons = join(
   button({}, MouseButton.LEFT, function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
   end),
   button({ MODKEY }, MouseButton.LEFT, function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      mouse.client.move(c)
   end),
   button({ MODKEY }, MouseButton.RIGHT, function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      mouse.client.resize(c)
   end)
)

return {
   -- All clients will match this rule.
   {
      rule = {},
      properties = {
         border_width = beautiful.border_width,
         border_color = beautiful.border_normal,
         -- focus = client.focus.filter,
         raise = true,
         keys = client_mappings,
         buttons = client_buttons,
         screen = screen.preferred,
         placement = placement.no_overlap + placement.no_offscreen,
      },
   },

   -- Floating clients.
   {
      rule_any = {
         class = {
            "Arandr",
            "Sxiv",
            "Pavucontrol",
            "ssh-askpass",
            "Connman-gtk",
            "Blueman-manager",
            "Qalculate-gtk",
         },

         -- Note that the name property shown in xprop might be set slightly after creation of the client
         -- and the name shown there might not match defined rules here.
         name = {
            "Event Tester", -- xev.
         },
         role = {
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
         },
      },
      properties = { floating = true, border_width = dpi(1), placement = placement.centered },
   },

   {
      rule = {
         class = "albert",
         instance = "albert",
         name = "Albert",
      },
      except = { name = "Settings" },
      properties = {
         border_width = 0,
         skip_taskbar = true,
      },
   },
   {
      rule = { class = "Liberwolf" },
      properties = { tag = TagIcons.BROWSER },
   },
   {
      rule = { instance = "floating-alacritty" },
      properties = {
         floating = true,
         placement = placement.centered,
      },
   },
   {
      rule = { name = "zoom" },
      properties = {
         floating = true,
         placement = placement.top + placement.right,
      },
   },
   {
      rule_any = {
         class = {
            "discord",
            "KotatogramDesktop",
            "Mailspring",
            "thunderbird",
         },
      },
      properties = { tag = TagIcons.CHAT },
   },
}
