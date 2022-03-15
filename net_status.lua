
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

----                                                                        ----
net_status_box = wibox.widget.textbox()
net_status_box.font = theme.fontTTF
net_status_box:set_text("[ NET ]")
net_status_buttons = awful.util.table.join
    (
    awful.button({ }, 1, function ()
                            local net_status_popup = naughty.notify({
                                text = "net status check: \nSTARTED...",
                                timeout = timeout,
                                hover_timeout = 0.5,
                                screen = awful.screen.focused()
                                })
                            awful.spawn.easy_async("chec_network_state")
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

----                                                                        ----

