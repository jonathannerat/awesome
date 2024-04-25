-- Suppress undefined global warnings
---@diagnostic disable-next-line: undefined-global
local awesome, client, mouse = awesome, client, mouse

local awful = require "awful"
local beautiful = require "beautiful"
local gtable = require "gears.table"
local lain = require "lain.util"
local naughty = require "naughty"
local wibox = require "wibox"

local rounded_corners = require("user.utils.widget").rounded_corners

local MODKEY = require "user.options" "modkey"

local function map(mod, key, fn)
   if not fn then
      fn = key
      key = mod
      mod = {}
   end

   if type(mod) ~= "table" then
      mod = { mod }
   end

   return awful.key(mod, key, fn)
end

local quaketerm = lain.quake {
   app = "alacritty",
   name = "QuakeAlacritty",
   argname = "-t QuakeAlacritty",
   extra = "--class QuakeAlacritty -o font.size=8 -e tmux new -A -s quake",
   followtag = true,
   height = 0.65,
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

local shell_prompt = awful.widget.prompt()

local w = wibox {
   ontop = true,
   height = 34,
   width = 200,
   bg = beautiful.bg_normal,
   shape = rounded_corners(5),
   shape_border_color = "#ff0088",
}

w:setup {
   widget = wibox.container.margin,
   margins = 5,

   shell_prompt,
}

local mylayoutlist = awful.widget.layoutlist {
   base_layout = wibox.widget {
      spacing = 5,
      forced_num_cols = 3,
      layout = wibox.layout.grid.vertical,
   },
   widget_template = {
      {
         {
            id = "icon_role",
            forced_height = 30,
            forced_width = 30,
            widget = wibox.widget.imagebox,
         },
         margins = 4,
         widget = wibox.container.margin,
      },
      id = "background_role",
      forced_width = 32,
      forced_height = 32,
      shape = rounded_corners(5),
      widget = wibox.container.background,
   },
}
local layout_popup = awful.popup {
   widget = wibox.widget {
      mylayoutlist,
      margins = 4,
      widget = wibox.container.margin,
   },
   border_color = beautiful.border_color,
   border_width = beautiful.border_width,
   placement = awful.placement.centered,
   ontop = true,
   visible = false,
   shape = rounded_corners(10),
}

awful.keygrabber {
   start_callback = function()
      layout_popup.visible = true
   end,
   stop_callback = function()
      layout_popup.visible = false
   end,
   export_keybindings = true,
   release_event = "release",
   stop_key = { "Escape", "Super_L", "Super_R" },
   keybindings = {
      {
         { MODKEY },
         "Prior",
         function()
            awful.layout.inc(-1)
         end,
      },
      {
         { MODKEY },
         "Next",
         function()
            awful.layout.inc(1)
         end,
      },
   },
}

local global_keys = gtable.join(
   map(MODKEY, "Left", function()
      lain.tag_view_nonempty(-1)
   end),
   map(MODKEY, "Right", function()
      lain.tag_view_nonempty(1)
   end),
   map(MODKEY, "Tab", awful.tag.history.restore),

   map(MODKEY, "j", function()
      awful.client.focus.byidx(1)
   end),
   map(MODKEY, "k", function()
      awful.client.focus.byidx(-1)
   end),
   -- Layout manipulation
   map({ MODKEY, "Shift" }, "j", function()
      awful.client.swap.byidx(1)
   end),
   map({ MODKEY, "Shift" }, "k", function()
      awful.client.swap.byidx(-1)
   end),
   map(MODKEY, ",", function()
      awful.screen.focus_relative(1)
   end),
   map(MODKEY, ".", function()
      awful.screen.focus_relative(-1)
   end),
   map(MODKEY, "u", awful.client.urgent.jumpto),
   map(MODKEY, "grave", function()
      awful.client.focus.history.previous()
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
      awful.tag.incmwfact(0.05)
   end),
   map(MODKEY, "h", function()
      awful.tag.incmwfact(-0.05)
   end),
   map({ MODKEY, "Shift" }, "h", function()
      awful.tag.incnmaster(1, nil, true)
   end),
   map({ MODKEY, "Shift" }, "l", function()
      awful.tag.incnmaster(-1, nil, true)
   end),
   map({ MODKEY, "Control" }, "h", function()
      awful.tag.incncol(1, nil, true)
   end),
   map({ MODKEY, "Control" }, "l", function()
      awful.tag.incncol(-1, nil, true)
   end),

   map({ MODKEY, "Control" }, "n", function()
      local c = awful.client.restore()
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

   map({ MODKEY }, "p", function()
      w.visible = true
      awful.placement.bottom_left(w, {
         margins = { bottom = 4, left = 4 },
         parent = mouse.screen,
      })
      awful.prompt.run {
         prompt = "<b>Run</b>: ",
         textbox = shell_prompt.widget,
         completion_callback = awful.completion.shell,
         exe_callback = awful.spawn,
         done_callback = function()
            w.visible = false
         end,
      }
   end),

   map(MODKEY, "b", function()
      local wibar = awful.screen.focused().wibar
      wibar.visible = not wibar.visible
   end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
   global_keys = gtable.join(
      global_keys,
      -- View tag only.
      map(MODKEY, "#" .. i + 9, function()
         local focused = awful.screen.focused()
         local tag = focused.tags[i]
         if tag then
            tag:view_only()
         end
      end),
      -- Toggle tag display.
      map({ MODKEY, "Control" }, "#" .. i + 9, function()
         local focused = awful.screen.focused()
         local tag = focused.tags[i]
         if tag then
            awful.tag.viewtoggle(tag)
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

local client_keys = gtable.join(
   map(MODKEY, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
   end),
   map(MODKEY, "q", function(c)
      c:kill()
   end),
   map({ MODKEY, "Shift" }, "f", awful.client.floating.toggle),
   map(MODKEY, "Return", function(c)
      c:swap(awful.client.getmaster())
   end),
   map(MODKEY, "o", function(c)
      c:move_to_screen()
   end),
   map(MODKEY, "s", function(c)
      c.sticky = not c.sticky
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
