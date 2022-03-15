
local awful = require("awful")
local wibox = require("wibox")

-- Notification library
local naughty = require("naughty")

----                                                                        ----
hand_made_memory_box = wibox.widget.textbox()
hand_made_memory_box.font = theme.fontTTF

-- TODO reimpl in bash
----                                                                        ----
function parse_mem(str_meminfo)
    local total           = str_meminfo:match("MemTotal:%s+(%d+)")
    local free            = str_meminfo:match("MemFree:%s+(%d+)")
    local buffers         = str_meminfo:match("Buffers:%s+(%d+)")
    local cached          = str_meminfo:match("Cached:%s+(%d+)")
    local total_free      = free + buffers + cached
    local p_mem           = 100*(total - total_free)/total
    local mem_color       = get_colorload(p_mem)

    hand_made_memory_box:set_markup(make_percent_box('RAM',p_mem))
end

----                                                                        ----
function parse_swap(str_meminfo)
    -- local swap_total      = str_meminfo:match("SwapTotal:%s+(%d+)")
    -- local swap_free       = str_meminfo:match("SwapFree:%s+(%d+)")
    -- local swap_cached     = str_meminfo:match("SwapCached:%s+(%d+)")
    -- local total_swap_free = swap_free + swap_cached
    -- local sw_mem          = 100*(swap_total - total_swap_free)/swap_total
    -- local sw_mem_color    = get_colorload(sw_mem)
end

----                                                                        ----
function hm_memory()
    local io_meminfo      = io.open("/proc/meminfo")
    local str_meminfo     = io_meminfo:read("*a")
    io.close(io_meminfo)

    parse_mem(str_meminfo)
end

----                                                                        ----
function hand_made_memory()
    awful.spawn.easy_async_with_shell(
                           "echo",
                           function(stdout, stderr, reason, exit_code)
                              hm_memory()
                           end
    )
end

----                       HOVER                                            ----
function hmm_popup(timeout)
    local info
    local command = "for i in `seq 2 21`; do  ps ax -o pid,rss,%mem,cmd --sort=-rss | sed -n \"$i,$i p\"  | awk '{printf \"%s: %s%% %sM\" , $4, $3, int($2 / 1024)}' ;echo ; done | column -t"
    local out = assert(io.popen(command, 'r'))
    info = out:read("*all")
    out:close()

    hmm_popup_ = naughty.notify({
        text = info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
        })
end

function hmm_hover_addToWidget(widget)
    widget:connect_signal('mouse::enter', function () hmm_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(hmm_popup_) end)
end

hmm_hover_addToWidget(hand_made_memory_box)


----                                                                        ----
hand_made_memory()
one_sec_timer:connect_signal("timeout", hand_made_memory)




