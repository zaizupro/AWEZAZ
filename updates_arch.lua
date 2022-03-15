
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local button = require("awful.button")
local gtable = require("gears.table")
----                                                                        ----
updates_arch_box = wibox.widget.textbox()
updates_arch_box.font = theme.fontTTF
updates_arch_box:set_text("[###]")

----                                                                        ----
function updates_arch_show_list()
    local command = ". ~/.bashrc; export UPDATES=$(checkupdates | cut -d ' ' -f 1) "
        .. " && urxvt -geometry 30x20 -e sh -c "
        .. " 'echo -e \"$UPDATES\n\n\" | less -SR '"

    awful.spawn.easy_async_with_shell(command,
        function(stdout, stderr, reason, exit_code)
            updates_arch_popup = naughty.notify({ text = stdout})
        end)
end

----                                                                        ----
function updates_arch()
    local command = '. ~/.bashrc; updates_arch.sh'
    awful.spawn.easy_async_with_shell(command,
    function(stdout, stderr, reason, exit_code)
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
function run_update_window()
    command = "urxvt -name pup -title pup -e bash -i -c 'echo RACH UPATE ; pup ; read -p press_any_key ' &"
    awful.spawn.easy_async_with_shell(command,{})
end

----                                                                        ----
updates_arch_box:buttons(
    gtable.join(
            button({           }, 1, function() updates_arch() end),
            button({ "Control" }, 1, function() run_update_window() end),
            button({           }, 3, function() updates_arch_show_list() end)
        )
    )


----                       HOVER                                            ----
function hmosu_popup(timeout)
    local out = assert(io.popen("cat /var/log/pacman.log | grep 'PACMAN' | grep 'starting full system upgrade' | cut -f 1 -d' ' | tr -d '[]' | tail  | xargs -I {} date '+%d %m %Y [%H:%M] [%A]' -d {}", 'r'))
    local info = out:read("*all")
    out:close()

    hmosu_popup_ = naughty.notify({
        text = info,
        timeout = timeout,
        hover_timeout = 0.5,
        screen = awful.screen.focused()
      })
end

----                                                                        ----
function hmosu_hover_add_to_widget(widget)
    widget:connect_signal('mouse::enter', function () hmosu_popup(0) end)
    widget:connect_signal('mouse::leave', function () naughty.destroy(hmosu_popup_) end)
end

hmosu_hover_add_to_widget(updates_arch_box)

----                                                                        ----
updates_arch()
ten_min_timer:connect_signal("timeout", updates_arch)
