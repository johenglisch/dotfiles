require("config")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")


-- Error Handling

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors})
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)})
        in_error = false
    end)
end


-- Theming

--beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
local theme = beautiful.get()
theme.font = FONT
theme.border_width = BORDER_WIDTH

theme.fg_normal     = "#f8f8f8"
theme.bg_normal     = "#222222"

theme.fg_focus      = "#f8f8f8"
theme.bg_focus      = "#777799"

theme.border_normal = "#222222"
theme.border_focus  = "#777799"


awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating}

mystatusbar = awful.widget.watch('awesome-status', 2)


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({MODKEY}, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({MODKEY}, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end))

awful.screen.connect_for_each_screen(function(s)
    awful.tag(TAGS, s, awful.layout.layouts[1])
    for i = 1, 9 do
        s.tags[i].master_width_factor = MFACT
    end

    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end)))

    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, taglist_buttons)
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused)

    s.mywibox = awful.wibar({position = "top", screen = s})
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mylayoutbox,
            s.mypromptbox
        },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            mystatusbar,
            wibox.widget.systray()
        },
    }
end)

function view_all()
    local tags = awful.screen.focused().tags
    for _, tag in pairs(tags) do
        tag.selected = true
    end
end

function move_to_all()
    local focused_client = client.focus
    if not focused_client then
        return
    end
    local tags = awful.screen.focused().tags
    focused_client:tags(tags)
end

globalkeys = gears.table.join(
    awful.key({MODKEY}, "p",          function() awful.spawn(DMENU_CMD) end),
    awful.key({MODKEY}, "Return",     function() awful.spawn(TERMINAL) end),
    awful.key({MODKEY}, "h",          function() awful.tag.incmwfact(-0.05) end),
    awful.key({MODKEY}, "l",          function() awful.tag.incmwfact(0.05) end),
    awful.key({MODKEY}, "k",          function() awful.client.focus.byidx(-1) end),
    awful.key({MODKEY}, "j",          function() awful.client.focus.byidx(1) end),
    awful.key({MODKEY}, "s",          function() awful.tag.incnmaster( 1, nil, true) end),
    awful.key({MODKEY}, "d",          function() awful.tag.incnmaster(-1, nil, true) end),
    awful.key({MODKEY, "Shift"}, "j", function() awful.client.swap.byidx(1) end),
    awful.key({MODKEY, "Shift"}, "k", function() awful.client.swap.byidx(-1) end),
    awful.key({MODKEY}, ",",          function() awful.screen.focus_relative(-1) end),
    awful.key({MODKEY}, ".",          function() awful.screen.focus_relative(1) end),
    awful.key({MODKEY}, "u",          awful.client.urgent.jumpto),
    awful.key({MODKEY, "Shift"}, "r", awesome.restart),
    awful.key({MODKEY, "Shift"}, "q", awesome.quit),
    awful.key({MODKEY}, "space",      function() awful.layout.inc( 1) end),
    awful.key({MODKEY}, "0",          view_all),
    awful.key({MODKEY, "Shift"}, "0", move_to_all))

clientkeys = gears.table.join(
    awful.key({MODKEY, "Shift"}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),
    awful.key({MODKEY, "Shift"}, "c",      function(c) c:kill() end),
    awful.key({MODKEY, "Shift"}, "space",  awful.client.floating.toggle),
    awful.key({MODKEY, "Shift"}, "Return", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({MODKEY, "Shift"}, ",",      function(c) c:move_to_screen() end),
    awful.key({MODKEY, "Shift"}, ".",      function(c) c:move_to_screen() end),
    awful.key({MODKEY}, "t",               function(c) c.ontop = not c.ontop end),
    awful.key({MODKEY, "Shift"}, "m",      function(c) c.maximized = false c:raise() end))

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({MODKEY}, i,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end),
        -- Toggle tag display.
        awful.key({MODKEY}, "F"..i,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end),
        -- Move client to tag.
        awful.key({MODKEY, "Shift"}, i,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end),
        -- Toggle tag on focused client.
        awful.key({MODKEY, "Shift"}, "F"..i,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end))
end

clientbuttons = gears.table.join(
    awful.button({}, 1,       function(c) client.focus = c; c:raise() end),
    awful.button({MODKEY}, 1, awful.mouse.client.move),
    awful.button({MODKEY}, 3, awful.mouse.client.resize))

root.keys(globalkeys)

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = BORDER_WIDTH,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "copyq",  -- Includes session name in class.
            },
            class = {
                "qjackctl"
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "pop-up",
            }
        },
        properties = {floating = true}
    }
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
