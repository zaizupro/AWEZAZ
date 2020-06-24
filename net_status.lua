
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

----                                                                        ----
net_status = wibox.widget.textbox()
net_status.font = theme.fontTTF
net_status:set_text("[ NET ]")
net_status_buttons = awful.util.table.join
    (
    awful.button({ }, 1, function ()
                            net_status_popup = naughty.notify({
                                text = "net status check started...",
                                timeout = timeout,
                                hover_timeout = 0.5,
                                screen = awful.screen.focused()
                                })
                            awful.spawn.easy_async("chec_network_state")
                        end
                )
    )

----                                                                        ----
net_status:buttons(net_status_buttons)
