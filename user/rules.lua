local button = require "awful.button"
local client = require "awful.client"
local mouse = require "awful.mouse"
local placement = require "awful.placement"
local screen = require "awful.screen"
local beautiful = require "beautiful"
local join = require("gears.table").join

local MouseButton = require("user.constants").MouseButton
local client_mappings = require("user.mappings").client
local option = require "user.options"

local MODKEY = option "modkey"
local myrules = option "rules"

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

local rules = {
   -- All clients will match this rule.
   {
      rule = {},
      properties = {
         border_width = beautiful.border_width,
         border_color = beautiful.border_normal,
         focus = client.focus.filter,
         keys = client_mappings,
         buttons = client_buttons,
         screen = screen.preferred,
         placement = placement.no_overlap + placement.no_offscreen,
      },
   },
}

if myrules.floating_clients then
   rules[#rules + 1] = {
      rule_any = myrules.floating_clients,
      properties = {
         floating = true,
         ontop = true,
         placement = placement.centered + placement.no_overlap,
      },
   }
end

if myrules.clients_by_tags then
   for t, r in pairs(myrules.clients_by_tags) do
      rules[#rules + 1] = {
         rule_any = r,
         properties = { tag = t },
      }
   end
end

if myrules.extras then
   for _, r in ipairs(myrules.extras) do
      rules[#rules + 1] = r
   end
end

return rules
