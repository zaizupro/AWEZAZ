
local wibox = require("wibox")

----                                                                        ----
loker_status_box = wibox.widget.textbox()
loker_status_box.font = theme.fontTTF

----                                                                        ----
function loker_status()
    status="undef"
    out = assert(io.popen("chek_autolok", 'r'))
    status = out:read("*all")
    out:close()
    if 'DISABLED' == status then
        loker_status_box:set_markup('[ '..colorify(status, "#ff2200")..' ]')
    end
    if 'ENABLED' == status then
        loker_status_box:set_markup('[ '..status..' ]')
    end
end

----                                                                        ----
loker_status()
ten_sec_timer:connect_signal("timeout", loker_status)
