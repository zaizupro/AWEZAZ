-------------------------------------------------
-- utils for Awesome Window Manager

-- @author tema zaz
-- @copyright 2019 tema zaz
-------------------------------------------------

local gears = require("gears")

-- Notification library
local naughty = require("naughty")
local awful = require("awful")


opening_brace = '['
closing_brace = ']'

----                                                                        ----
function trim1(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

----                                                                        ----
function embrace(str)
    return ""..opening_brace..str..closing_brace..''
end

----                                                                        ----
function format_throughput(val)
   if (val < 1000) then
      return string.format('%3dKB/s', val)
   elseif (val < 10240) then
      return string.format('%.1fMB/s', val/1024)
   else
      return string.format('%.fMB/s', val/1024)
   end
end

----                                                                        ----
----                                                                        ----
function get_colorload(value)
   local current_val = tonumber(value)
   local color = theme.level_fg_good  -- '#ffaa00' -- normal
   if (current_val > 85) then
      color = theme.level_fg_critical  -- '#ff1100' -- 'red'
   elseif (current_val > 60) then
      color = theme.level_fg_normal  -- '#ff5500' -- 'yellow'
   end
   return color
end

----                                                                        ----
function colorify(str, color)
   return '<span foreground="'..color..'">'..str..'</span>'
end

----                                                                        ----
function embrace_clr(str, color)
   return embrace(colorify(str, color))
end

----                                                                        ----
function make_percent_box(txt, value)
   local current_val = tonumber(value)
   local color = get_colorload(value)
   if current_val > 99 then current_val = 99 end

   return embrace(
                  colorify(txt..':', theme.fg_normal)
                  ..colorify(string.format('%2d%%', math.floor(current_val)), color)
                 )
end

----                                                                        ----
function notify_dat(txt)
            if (txt ~= "") then
                notify_dat_popup = naughty.notify({
                text = txt,
                timeout = timeout,
                hover_timeout = 0.5,
                screen = awful.screen.focused()
                })
            end
end

----                                                                        ----
one_sec_timer = gears.timer{timeout = 1}
five_sec_timer = gears.timer{timeout = 5}
ten_sec_timer = gears.timer{timeout = 10}
one_min_timer = gears.timer{timeout = 60}
ten_min_timer = gears.timer{timeout = 600}

----                                                                        ----
-- Start timers to update widgets
one_sec_timer:start()
five_sec_timer:start()
ten_sec_timer:start()
one_min_timer:start()
ten_min_timer:start()



