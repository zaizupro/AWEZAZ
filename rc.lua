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
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
--local dbus = require("dbus")

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
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "awezaz/theme.lua")
-- beautiful.wallpaper = BGWLPPR

-- This is used later as the default terminal and editor to run.
terminal   = "urxvt"
editor     = os.getenv("EDITOR") or "nano"
browser    = "opera"
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

-- menu template
tmp_menu = {
  {" Word", "urxvt"},
  {" Exel", "urxvt"}
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

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()
mykeyboardlayout.widget.font = theme.fontTTF

-- {{{ Wibar
-- Create a textclock widget
--mytextclock = wibox.widget.textclock()
mytextclock = awful.widget.textclock( '<span color="#FF9500"> [%A ~ %d.%m.%Y] </span> [%H:%M:%S]', 5)
mytextclock.font = theme.fontTTF


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

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ " *** ", " *** ", " *** ", " 0 ", " 0 ", " 0 ", " 0 ", " 0 ", " 0 " }, s, awful.layout.layouts[2])

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

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

--------------------------------------------------------------------------------
--opening_brace = '<span foreground="'..theme.fg_normal..'" font_desc="Ubuntu">[</span>'
opening_brace = '<span foreground="'..theme.fg_normal..'" font_desc="8x13bold">[</span>'
--closing_brace = '<span foreground="'..theme.fg_normal..'" font_desc="Ubuntu">] </span>'
-- closing_brace = '<span foreground="'..theme.fg_normal..'" font_desc="8x13bold">] </span>'

opening_brace = '['
closing_brace = ']'

--------------------------------------------------------------------------------
function embrace(str)
    return ""..opening_brace..str..closing_brace..''
end

--------------------------------------------------------------------------------
one_sec_timer = timer{timeout = 1}
ten_sec_timer = timer{timeout = 10}

--------------------------------------------------------------------------------
function format_throughput(val)
   if (val < 1000) then
      return string.format('%3dKB/s', val)
   elseif (val < 10240) then
      return string.format('%.1fMB/s', val/1024)
   else
      return string.format('%.fMB/s', val/1024)
   end
end

--------------------------------------------------------------------------------
function get_colorload(val)
   local color = theme.level_fg_good  -- '#ffaa00' -- normal
   if val > 85 then
      color = theme.level_fg_critical  -- '#ff1100' -- 'red'
   elseif val > 60 then
      color = theme.level_fg_normal  -- '#ff5500' -- 'yellow'
   end
   return color
end
--------------------------------------------------------------------------------

function colorify(str, color)
   return '<span foreground="'..color..'">'..str..'</span>'
end
--------------------------------------------------------------------------------
membox = wibox.widget.textbox()
membox.font = theme.fontTTF
function memory()
   local io_meminfo      = io.open("/proc/meminfo")
   local str_meminfo     = io_meminfo:read("*a")
   io.close(io_meminfo)

   local total           = str_meminfo:match("MemTotal:%s+(%d+)")
   local free            = str_meminfo:match("MemFree:%s+(%d+)")
   local buffers         = str_meminfo:match("Buffers:%s+(%d+)")
   local cached          = str_meminfo:match("Cached:%s+(%d+)")
   local swap_total      = str_meminfo:match("SwapTotal:%s+(%d+)")
   local swap_free       = str_meminfo:match("SwapFree:%s+(%d+)")
   local swap_cached     = str_meminfo:match("SwapCached:%s+(%d+)")

   local total_free      = free + buffers + cached
   local total_swap_free = swap_free + swap_cached

   local p_mem           = 100*(total - total_free)/total
   local mem_color       = get_colorload(p_mem)
   local sw_mem          = 100*(swap_total - total_swap_free)/swap_total
   local sw_mem_color    = get_colorload(sw_mem)

   local p_mem           = 100*(total - total_free)/total
   local mem_color       = get_colorload(p_mem)
   local sw_mem          = 100*(swap_total - total_swap_free)/swap_total
   local sw_mem_color    = get_colorload(sw_mem)

   membox:set_markup(embrace(
                             colorify('RAM: ', theme.fg_normal)
                             ..colorify(string.format('%.f%%', p_mem), mem_color)
                             --..'('..colorify(string.format('%.fMb', (total - total_free)/1024), mem_color)
                             --..colorify(string.format('/%.fMb', (total)/1024), 'orange')
                             --..')'
                            )
                     -- ..
                     -- embrace(
                     --         colorify('swap: ', theme.fg_normal)
                     --         ..colorify(string.format('%.f%%', sw_mem), sw_mem_color)
                     --         --..'('..colorify(string.format('%.fMb', (swap_total - total_swap_free)/1024), sw_mem_color)
                     --         --..colorify(string.format('/%.fMb', (swap_total)/1024), 'white')
                     --         --..')'
                     --        )
                     )
end

--------------------------------------------------------------------------------
memory()
one_sec_timer:connect_signal("timeout", memory)

--------------------------------------------------------------------------------
cpugraph = awful.widget.graph()
cpugraph:set_width(75)
cpugraph:set_height(25)
cpugraph:set_background_color("#494B4F")
--cpugraph:set_color("#FF5656")
cpugraph:set_color({ type = "horisontal", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#FF5656" }, { 0.5, "#88A175" }, { 1, "#AECF96" } }})
-- Register CPU widget
-- vicious.register(cpugraph, vicious.widgets.cpu,
--                     function (widget, args)
--                         return args[1]
--                     end)
cpubox = wibox.widget.textbox()
cpubox.font = theme.fontTTF

cpubox_img = wibox.widget.imagebox()
cpu_arr = {}
cpu0_arr = {}
cpu1_arr = {}
for i = 0, 4 do
   cpu_arr[i] = 0
   cpu0_arr[i] = 0
   cpu1_arr[i] = 0
end

--------------------------------------------------------------------------------
function parse_cpu(cpu, stat)
   local cpu_new = {}
   local ret = {}
   cpu_new[0], cpu_new[1], cpu_new[2], cpu_new[3], cpu_new[4] = stat:match("cpu%d*%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")

   local idle   = (cpu_new[3] - cpu[3]) + (cpu_new[4] - cpu[4])
   local user   = (cpu_new[1] - cpu[1]) + (cpu_new[0] - cpu[0])
   local system = (cpu_new[2] - cpu[2])
   local total  = idle + user + system
   local busy   = user + system

   ret['busy'] = busy*100/total
   ret['sys'] = system*100/total
   ret['user'] = user*100/total
   ret['cpu'] = cpu_new

   return ret
end

--------------------------------------------------------------------------------
function cpu()
   local io_stat  = io.open("/proc/stat")
   local str_stat = io_stat:read("*l")
   io.close(io_stat)

   local ret = parse_cpu(cpu_arr, str_stat)
   cpu_arr = ret['cpu']

   cpubox:set_markup (embrace(colorify('CPU: ', theme.fg_normal)
                       -- ..colorify(string.format('%.f%%', ret['busy']), get_colorload(ret['busy']))
                       ..colorify(string.format('%.f%%', ret['busy']), get_colorload(ret['busy']))
                       -- ..') | (u:'
                       -- ..colorify(string.format('%.f%%', ret['user']), get_colorload(ret['user']))
                       -- ..', s:'
                       -- ..colorify(string.format('%.f%%', ret['sys']), get_colorload(ret['sys']))
                       -- ..')'
                             )
                     )
end

cpu()
one_sec_timer:connect_signal("timeout", cpu)

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
hdd()
one_sec_timer:connect_signal("timeout", hdd)

--------------------------------------------------------------------------------





-- Start timers to update widgets
one_sec_timer:start()
ten_sec_timer:start()
--------------------------------------------------------------------------------
bottom_wibox = {}
for scr = 1, screen.count() do
    local l_layout = wibox.layout.fixed.horizontal()
--    l_layout:add(membox)
    -- l_layout.width(10)
    l_layout:add(s.mytasklist)
    bottom_wibox[scr] = awful.wibox({ position = "bottom" --, height = "25"
         , screen = scr })

    local lay = wibox.layout.align.horizontal()
    lay:set_left(l_layout)
    bottom_wibox[scr]:set_widget(lay)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })



    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal(),
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        { -- Middle widgets
            layout = wibox.layout.fixed.horizontal,
       -- s.mytasklist
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            membox,
            cpubox,
            hddbox,
            mykeyboardlayout,
            mytextclock,
            s.mylayoutbox,
        }
    }
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
    awful.key({ modkey,           }, "1",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "2",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),


    awful.key({ modkey            }, "L", function () awful.util.spawn('slimlock') end),


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
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({         "Shift"   }, "Print", function () awful.util.spawn("bash -c 'import png:- | xclip -selection c -t image/png'") end),

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
    awful.key({ modkey,           }, "m",
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
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
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
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
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
      }, properties = { floating = true }},

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
        { -- Left
--	     function (c)
    	--     c.minimized = true
--	     end ,

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

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
