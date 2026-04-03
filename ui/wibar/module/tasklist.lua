local awful = require('awful')
local wibox = require('wibox')
local menubar = require('menubar')
local gears = require('gears')
local beautiful = require('beautiful')

local function get_icon(c)
    local home = os.getenv("HOME")
    local icon_theme_path = home .. "/.local/share/icons/rose-pine-dawn-icons/24x24/apps/"

    local class = (c.class or "unknown"):lower()
    
    if class:find("st") or class:find("terminal") then
        return icon_theme_path .. "terminal.svg"
    end
    
    if class:find("caja") then
        return icon_theme_path .. "system-file-manager.svg"
    end

    if class:find("thunar") then
        return icon_theme_path .. "org.xfce.thunar.svg"
    end

    if c.icon then return c.icon end

    local icon_path = menubar.utils.lookup_icon(class)
    if icon_path then return icon_path end

    return icon_theme_path .. "application-x-executable.svg"
end

return function(s)
   return awful.widget.tasklist({
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      layout  = {
         layout = wibox.layout.fixed.vertical
      },
      widget_template = {
         {
            {
               id     = 'icon_role_custom',
               widget = wibox.widget.imagebox,
            },
            margins = 6,
            widget  = wibox.container.margin,
         },
         id     = 'background_role',
         widget = wibox.container.background,
         create_callback = function(self, c, index, objects)
            self:get_children_by_id('icon_role_custom')[1]:set_image(get_icon(c))
            if c.active then
                self.bg = beautiful.tasklist_bg_focus
                self.fg = beautiful.tasklist_fg_focus
            else
                self.bg = beautiful.tasklist_bg_normal
                self.fg = beautiful.tasklist_fg_normal
            end
         end,
         update_callback = function(self, c, index, objects)
            self:get_children_by_id('icon_role_custom')[1]:set_image(get_icon(c))
            if c.active then
                self.bg = beautiful.tasklist_bg_focus
                self.fg = beautiful.tasklist_fg_focus
            else
                self.bg = beautiful.tasklist_bg_normal
                self.fg = beautiful.tasklist_fg_normal
            end
         end,
      },
      buttons = {
         awful.button(nil, 1, function(c)
            c:activate({ context = 'tasklist', action = 'toggle_minimization' })
         end),
         awful.button(nil, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
         awful.button(nil, 4, function() awful.client.focus.byidx(-1) end),
         awful.button(nil, 5, function() awful.client.focus.byidx( 1) end)
      }
   })
end
