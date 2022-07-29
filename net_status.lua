
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

require("utils")

----                                                                        ----
function net_status_start_check()
    notify_dat("net status check: \nSTARTED...")
    command = ". ~/.bashrc; chec_network_state"
    awful.spawn.easy_async_with_shell(command,
        function(stdout, stderr, reason, exit_code)
            notify_dat(stderr)
            if (stderr ~= "") then
                net_status_box:set_markup(embrace_clr("NET", "#ff7700"))
            end
        end)
end

----                                                                        ----
net_status_box = wibox.widget.textbox()
net_status_box.font = theme.fontTTF
net_status_box:set_markup(embrace("NET"))
net_status_buttons = awful.util.table.join
    (
    awful.button({ }, 1, function ()
                            net_status_start_check()
                        end
                )
    )

net_status_box:buttons(net_status_buttons)

----                                                                        ----
function net_status_popup(timeout)
    local out = assert(io.popen("ip a | grep 'inet ' | awk '{print $2}'", 'r'))
    local info = out:read("*all")
    out:close()

    net_status_popup_ = naughty.notify({
        text = info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
      })
end

----                                                                        ----
function net_status_over_add_to_widget(widget)
    widget:connect_signal('mouse::enter', function () net_status_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(net_status_popup_) end)
end

net_status_over_add_to_widget(net_status_box)
--one_min_timer:connect_signal("timeout", net_status_start_check)
----                                                                        ----
