-- ## AWEZAZ config for awesome wm > 4.0.0

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- local vicious = require("vicious")
--awful.rules = require("awful.rules")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "awezaz/theme.lua")
-- beautiful.wallpaper = BGWLPPR

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
--local dbus = require("dbus")

--local volumearc = require("volumearc")
require("utils")
require("rc_local")
require("cmus")
require("updates_arch")
require("vm_status")
require("loker_status")
require("hand_made_cpu")
require("hand_made_memory")
require("hand_made_storage")
require("hand_made_time_date")
require("net_status")

-- Autorun
require("awful").spawn.with_shell("~/.config/awesome/autorun")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
terminal   = "urxvt"
editor     = os.getenv("EDITOR") or "nano"
browser    = "firefox"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu

office_menu = {
  {" Word", "libreoffice --writer"},
  {" Exel", "libreoffice --calc"}
}

--awesome_menu = {
--    { "RESTART", awesome.restart },
--    { "QUIT AWSUM", function() awesome.quit() end}
--}

-- TODO: make confirm popup
power_menu = {
  {" REBOOT", "urxvt", beautiful.reboot_icon},
  {" POWEROFF", "urxvt", beautiful.poweroff_icon}
}

-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end},
    { "manual", terminal .. " -e man awesome" },
   --{ "edit config", editor_cmd .. " " .. awesome.conffile },
    { "RESTART", awesome.restart },
    { "QUIT AWSUM", function() awesome.quit() end}

}

mymainmenu = awful.menu({ items = { { "AWSUM", myawesomemenu, beautiful.awesome_icon },
                                    { "TERM", terminal },
                                    { "LibreOffice", office_menu},
                                    { "-----"},
                                    { "POWER", power_menu}

                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()
mykeyboardlayout.widget.font = theme.fontTTF

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


--{{{{
--                                                                            --
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "[1]", "[2]", "[3]", "[4]", "[5]", "[6]", "[7]", "[8]", "[9] " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
    s.mytaglist.taglist_squares_resize   = true

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist
    {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,

        style   =
            {
                shape_border_width = 1,
                shape_border_color = '#824C00',
                shape  = gears.shape.octogon,
            },
        layout   =
            {
                spacing = 5,
                widget = wibox.container.place,
                layout = wibox.layout.flex.horizontal
            },

        widget_template =
            {
                {
                    {
                        {
                            {
                                id     = 'icon_role',
                                widget = wibox.widget.imagebox,
                            },
                            margins = 2,
                            widget  = wibox.container.margin,
                        },
                        {
                            id     = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left  = 18,
                    right = 18,
                    widget = wibox.container.margin
                },
                id     = 'background_role',
                forced_width    = 200,
                widget = wibox.container.background,
            },
    }


--------------------------------------------------------------------------------
hddbox = wibox.widget.textbox()
hddbox.font = theme.fontTTF
hdd_r = 0
hdd_w = 0
--hddlist = {'/sys/block/sda/stat', '/sys/block/sdb/stat'}
hddlist = {'/sys/block/sda/stat', '/sys/block/sda/stat'}

function hdd()
   local new_r = 0
   local new_w = 0
   for i = 1, 2 do
      local io_stat = io.open(hddlist[i])
      local str_stat = io_stat:read("*a")
      io.close(io_stat)
      local rd, wr = str_stat:match("%s+%d+%s+%d+%s+(%d+)%s+%d+%s+%d+%s+%d+%s+(%d+)")
      new_w = new_w + wr
      new_r = new_r + rd
   end
   local r = (new_r - hdd_r)/2
   local w = (new_w - hdd_w)/2
   hdd_w = new_w
   hdd_r = new_r

   hddbox:set_markup ( embrace(colorify('I/O: ', theme.fg_normal)
                       ..'(r: '
                       ..colorify(format_throughput(r), theme.level_fg_good)
                       ..', w:'
                       ..colorify(format_throughput(w), theme.level_fg_good)
                       ..')'))
end

--------------------------------------------------------------------------------
-- hdd()
-- one_sec_timer:connect_signal("timeout", hdd)
    main_mon = local_main_mon -- in rc_local

--                                                                            --
    bottom_wibox = {}
    layouts = {}
    scr = s.index

    bottom_wibox[scr] = awful.wibar({ position = "bottom" , screen = scr })
    layouts[scr] = wibox.layout.align.horizontal()
    layouts[scr]:set_left(s.mytasklist)
    if s.index == main_mon then
        local tray = wibox.widget.systray()
        tray:set_screen(s)
        bottom_wibox[scr]:setup
        {
            layout = wibox.layout.align.horizontal(),
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                layouts[scr],
            },
            { -- Middle widgets
                layout = wibox.layout.fixed.horizontal,
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                tray,
                hand_made_time_date_box
            }
        }
    else
        bottom_wibox[scr]:set_widget(layouts[scr])
    end

--                                                                            --
    -- Create the wibox
    s.mywibox = awful.wibar({ height = 25, position = "top", screen = s })

    -- Add widgets to the wibox
    if s.index == main_mon then

        s.mywibox:setup
        {
            layout = wibox.layout.align.horizontal(),
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mylayoutbox,
                s.mytaglist,
                s.mypromptbox,
            },
            { -- Middle widgets
                layout = wibox.layout.fixed.horizontal,
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                -- wibox.widget.systray(),
                hand_made_memory_box,
                hand_made_cpu_box,
                hand_made_storage_box,
                tb_cmus,
                --hddbox,
                net_status_box,
                updates_arch_box,
                loker_status_box,
                mykeyboardlayout,
                --volumearc,
                hand_made_time_date_box,
                vm_st_box
            }
        }
    else
        s.mywibox:setup
        {
            layout = wibox.layout.align.horizontal(),
            {
                layout = wibox.layout.fixed.horizontal,
                s.mylayoutbox,
                s.mytaglist,
            },
            {
                layout = wibox.layout.fixed.horizontal,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                --wibox.widget.systray(),
                hand_made_memory_box,
                hand_made_cpu_box,
                hand_made_time_date_box,
            }
        }
    end


end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),


    awful.key({ modkey,  "Shift"  }, "w",
              function ()
                  if client.focus then
                      local current_tag = client.focus.first_tag
                      local next_tag = client.focus.screen.tags[current_tag.index + 1]
                      if next_tag then
                          client.focus:move_to_tag(next_tag)
                          naughty.notify({text="moved to " .. next_tag.index })
              --            awful.tag.viewnext
                      end
                 end
              end,
              {description = "move focused client to next tag ", group = "tag"}),



    awful.key({ modkey,           }, "1",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "2",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),


--    awful.key({ modkey            }, "L", function () awful.util.spawn('slimlock') end),


    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ "Mod1"            }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

--    awful.key({         "Shift"   }, "Print", function () awful.util.spawn("bash -c 'import png:- | xclip -selection c -t image/png'") end),
--    awful.key({ modkey            }, "l", function () awful.util.spawn("bash -c 'slock'") end),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    awful.key({ modkey, "Shift" }, "y", awful.placement.centered,
              {description = "centering window", group = "client"}),

    -- Simulate Windows 7 'edge snap' (also called aero snap) feature
    awful.key({ modkey }, "Left",
        function ()
            awful.placement.left(client.focus)
            awful.placement.scale(client.focus,{to_percent = 0.5})
            awful.placement.maximize_vertically(client.focus,{honor_workarea=true})
        end,
        {description = "snap left", group = "client"}),

    -- Simulate Windows 7 'edge snap' (also called aero snap) feature
    awful.key({ modkey }, "Right",
        function ()
            local f = (awful.placement.right + awful.placement.scale + awful.placement.maximize_vertically)
            f(client.focus, {honor_workarea=true, to_percent = 0.5})
        end,
        {description = "snap right", group = "client"}),


    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({   "Mod1"         }, "F4",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),

       -- toggle titlebar
    awful.key({ modkey, "Control" }, "t",   function (c) awful.titlebar.toggle(c)                    end,
              {description = "toggle titlebar", group = "client"}),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey, "Control" }, "f",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
--        awful.key({ modkey }, "#" .. i + 9,
--                  function ()
--                        local screen = awful.screen.focused()
--                        local tag = screen.tags[i]
--                        if tag then
--                           tag:view_only()
--                        end
--                  end,
--                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
--                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred
                     --placement = awful.placement.centered
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "*",
          --"URxvt",
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true },
         callback = function (c) awful.placement.centered(c,nil) end
},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        {  --Left
            -- function (c)
            -- c.minimized = true
            -- end ,
            awful.titlebar.hide(c),
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
            --awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}


-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--        and awful.client.focus.filter(c) then
--        client.focus = c
--    end
--end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
