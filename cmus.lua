-------------------------------------------------
-- cmus Widget for Awesome Window Manager
-- Shows the current cmus state

-- @author tema zaz
-- @copyright 2019 tema zaz
-------------------------------------------------

local awful = require("awful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

----                                                                        ----
--local paused_indicator='॥ '
-- local paused_indicator='|'
-- local paused_indicator='⣿'
 local paused_indicator='⏸'
-- local paused_indicator='Ⅱ'
-- local paused_indicator='⏸'

--local play_indicator='>'
local play_indicator='▶'
--local play_indicator='►'
-- local play_indicator=''
-- local play_indicator='⏵' -- ⏴

----                                                                        ----
function cmus_hook()
    -- check if cmus is running
    local cmus_run = getCmusPid()
    if cmus_run then
        out = assert(io.popen("cmus-remote -Q", 'r'))
        cmus_info = out:read("*all")
        out:close()
        if not cmus_info then return "." end
        cmus_status = string.match(cmus_info, "status %a*")
        if cmus_status == nil then return "." end
        cmus_state = string.gsub(cmus_status,"status ","")
        if cmus_state == "playing" or cmus_state == "paused" then
            if cmus_state == "paused" then
                cmus_string = paused_indicator
            else
                cmus_string = play_indicator
            end
        else
--            cmus_string = '◾'
            cmus_string = '◼'
        end
        return cmus_string
    else
        return '!run'
    end
end

----                                                                        ----
-- Get cmus PID to check if it is running
function getCmusPid()
    local fpid = assert(io.popen("pgrep -x cmus", 'r'))
    local pid = fpid:read("*n")
    fpid:close()
    return pid
end

----                                                                        ----
-- Enable cmus control
function cmus_control (action)
    local cmus_info, cmus_state
    local cmus_run = getCmusPid()
    if cmus_run then
        local out = assert(io.popen("cmus-remote -Q", 'r'))
        cmus_info = out:read("*all")
        out:close()
        if not cmus_info then return end
        cmus_state = string.gsub(string.match(cmus_info, "status %a*"),
                                         "status ", "")
        if cmus_state ~= "stopped" then
            if action == "next" then
                assert(io.popen("cmus-remote -n", 'r'))
            elseif action == "previous" then
                assert(io.popen("cmus-remote -r", 'r'))
            elseif action == "stop" then
                assert(io.popen("cmus-remote -s", 'r'))
            end
        end
        if action == "play_pause" then
            if cmus_state == "playing" or cmus_state == "paused" then
                assert(io.popen("cmus-remote -u", 'r'))
            elseif cmus_state == "stopped" then
                assert(io.popen("cmus-remote -p", 'r'))
            end
        end
    end
end

----                       HOVER                                            ----
function cmus_popup(timeout)
    local cmus_info
    local out = assert(io.popen(". ~/.bashrc; cmus_info", 'r'))
    cmus_info = out:read("*all")
    out:close()

    popup = naughty.notify({
        text = cmus_info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
        })
end

----                                                                        ----
function cmusover_addToWidget(widget)
    widget:connect_signal('mouse::enter', function () cmus_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(popup) end)
end

----                                                                        ----
tb_cmus = wibox.widget.textbox()
tb_cmus.font = theme.fontTTF
tb_cmus:set_text("[ cmus ]")

----                                                                        ----
-- refresh Cmus widget
cmus_timer = gears.timer{timeout = 1}
cmus_timer:connect_signal(
    "timeout",
    function()
        tb_cmus:set_text('[ ' .. cmus_hook() .. ' ]')
        end)
cmus_timer:start()

----                                                                        ----
--
cmusbuttons = awful.util.table.join(
    awful.button({ }, 1, function() cmus_control("play_pause") end),
    awful.button({ }, 3,
        function()
            command = "urxvt -name cmus -title cmus -e bash -i -c 'tma cmus' &"
            awful.spawn.easy_async_with_shell(command,{})
        end)
)
tb_cmus:buttons(cmusbuttons)
cmusover_addToWidget(tb_cmus)


return tb_cmus

