local awful = require('awful')
local wibox = require('wibox')

local module = require(... .. '.module')

return function(s)
   s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

   -- Create the wibox
   s.mywibox = awful.wibar({
      position = 'left',
      width    = 40,
      screen   = s,
      widget   = {
         layout = wibox.layout.align.vertical,
         -- Top widgets (was Left)
         {
            layout = wibox.layout.fixed.vertical,
            module.launcher(),
            -- module.taglist(s),
            s.mypromptbox
         },
         -- Middle widgets
         module.tasklist(s),
         -- Bottom widgets (was Right)
         {
            layout = wibox.layout.fixed.vertical,
            wibox.widget.systray(),
            wibox.widget.textclock('%H\n%M'), -- Vertical clock
            module.layoutbox(s)
         }
      }
   })
end
