-- vi: fdm=marker
-- Globals
local awesome = awesome
local client = client
local root = root
-- Standard awesome library
local gears = require "gears"
local awful = require "awful"
-- Widget and layout library
local wibox = require "wibox"
-- Notification library
local naughty = require "naughty"
-- Theme handling library
local beautiful = require "beautiful"

local lain = require('lain')

awful.spawn("systemctl --user start autostart.target")

require "awful.autofocus"

-- ## Error checking {{{

-- ### Before startup
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    }
end

-- ### After startup {{{
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        }
        in_error = false
    end)
end
-- }}}
-- }}}

-- ## Variable definitions {{{
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "/user/themes/default.lua")

local modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.max,
}

local MouseButton = {
    LEFT = 1,
    MIDDLE = 2,
    RIGHT = 3,
    SCROLL_UP = 4,
    SCROLL_DOWN = 5,
}
-- }}}

-- ## Wibar {{{
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, MouseButton.LEFT, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, MouseButton.LEFT, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, MouseButton.RIGHT, awful.tag.viewtoggle),
    awful.button({ modkey }, MouseButton.RIGHT, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, MouseButton.SCROLL_UP, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, MouseButton.SCROLL_DOWN, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, MouseButton.LEFT, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({ }, MouseButton.RIGHT, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end)
)

local named_tags = {
    terminal = " ",
    browser = " ",
    documents = " ",
    school = " ",
    music = " ",
    camera = " ",
    code = " ",
    chat = " ",
    games = " "
}

local tags = gears.table.map(function (k) return named_tags[k] end, {
    "terminal",
    "browser",
    "documents",
    "school",
    "music",
    "camera",
    "code",
    "chat",
    "games"
})

local cycleclock = require "user.widget.cycleclock"

local systray = wibox.widget.systray()
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag(tags, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar { position = "top", screen = s }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,

        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },

        s.mytasklist, -- Middle widget

        { -- Right widgets
            { -- Status with separator
                {
                    cycleclock { " %a %d -  %H:%M", " %B %d, %A -  %H:%M" },
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 15,
                    spacing_widget = {
                        widget = wibox.widget.separator,
                    },
                },
                widget = wibox.container.margin,
                left = 10,
            },
            systray,
            s.mylayoutbox,

            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
        },
    }
end)
-- }}}

-- ## Key bindings {{{
local quaketerm = lain.util.quake {
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

local globalkeys = gears.table.join(
    awful.key({ modkey }, "Left", function ()
        lain.util.tag_view_nonempty(-1)
    end, { description = "view previous noempty", group = "tag" }),
    awful.key({ modkey }, "Right", function ()
        lain.util.tag_view_nonempty(1)
    end, { description = "view next noempty", group = "tag" }),
    awful.key({ modkey }, "Tab", awful.tag.history.restore, { description = "go back", group = "tag" }),

    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),
    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, ",", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey }, ".", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey }, "grave", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "go back", group = "client" }),
    awful.key({ modkey, "Shift" }, "grave", function()
        naughty.destroy_all_notifications(nil, naughty.notificationClosedReason.dismissedByUser)
    end, { description = "close all notifications", group = "notifications" }),

    awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "k", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Control" }, "j", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),

    awful.key({ modkey, "Control" }, "Return", function()
        quaketerm:toggle()
    end, { description = "toggle", group = "awesome" }),

    -- Prompt
    awful.key({ modkey }, "p", function()
        awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x", function()
        awful.prompt.run {
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        }
    end, { description = "lua execute prompt", group = "awesome" }),

    awful.key({ modkey }, "b", function()
        local mywibox = awful.screen.focused().mywibox
        mywibox.visible = not mywibox.visible
    end)
)

local clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    awful.key(
        { modkey, "Shift" },
        "f",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),
    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey }, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, { description = "minimize", group = "client" }),
    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" }),

    -- Client transformations
    awful.key({ modkey, "Control", "Shift" }, "h", function(c)
        c:relative_move(0, 0, -20, 0)
    end, { description = "decrease client width", group = "client transformations" }),
    awful.key({ modkey, "Control", "Shift" }, "l", function(c)
        c:relative_move(0, 0, 20, 0)
    end, { description = "increase client width", group = "client transformations" }),
    awful.key({ modkey, "Control", "Shift" }, "k", function(c)
        c:relative_move(0, 0, 0, -20)
    end, { description = "decrease client height", group = "client transformations" }),
    awful.key({ modkey, "Control", "Shift" }, "j", function(c)
        c:relative_move(0, 0, 0, 20)
    end, { description = "increase client height", group = "client transformations" }),

    awful.key({ modkey, "Mod1" }, "h", function(c)
        local geo = c:geometry()
        c:relative_move(-geo.x, 0, 0, 0)
    end, { description = "move client to left screen border", group = "client transformations" }),
    awful.key({ modkey, "Mod1" }, "l", function(c)
        local cgeo = c:geometry()
        local sgeo = c.screen.geometry
        local delta = sgeo.width - cgeo.x - cgeo.width - 2*c.border_width
        c:relative_move(delta, 0, 0, 0)
    end, { description = "move client to right screen border", group = "client transformations" }),
    awful.key({ modkey, "Mod1" }, "k", function(c)
        local geo = c:geometry()
        c:relative_move(0, -geo.y, 0, 0)
    end, { description = "move client to top border", group = "client transformations" }),
    awful.key({ modkey, "Mod1" }, "j", function(c)
        local cgeo = c:geometry()
        local sgeo = c.screen.geometry
        local delta = sgeo.height - cgeo.y - cgeo.height - 2*c.border_width
        c:relative_move(0, delta, 0, 0)
    end, { description = "move client to bottom border", group = "client transformations" }),

    awful.key({ modkey }, "c", function(c)
        local cgeo = c:geometry()
        local sgeo = c.screen.geometry
        local xdelta = (sgeo.width - cgeo.width - 2*c.border_width) / 2 - cgeo.x
        local ydelta = (sgeo.height - cgeo.height - 2*c.border_width) / 2 - cgeo.y
        c:relative_move(xdelta, ydelta, 0, 0)
    end, { description = "move client to center", group = "client transformations" }),

    awful.key({ modkey, "Mod1", "Control" }, "h", function(c)
        c:relative_move(-20, 0, 0, 0)
    end, { description = "move client left", group = "client transformations" }),
    awful.key({ modkey, "Mod1", "Control" }, "l", function(c)
        c:relative_move(20, 0, 0, 0)
    end, { description = "move client right", group = "client transformations" }),
    awful.key({ modkey, "Mod1", "Control" }, "k", function(c)
        c:relative_move(0, -20, 0, 0)
    end, { description = "move client up", group = "client transformations" }),
    awful.key({ modkey, "Mod1", "Control" }, "j", function(c)
        c:relative_move(0, 20, 0, 0)
    end, { description = "move client down", group = "client transformations" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

local clientbuttons = gears.table.join(
    awful.button({}, MouseButton.LEFT, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, MouseButton.LEFT, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, MouseButton.RIGHT, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- ## Rules {{{
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
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
        properties = { floating = true },
    },

    {
        rule = { class = "liberwolf" },
        properties = { tag = named_tags.browser },
    },
    {
        rule = { instance = "floating-alacritty" },
        properties = {
            floating = true,
            placement = awful.placement.centered,
        },
    },
    {
        rule_any = {
            class = {
                "discord",
                "KotatogramDesktop",
                "Mailspring",
            },
        },
        properties = { tag = named_tags.chat },
    },
}
-- }}}

-- ## Signals {{{
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local last_systray_screen = nil
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus

    -- move systray to focused client's screen (if it hasn't changed)
    if last_systray_screen ~= c.screen then
        systray:set_screen(c.screen)
        systray:emit_signal("widget::redraw_needed")
        last_systray_screen = c.screen
    end
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
