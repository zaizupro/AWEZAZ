
local awful = require("awful")
local wibox = require("wibox")

-- Notification library
local naughty = require("naughty")

----                                                                        ----
hand_made_time_date_box = wibox.widget.textbox()
hand_made_time_date_box.font = theme.fontTTF

----                                                                        ----
function hand_made_time_date()
    time_date="undef"
    out = assert(io.popen("echo -n $(date '+%a %b %F')", 'r'))
    date = out:read("*all")
    out = assert(io.popen("echo -n $(date '+%R:%S')", 'r'))
    time = out:read("*all")
    out:close()
    time_date= date..' '..time
    hand_made_time_date_box:set_markup('[ '..date..' '..
                                        colorify(time , theme.fg_urgent)..' ]')
end

----                                                                        ----
cmnd=[[notify-send "$(cal -m)"]]
cmnd2=[[notify-send "$(cal -m -3)"]]
cmnd_=[[notify-send -t 0 "$(cal -m)"]]
cmnd2_=[[notify-send -t 0 "$(cal -m -3)"]]
hand_made_time_date_buttons = awful.util.table.join(
    awful.button({ }, 1, function () awful.spawn.with_shell(cmnd) end),
    awful.button({ "Control" }, 1, function () awful.spawn.with_shell(cmnd_) end),
    awful.button({ }, 3, function () awful.spawn.with_shell(cmnd2) end),
    awful.button({ "Control" }, 3, function () awful.spawn.with_shell(cmnd2_) end)
    )

hand_made_time_date_box:buttons(hand_made_time_date_buttons)

----                                                                        ----
function hmtd_popup(timeout)
    local out = assert(io.popen("cal -m", 'r'))
    local info = out:read("*all")
    out:close()

    hmtd_popup_ = naughty.notify({
        text = info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
      })
end

----                                                                        ----
function hmtd_over_add_to_widget(widget)
    widget:connect_signal('mouse::enter', function () hmtd_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(hmtd_popup_) end)
end

hmtd_over_add_to_widget(hand_made_time_date_box)

----                                                                        ----
hand_made_time_date()
five_sec_timer:connect_signal("timeout", hand_made_time_date)

