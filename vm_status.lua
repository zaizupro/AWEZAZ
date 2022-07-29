
local awful = require("awful")
local wibox = require("wibox")

----                                                                        ----
vm_st_box = wibox.widget.textbox()
vm_st_box.font = theme.fontTTF

----                                                                        ----
function vm_st()
    vm_st_box:set_markup('[VM]')
end

----                                                                        ----
function vm_st_open_tmux()
    command = "urxvt -name VM -title VM -e bash -i -c 'tma VM' &"
    awful.spawn.easy_async_with_shell(command,{})
end

----                                                                        ----
function vm_st_show_status()
    local vm_st_cmnd_=[[notify-send -t 0 "$(vbx st)"]]
    awful.spawn.easy_async_with_shell(vm_st_cmnd_)
end

----                                                                        ----
vm_st_buttons = awful.util.table.join(
    awful.button({ }, 1, vm_st_show_status ),
    awful.button({ }, 3, vm_st_open_tmux )
    )

vm_st_box:buttons(vm_st_buttons)

----                                                                        ----
vm_st()

