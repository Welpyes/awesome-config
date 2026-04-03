local awful = require('awful')

local mod    = require('binds.mod')
local modkey = mod.modkey
local altkey = mod.alt

--- Client keybindings.
client.connect_signal('request::default_keybindings', function()
   awful.keyboard.append_client_keybindings({
      -- Ported from sxhkdrc
      awful.key({ modkey, mod.shift }, 'q', function(c) c:kill() end,
         { description = 'close', group = 'client' }),
      
      -- Window States
      awful.key({ altkey,           }, 't', function(c) c.floating = false end,
         { description = 'set tiled', group = 'client' }),
      awful.key({ altkey,           }, 's', function(c) c.floating = true end,
         { description = 'set floating', group = 'client' }),
      awful.key({ altkey,           }, 'f', function(c) 
         c.fullscreen = not c.fullscreen 
         c:raise()
      end, { description = 'toggle fullscreen', group = 'client' }),

      -- Node Flags (alt + ctrl + {m,x,y,z})
      awful.key({ altkey, mod.ctrl  }, 'm', function(c) c.marked = not c.marked end,
         { description = 'toggle marked', group = 'client' }),
      awful.key({ altkey, mod.ctrl  }, 'x', function(c) -- Locked doesn't exist natively, using sticky as proxy or skip
         c.sticky = not c.sticky 
      end, { description = 'toggle sticky/locked', group = 'client' }),
      awful.key({ altkey, mod.ctrl  }, 'y', function(c) c.sticky = not c.sticky end,
         { description = 'toggle sticky', group = 'client' }),
      awful.key({ altkey, mod.ctrl  }, 'z', function(c) c.ontop = not c.ontop end, -- Private proxy
         { description = 'toggle private/ontop', group = 'client' }),

      -- Standard Awesome keys preserved/modified
      awful.key({ modkey,           }, 'n', function(c) c.minimized = true end,
         { description = 'minimize', group = 'client' }),
      awful.key({ modkey,           }, 'm', function(c)
            c.maximized = not c.maximized
            c:raise()
         end, { description = '(un)maximize', group = 'client' }),
   })
end)
