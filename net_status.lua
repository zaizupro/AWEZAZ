
local wibox = require("wibox")
local awful = require("awful")

----                                                                        ----
net_status = wibox.widget.textbox()
-- net_status:set_text("[ 🖧 ]")
net_status:set_text("[ 䍝 ]")
net_status_buttons = awful.util.table.join
    (
    awful.button({ }, 1, function () awful.spawn.easy_async("chec_network_state") end
                )
    )

----                                                                        ----
net_status:buttons(net_status_buttons)
