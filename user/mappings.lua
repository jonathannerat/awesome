local awesome = awesome
local client = client

local awful_client = require "awful.client"
local awful_key = require "awful.key"
local lain = require "lain.util"
local layout = require "awful.layout"
local naughty = require "naughty"
local screen = require "awful.screen"
local join = require("gears.table").join
local tags = require "awful.tag"

local MODKEY = require("user.utils").custom("modkey")

local function map(mod, key, fn)
   if not fn then
      fn = key
      key = mod
      mod = {}
   end

   if type(mod) ~= "table" then
      mod = { mod }
   end

   return awful_key(mod, key, fn)
end

local quaketerm = lain.quake {
   app = "alacritty",
   name = "QuakeAlacritty",
   argname = "-t QuakeAlacritty",
   extra = "--class QuakeAlacritty -e tmux new -A -s quake",
   followtag = true,
   height = 0.6,
   width = 0.6,
   vert = "center",
   horiz = "center",
}

local quakennn = lain.quake {
   app = "alacritty",
   name = "QuakeNNN",
   argname = "-t QuakeNNN",
   extra = "--class QuakeNNN -o font.size=10 -e n",
   followtag = true,
   height = 0.6,
   width = 0.6,
   vert = "center",
   horiz = "center",
}

local quakemutt = lain.quake {
   app = "alacritty",
   name = "QuakeNeomutt",
   argname = "-t QuakeNeomutt",
   extra = "--class QuakeNeomutt -o font.size=8 -e neomutt",
   followtag = true,
   height = 0.8,
   width = 0.6,
   vert = "center",
   horiz = "center",
}

local global_keys = join(
   map(MODKEY, "Left", function()
      lain.tag_view_nonempty(-1)
   end),
   map(MODKEY, "Right", function()
      lain.tag_view_nonempty(1)
   end),
   map(MODKEY, "Tab", tags.history.restore),

   map(MODKEY, "j", function()
      awful_client.focus.byidx(1)
   end),
   map(MODKEY, "k", function()
      awful_client.focus.byidx(-1)
   end),
   -- Layout manipulation
   map({ MODKEY, "Shift" }, "j", function()
      awful_client.swap.byidx(1)
   end),
   map({ MODKEY, "Shift" }, "k", function()
      awful_client.swap.byidx(-1)
   end),
   map(MODKEY, ",", function()
      screen.focus_relative(1)
   end),
   map(MODKEY, ".", function()
      screen.focus_relative(-1)
   end),
   map(MODKEY, "u", awful_client.urgent.jumpto),
   map(MODKEY, "grave", function()
      awful_client.focus.history.previous()
      if client.focus then
         client.focus:raise()
      end
   end),
   map({ MODKEY, "Shift" }, "grave", function()
      naughty.destroy_all_notifications(nil, naughty.notificationClosedReason.dismissedByUser)
   end),

   map({ MODKEY, "Shift" }, "r", awesome.restart),
   map({ MODKEY, "Shift" }, "q", awesome.quit),

   map(MODKEY, "l", function()
      tags.incmwfact(0.05)
   end),
   map(MODKEY, "h", function()
      tags.incmwfact(-0.05)
   end),
   map({ MODKEY, "Shift" }, "h", function()
      tags.incnmaster(1, nil, true)
   end),
   map({ MODKEY, "Shift" }, "l", function()
      tags.incnmaster(-1, nil, true)
   end),
   map({ MODKEY, "Control" }, "h", function()
      tags.incncol(1, nil, true)
   end),
   map({ MODKEY, "Control" }, "l", function()
      tags.incncol(-1, nil, true)
   end),
   map({ MODKEY, "Control" }, "k", function()
      layout.inc(1)
   end),
   map({ MODKEY, "Control" }, "j", function()
      layout.inc(-1)
   end),

   map({ MODKEY, "Control" }, "n", function()
      local c = awful_client.restore()
      -- Focus restored client
      if c then
         c:emit_signal("request::activate", "key.unminimize", { raise = true })
      end
   end),

   map({ MODKEY, "Control" }, "Return", function()
      quaketerm:toggle()
   end),

   map({ MODKEY, "Control" }, "e", function()
      quakennn:toggle()
   end),

   map({ MODKEY, "Control" }, "m", function()
      quakemutt:toggle()
   end),

   -- Prompt
   map(MODKEY, "p", function()
      screen.focused().my_widgets.prompt:run()
   end),

   map(MODKEY, "b", function()
      local wibar = screen.focused().my_widgets.wibar
      wibar.visible = not wibar.visible
   end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
   global_keys = join(
      global_keys,
      -- View tag only.
      map(MODKEY, "#" .. i + 9, function()
         local focused = screen.focused()
         local tag = focused.tags[i]
         if tag then
            tag:view_only()
         end
      end),
      -- Toggle tag display.
      map({ MODKEY, "Control" }, "#" .. i + 9, function()
         local focused = screen.focused()
         local tag = focused.tags[i]
         if tag then
            tags.viewtoggle(tag)
         end
      end),
      -- Move client to tag.
      map({ MODKEY, "Shift" }, "#" .. i + 9, function()
         if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
               client.focus:move_to_tag(tag)
            end
         end
      end),
      -- Toggle tag on focused client.
      map({ MODKEY, "Control", "Shift" }, "#" .. i + 9, function()
         if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
               client.focus:toggle_tag(tag)
            end
         end
      end)
   )
end

local client_keys = join(
   map(MODKEY, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
   end),
   map(MODKEY, "q", function(c)
      c:kill()
   end),
   map({ MODKEY, "Shift" }, "f", awful_client.floating.toggle),
   map(MODKEY, "Return", function(c)
      c:swap(awful_client.getmaster())
   end),
   map(MODKEY, "o", function(c)
      c:move_to_screen()
   end),
   map(MODKEY, "t", function(c)
      c.ontop = not c.ontop
   end),
   map(MODKEY, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
   end),
   map(MODKEY, "m", function(c)
      c.maximized = not c.maximized
      c:raise()
   end),

   -- Client transformations
   map({ MODKEY, "Control", "Shift" }, "h", function(c)
      c:relative_move(0, 0, -20, 0)
   end),
   map({ MODKEY, "Control", "Shift" }, "l", function(c)
      c:relative_move(0, 0, 20, 0)
   end),
   map({ MODKEY, "Control", "Shift" }, "k", function(c)
      c:relative_move(0, 0, 0, -20)
   end),
   map({ MODKEY, "Control", "Shift" }, "j", function(c)
      c:relative_move(0, 0, 0, 20)
   end),

   map({ MODKEY, "Mod1" }, "h", function(c)
      local geo = c:geometry()
      c:relative_move(-geo.x, 0, 0, 0)
   end),
   map({ MODKEY, "Mod1" }, "l", function(c)
      local cgeo = c:geometry()
      local sgeo = c.screen.geometry
      local delta = sgeo.width - cgeo.x - cgeo.width - 2 * c.border_width
      c:relative_move(delta, 0, 0, 0)
   end),
   map({ MODKEY, "Mod1" }, "k", function(c)
      local geo = c:geometry()
      c:relative_move(0, -geo.y, 0, 0)
   end),
   map({ MODKEY, "Mod1" }, "j", function(c)
      local cgeo = c:geometry()
      local sgeo = c.screen.geometry
      local delta = sgeo.height - cgeo.y - cgeo.height - 2 * c.border_width
      c:relative_move(0, delta, 0, 0)
   end),

   map(MODKEY, "c", function(c)
      local cgeo = c:geometry()
      local sgeo = c.screen.geometry
      local xdelta = (sgeo.width - cgeo.width - 2 * c.border_width) / 2 - cgeo.x
      local ydelta = (sgeo.height - cgeo.height - 2 * c.border_width) / 2 - cgeo.y
      c:relative_move(xdelta, ydelta, 0, 0)
   end),

   map({ MODKEY, "Mod1", "Control" }, "h", function(c)
      c:relative_move(-20, 0, 0, 0)
   end),
   map({ MODKEY, "Mod1", "Control" }, "l", function(c)
      c:relative_move(20, 0, 0, 0)
   end),
   map({ MODKEY, "Mod1", "Control" }, "k", function(c)
      c:relative_move(0, -20, 0, 0)
   end),
   map({ MODKEY, "Mod1", "Control" }, "j", function(c)
      c:relative_move(0, 20, 0, 0)
   end)
)

return {
   global = global_keys,
   client = client_keys,
}
