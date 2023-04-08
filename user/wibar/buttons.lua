-- Suppress undefined globals
local client = client

local join = require("gears.table").join
local tags = require "awful.tag"
local button = require "awful.button"
local menu = require "awful.menu"
local MouseButton = require("user.enums").MouseButton
local MODKEY = require("user.constants").MODKEY

local function bmap(mod, key, fn)
   if not fn then
      fn = key
      key = mod
      mod = {}
   end

   if type(mod) ~= "table" then
      mod = { mod }
   end

   return button(mod, key, fn)
end

local taglist = join(
   bmap(MODKEY, MouseButton.LEFT, function(t)
      if client.focus then
         client.focus:move_to_tag(t)
      end
   end),
   bmap(MODKEY, MouseButton.RIGHT, function(t)
      if client.focus then
         client.focus:toggle_tag(t)
      end
   end),
   bmap(MouseButton.LEFT, function(t)
      t:view_only()
   end),
   bmap(MouseButton.RIGHT, tags.viewtoggle),
   bmap(MouseButton.SCROLL_UP, function(t)
      tags.viewnext(t.screen)
   end),
   bmap(MouseButton.SCROLL_DOWN, function(t)
      tags.viewprev(t.screen)
   end)
)

local tasklist = join(
   bmap(MouseButton.LEFT, function(c)
      if c == client.focus then
         c.minimized = true
      else
         c:emit_signal("request::activate", "tasklist", { raise = true })
      end
   end),
   bmap(MouseButton.RIGHT, function()
      menu.client_list { theme = { width = 250 } }
   end)
)

return {
   taglist = taglist,
   tasklist = tasklist,
}
