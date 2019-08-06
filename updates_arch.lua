
local wibox = require("wibox")
local awful = require("awful")

----                                                                        ----
updates_arch_box = wibox.widget.textbox()
updates_arch_box.font = theme.fontTTF

----                                                                        ----
function updates_arch()
    awful.spawn.easy_async("updates_arch.sh", function(stdout, stderr, reason, exit_code)
        updates_arch_box:set_text(stdout)
    end)
end

----                                                                        ----
updates_arch()
ten_min_timer:connect_signal("timeout", updates_arch)
