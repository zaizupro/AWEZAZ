
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

----                                                                        ----
updates_arch_box = wibox.widget.textbox()
updates_arch_box.font = theme.fontTTF

----                                                                        ----
function updates_arch()
    awful.spawn.easy_async("updates_arch.sh", function(stdout, stderr, reason, exit_code)
        updates_arch_box:set_text(stdout)
        updates_arch_popup = naughty.notify({
            text = "arch updates refreshed",
            timeout = timeout,
            hover_timeout = 0.5,
            screen = awful.screen.focused()
            })
    end)
end

----                                                                        ----
updates_arch_buttons = awful.util.table.join(
    awful.button({ }, 1, function() updates_arch() end),
    awful.button({ }, 3, function() updates_arch() end)
    )

updates_arch_box:buttons(updates_arch_buttons)

----                                                                        ----
updates_arch()
ten_min_timer:connect_signal("timeout", updates_arch)
