
local awful = require("awful")
local wibox = require("wibox")

-- Notification library
local naughty = require("naughty")

----                                                                        ----
hand_made_storage_box = wibox.widget.textbox()
hand_made_storage_box.font = theme.fontTTF
hand_made_storage_box:set_markup(embrace_clr("storage", "#ff0000"))

----                                                                        ----
function hand_made_storage()
    command = ". ~/.bashrc; storage_info"
    awful.spawn.easy_async_with_shell(command,
        function(stdout, stderr, reason, exit_code)
            local cur_value = stdout
            notify_dat(stderr)
            hand_made_storage_box:set_markup(make_percent_box('STORAGE',cur_value))
        end)
end

----                                                                        ----
hms_cmnd=[[notify-send -t 0 "$(storage_info verbose)"]]
hand_made_storage_buttons = awful.util.table.join(
    awful.button({ }, 1, function () awful.spawn.easy_async_with_shell(hms_cmnd) end)
    )

hand_made_storage_box:buttons(hand_made_storage_buttons)

----                       HOVER                                             ----
function hmstorage_popup(timeout)
    local out = assert(io.popen(". ~/.bashrc; storage_info label_verbose", 'r'))
    local info = out:read("*all")
    out:close()

    hmstorage_popup_ = naughty.notify({
        text = info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
      })
end

----                                                                        ----
function hmstorage_hover_add_to_widget(widget)
    widget:connect_signal('mouse::enter', function () hmstorage_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(hmstorage_popup_) end)
end

hmstorage_hover_add_to_widget(hand_made_storage_box)

----                                                                        ----
hand_made_storage()
five_sec_timer:connect_signal("timeout", hand_made_storage)

