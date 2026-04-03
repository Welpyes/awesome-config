local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local module = require(... .. '.module')

return function(s)
   s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

   -- Create the wibox
   s.mywibox = awful.wibar({
      position = 'left',
      width    = 40,
      screen   = s,
      bg       = beautiful.wibar_bg,
      fg       = beautiful.wibar_fg,
      widget   = {
         layout = wibox.layout.align.vertical,
         -- Top widgets
         {
            layout = wibox.layout.fixed.vertical,
            {
               module.launcher(),
               bg     = beautiful.launcher_bg,
               fg     = beautiful.launcher_fg,
               widget = wibox.container.background,
            },
            s.mypromptbox
         },
         -- Middle widgets
         module.tasklist(s),
         -- Bottom widgets
         {
            layout = wibox.layout.fixed.vertical,
            wibox.widget.systray(),
            {
               {
                  {
                     format = '%H\n%M',
                     font   = beautiful.clock_font,
                     widget = wibox.widget.textclock
                  },
                  margins = 5,
                  widget  = wibox.container.margin,
               },
               bg     = beautiful.clock_bg,
               fg     = beautiful.clock_fg,
               widget = wibox.container.background,
            },
            {
               {
                  module.layoutbox(s),
                  margins = 8,
                  widget  = wibox.container.margin,
               },
               bg     = beautiful.layoutbox_bg,
               fg     = beautiful.layoutbox_fg,
               widget = wibox.container.background,
            }
         }
      }
   })
end
