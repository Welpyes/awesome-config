local awful = require('awful')
local wibox = require('wibox')
local menubar = require('menubar')
local gears = require('gears')

local function get_icon(c)
    local home = os.getenv("HOME")
    local icon_theme_path = home .. "/.local/share/icons/rose-pine-dawn-icons/24x24/apps/"

    local class = (c.class or "unknown"):lower()
    
    -- 1. Specific checks for st, caja, and thunar (Prioritize these)
    if class:find("st") or class:find("terminal") then
        return icon_theme_path .. "terminal.svg"
    end
    
    if class:find("caja") then
        return icon_theme_path .. "system-file-manager.svg"
    end

    if class:find("thunar") then
        return icon_theme_path .. "org.xfce.thunar.svg"
    end

    -- 2. Try to get icon from client property (X11)
    if c.icon then return c.icon end

    -- 3. Try to lookup icon by class name (lowercase)
    local icon_path = menubar.utils.lookup_icon(class)
    if icon_path then return icon_path end

    -- 4. Final fallback
    return icon_theme_path .. "application-x-executable.svg"
end

return function(s)
   -- Create a tasklist widget
   return awful.widget.tasklist({
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      layout  = {
         layout = wibox.layout.fixed.vertical
      },
      -- Use a template to show only the icon
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
         end,
         update_callback = function(self, c, index, objects)
            self:get_children_by_id('icon_role_custom')[1]:set_image(get_icon(c))
         end,
      },
      buttons = {
         -- Left-clicking a client indicator minimizes it if it's unminimized, or unminimizes
         -- it if it's minimized.
         awful.button(nil, 1, function(c)
            c:activate({ context = 'tasklist', action = 'toggle_minimization' })
         end),
         -- Right-clicking a client indicator shows the list of all open clients in all visible 
         -- tags.
         awful.button(nil, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
         -- Mousewheel scrolling cycles through clients.
         awful.button(nil, 4, function() awful.client.focus.byidx(-1) end),
         awful.button(nil, 5, function() awful.client.focus.byidx( 1) end)
      }
   })
end
