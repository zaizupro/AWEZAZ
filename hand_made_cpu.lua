
local awful = require("awful")
local wibox = require("wibox")

-- Notification library
local naughty = require("naughty")

----                                                                        ----
hand_made_cpu_box = wibox.widget.textbox()
hand_made_cpu_box.font = theme.fontTTF

----                                                                        ----
cpu_arr = {}
cpu0_arr = {}
cpu1_arr = {}
for i = 0, 4 do
    cpu_arr[i] = 0
    cpu0_arr[i] = 0
    cpu1_arr[i] = 0
end

----                                                                        ----
function parse_cpu(cpu, stat)
    local cpu_new = {}
    local ret = {}
    cpu_new[0], cpu_new[1], cpu_new[2], cpu_new[3], cpu_new[4] = stat:match("cpu%d*%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")

    local idle   = (cpu_new[3] - cpu[3]) + (cpu_new[4] - cpu[4])
    local user   = (cpu_new[1] - cpu[1]) + (cpu_new[0] - cpu[0])
    local system = (cpu_new[2] - cpu[2])
    local total  = idle + user + system
    local busy   = user + system

    ret['busy'] = busy*100/total
    ret['sys'] = system*100/total
    ret['user'] = user*100/total
    ret['cpu'] = cpu_new

    return ret
end

----                                                                        ----
function hm_cpu()
    local io_stat  = io.open("/proc/stat")
    local str_stat = io_stat:read("*l")
    io.close(io_stat)

    local ret = parse_cpu(cpu_arr, str_stat)
    cpu_arr = ret['cpu']
    local cpu_cur_value = ret['busy']
    hand_made_cpu_box:set_markup(make_percent_box('CPU',cpu_cur_value))
end

----                                                                        ----
function hand_made_cpu()
    awful.spawn.easy_async_with_shell(
                           "echo",
                           function(stdout, stderr, reason, exit_code)
                               hm_cpu()
                           end
    )
end


----                       HOVER                                            ----
function hmc_popup(timeout)
    local info
    local command = "for i in $(seq 2 21); do  ps ax -o pid,pcpu,ucmd --sort=-pcpu | sed -n \"$i,$i p\"  | awk '{printf \"%s: %s%%\" , $3, $2  }' ;echo ; done | column -t"
    local out = assert(io.popen(command, 'r'))
    info = out:read("*all")
    out:close()

    hmc_popup_ = naughty.notify({
        text = info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
        })
end

function hmc_hover_addToWidget(widget)
    widget:connect_signal('mouse::enter', function () hmc_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(hmc_popup_) end)
end

hmc_hover_addToWidget(hand_made_cpu_box)

----                                                                        ----
hand_made_cpu()
one_sec_timer:connect_signal("timeout", hand_made_cpu)
