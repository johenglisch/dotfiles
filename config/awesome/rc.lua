require("config")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local theme_assets = require("beautiful.theme_assets")
local naughty = require("naughty")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")


-- Error handling

if awesome.startup_errors
then
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

-- theme.fg_normal     = "#bbbbbb"
-- theme.bg_normal     = "#222222"
-- theme.border_normal = "#444444"
-- 
-- theme.fg_focus      = "#eeeeee"
-- theme.bg_focus      = "#550077"
-- theme.border_focus  = "#00ff00"
--
-- theme.awesome_icon = theme_assets.awesome_icon(20, theme.fg_focus, theme.bg_focus)

-- theme.useless_gap = 3

theme.useless_gap = 3

theme.fg_normal = "#222222"
theme.bg_normal = "#e6e6e6"
theme.border_normal = "#888888"

theme.bg_focus = "#6868da"
theme.fg_focus = "#eeeeee"
-- theme.border_focus = "#6868da"
theme.border_focus = "#494999"

theme.bg_systray = theme.bg_normal

theme.awesome_icon = theme_assets.awesome_icon(20, theme.bg_focus, theme.fg_focus)

local taglist_square_size = 4
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)


-- Layouts

awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max,
}


-- Teh bar

mystatusbar = awful.widget.watch('awesome-status', 2)

if has_fdo
then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_terminal,
        }
    })
end

mylauncher = awful.widget.launcher({
    image = theme.awesome_icon,
    menu = mymainmenu })

mytextclock = wibox.widget.textclock(" %a, %d %b %R ")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({MODKEY}, 1, function(t)
        if client.focus
        then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({MODKEY}, 3, function(t)
        if client.focus
        then
            client.focus:toggle_tag(t)
        end
    end))

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus
        then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true})
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
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
    -- container for changing the background colour of the layoutbox
    s.mylayoutbox_bg = wibox.container.background(s.mylayoutbox, theme.bg_focus)

    s.mytaglist = awful.widget.taglist {
        screen = s,
        --filter = awful.widget.taglist.filter.noempty,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons}
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons}

    s.mywibox = awful.wibar({position = "top", screen = s})
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mylayoutbox_bg,
            s.mypromptbox,
        },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mystatusbar,
            mytextclock
        },
    }
end)


-- Global key bindings

function view_all()
    local tags = awful.screen.focused().tags
    for _, tag in pairs(tags) do
        tag.selected = true
    end
end

function move_to_all()
    local focused_client = client.focus
    if not focused_client
    then
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
    awful.key({MODKEY}, "t",          function() awful.layout.set(awful.layout.suit.tile) end),
    awful.key({MODKEY, "Shift"}, "f", function() awful.layout.set(awful.layout.suit.floating) end),
    awful.key({MODKEY, "Shift"}, "m", function() awful.layout.set(awful.layout.suit.max) end),
    awful.key({MODKEY}, "space",      function() awful.layout.inc( 1) end),
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
    --awful.key({MODKEY}, "t",               function(c) c.ontop = not c.ontop end),
    awful.key({MODKEY}, "m",
        function(c)
            if awful.layout.get() == awful.layout.suit.floating
            then
                c.maximized = not c.maximized
            end
        end),
    awful.key({MODKEY, "Shift"}, "m",      function(c) c.maximized = false c:raise() end))

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({MODKEY}, i,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag
                then
                    tag:view_only()
                end
            end),
        -- Toggle tag display.
        awful.key({MODKEY}, "F"..i,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag
                then
                    awful.tag.viewtoggle(tag)
                end
            end),
        -- Move client to tag.
        awful.key({MODKEY, "Shift"}, i,
            function()
                if client.focus
                then
                    local tag = client.focus.screen.tags[i]
                    if tag
                    then
                        client.focus:move_to_tag(tag)
                    end
                end
            end),
        -- Toggle tag on focused client.
        awful.key({MODKEY, "Shift"}, "F"..i,
            function()
                if client.focus
                then
                    local tag = client.focus.screen.tags[i]
                    if tag
                    then
                        client.focus:toggle_tag(tag)
                    end
                end
            end))
end

root.keys(globalkeys)


-- Window rules

clientbuttons = gears.table.join(
    awful.button({}, 1,       function(c) client.focus = c; c:raise() end),
    awful.button({MODKEY}, 1, function(c) awful.mouse.client.move(c, 0) end),
    awful.button({MODKEY}, 3, awful.mouse.client.resize))

-- FIXME does the restore thing even work..?
local placement_func =
    awful.placement.center
    + awful.placement.no_overlap
    + awful.placement.restore
    + awful.placement.no_offscreen

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = theme.border_width,
            border_color = theme.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = placement_func
        }
    },
    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog", "utility" }
      }, properties = { titlebars_enabled = true }
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
    },
    {
        rule_any = { class = { "Conky" } },
        properties = {
            below = true,
            border_width = 0,
            sticky = true,
            focusable = false
        }
    }
}



-- Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c)
    then
        client.focus = c
    end
end)

client.connect_signal("focus",   function(c) c.border_color = theme.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = theme.border_normal end)


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        -- XXX is there a way to make this double-click
        awful.button({ }, 2, function()
            c:lower()
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end))

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
