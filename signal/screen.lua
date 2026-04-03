local awful     = require('awful')
local beautiful = require('beautiful')
local wibox     = require('wibox')

screen.connect_signal('request::desktop_decoration', function(s)
   s.padding = {
      top    = beautiful.workspace_padding_top    or 0,
      bottom = beautiful.workspace_padding_bottom or 0,
      left   = beautiful.workspace_padding_left   or 0,
      right  = beautiful.workspace_padding_right  or 0,
   }
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
