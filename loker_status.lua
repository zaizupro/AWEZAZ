
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty") -- DEBUG

----                                                                        ----
loker_status_box = wibox.widget.textbox()
loker_status_box.font = theme.fontTTF

chek_lok_CMD=". ~/.bashrc; chek_autolok"

----                                                                        ----
function loker_status()

    awful.spawn.easy_async_with_shell(chek_lok_CMD, function(stdout, stderr, reason, exit_code)
        status = trim1(stdout)

        if status ~= "1" and status ~= "0" then
            loker_status_box:set_markup('['..colorify("x", "#ff0000")..']')
        else
            if '0' == status then
                loker_status_box:set_markup('['.."+"..']')
            end
            if '1' == status then
                loker_status_box:set_markup('['..colorify("-", "#ff4400")..']')
            end
        end
    end)
end

----                                                                        ----
loker_status()
ten_sec_timer:connect_signal("timeout", loker_status)
