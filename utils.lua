-------------------------------------------------
-- utils for Awesome Window Manager

-- @author tema zaz
-- @copyright 2019 tema zaz
-------------------------------------------------


opening_brace = '['
closing_brace = ']'

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
function get_colorload(val)
   local color = theme.level_fg_good  -- '#ffaa00' -- normal
   if val > 85 then
      color = theme.level_fg_critical  -- '#ff1100' -- 'red'
   elseif val > 60 then
      color = theme.level_fg_normal  -- '#ff5500' -- 'yellow'
   end
   return color
end

----                                                                        ----
function colorify(str, color)
   return '<span foreground="'..color..'">'..str..'</span>'
end

----                                                                        ----
one_sec_timer = timer{timeout = 1}
five_sec_timer = timer{timeout = 5}
ten_sec_timer = timer{timeout = 10}
ten_min_timer = timer{timeout = 600}

----                                                                        ----
-- Start timers to update widgets
one_sec_timer:start()
five_sec_timer:start()
ten_sec_timer:start()
ten_min_timer:start()



