local awful     = require('awful')
local beautiful = require('beautiful')
local wibox     = require('wibox')

screen.connect_signal('request::desktop_decoration', function(s)
   awful.tag(require('config.user').tags, s, awful.layout.layouts[1])
   s.bar = require('ui.wibar')(s)
end)

screen.connect_signal('request::wallpaper', function(s)
   awful.wallpaper({
      screen = s,
      widget = {
         widget = wibox.container.tile,
         valign = 'center',
         halign = 'center',
         tiled  = false,
         {
            widget    = wibox.widget.imagebox,
            image     = beautiful.wallpaper,
            upscale   = true,
            downscale = true
         }
      }
   })
end)
