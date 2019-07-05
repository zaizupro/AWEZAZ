--------------------------------------------------------------------------------
--                                                                            --
--                      "awezaz" awesome theme                                --
--                        awsum version 4.0.0                                 --
--                        By ZaiZu.                                           --
--                                                                            --
--------------------------------------------------------------------------------


-- {{{ Main
theme = {}
theme.wallpaper_cmd = { "awsetbg $HOME/.BGWALPPR" }
-- }}}

-- {{{ Styles
theme.font         = "8x13bold"
theme.fontTTF      = "Misc Fixed Bold 14"

-- theme.font         = "xos4 Terminus bold 14"   -- arch linux
-- theme.fontTTF      = "xos4 Terminus bold 14"

theme.taglist_font = theme.fontTTF
theme.tasklist_font = theme.fontTTF

theme.fg0 = "#F7D8A4"
theme.fg1 = "#DBBF91"
theme.fg2 = "#99825C"
theme.bg0 = "#212017"
theme.bg1 = "#3D1800"
theme.bg2 = "#5F5030"


-- {{{ Colors
theme.bg_normal     = theme.bg0
theme.fg_normal     = theme.fg1

theme.bg_focus      = theme.fg_normal
theme.bg_urgent     = theme.bg1
theme.bg_minimize   = "#050608"
theme.bg_systray    = theme.bg_normal

theme.fg_focus      = theme.bg_normal
theme.fg_urgent     = "#ff9500"
theme.fg_minimize   = "#CEBCA7"

theme.border_width  = "2"
theme.border_normal = theme.bg2
theme.border_focus  = theme.fg2
theme.border_marked = "#FBDE8E"

theme.bg_widget        = "#333333"
theme.fg_widget        = "#908884"
theme.fg_center_widget = "#636363"
theme.fg_end_widget    = "#ffffff"
theme.fg_off_widget    = "#22211f"

theme.level_fg_good     = "#FFaa00"
theme.level_fg_normal     = "#FF5000"
theme.level_fg_critical     = "#FF1000"

theme.hotkeys_fg     = theme.fg_normal
theme.hotkeys_bg     = theme.bg_normal
theme.hotkeys_modifiers_fg = theme.fg0
theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
theme.description_font = theme.font


-- {{{ Colors
--theme.fg_normal = "#DCDCCC"
--theme.fg_focus  = "#F0DFAF"
--theme.fg_urgent = "#CC9393"
--theme.bg_normal = "#3F3F3F"
--theme.bg_focus  = "#1E2320"
--theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
--theme.border_width  = "2"
--theme.border_normal = "#3F3F3F"
--theme.border_focus  = "#6F6F6F"
--theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.fg_normal
theme.titlebar_bg_normal = theme.border_normal
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- --[taglist|tasklist]_[bg|fg]_[focus|urgent]
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
-- theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "16"
theme.menu_width  = "200"
theme.menu_submenu_icon = "/usr/share/awesome/themes/awezaz/submenu.png"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/usr/share/awesome/themes/awezaz/taglist/squarefz.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/awezaz/taglist/squarez.png"
theme.taglist_squares_resize   = true
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/usr/share/awesome/themes/awezaz/awesome-icon.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/usr/share/awesome/themes/awezaz/layouts/tile.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/awezaz/layouts/tileleft.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/awezaz/layouts/tilebottom.png"
theme.layout_tiletop    = "/usr/share/awesome/themes/awezaz/layouts/tiletop.png"
theme.layout_fairv      = "/usr/share/awesome/themes/awezaz/layouts/fairv.png"
theme.layout_fairh      = "/usr/share/awesome/themes/awezaz/layouts/fairh.png"
theme.layout_spiral     = "/usr/share/awesome/themes/awezaz/layouts/spiral.png"
theme.layout_dwindle    = "/usr/share/awesome/themes/awezaz/layouts/dwindle.png"
theme.layout_max        = "/usr/share/awesome/themes/awezaz/layouts/max.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/awezaz/layouts/fullscreen.png"
theme.layout_magnifier  = "/usr/share/awesome/themes/awezaz/layouts/magnifier.png"
theme.layout_floating   = "/usr/share/awesome/themes/awezaz/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/awezaz/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/awezaz/titlebar/close_normal.png"

theme.titlebar_minimize_button_focus = "/usr/share/awesome/themes/awezaz/titlebar/minimized_focus.png"
-- theme.titlebar_minimize_button_focus_hover = "/usr/share/awesome/themes/awezaz/titlebar/minimized_focus_hover.png"
theme.titlebar_minimize_button_normal = "/usr/share/awesome/themes/awezaz/titlebar/minimized_normal.png"

theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/awezaz/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/awezaz/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/awezaz/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/awezaz/titlebar/maximized_normal_inactive.png"

-- theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/awezaz/titlebar/ontop_focus_active.png"
-- theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/awezaz/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/awezaz/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/awezaz/titlebar/ontop_normal_inactive.png"

-- theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/awezaz/titlebar/sticky_focus_active.png"
-- theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/awezaz/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/awezaz/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/awezaz/titlebar/sticky_normal_inactive.png"

-- theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/awezaz/titlebar/floating_focus_active.png"
-- theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/awezaz/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/awezaz/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/awezaz/titlebar/floating_normal_inactive.png"
-- }}}
-- }}}

return theme
