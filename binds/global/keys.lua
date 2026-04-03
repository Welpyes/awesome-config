local awful = require('awful')

local mod    = require('binds.mod')
local modkey = mod.modkey
local altkey = mod.alt

local apps   = require('config.apps')
local bsp    = require('module.awesome-bsp')

--- Global key bindings
awful.keyboard.append_global_keybindings({
   -- Applications (ported from sxhkdrc)
   awful.key({ altkey, mod.shift }, 'c', function() awful.spawn.with_shell("eww open --toggle simple-calendar") end,
      { description = 'calendar', group = 'launcher' }),
   awful.key({ altkey, mod.shift }, 'n', function() awful.spawn.with_shell("eww open --toggle notification-center") end,
      { description = 'notification center', group = 'launcher' }),
   awful.key({ altkey,           }, 'Return', function() awful.spawn(apps.terminal) end,
      { description = 'open a terminal', group = 'launcher' }),
   awful.key({ altkey,           }, 'x', awesome.restart,
      { description = 'reload awesome', group = 'awesome' }),
   awful.key({ altkey, mod.shift }, 'p', function() awful.spawn.with_shell("pkill -USR1 -x picom") end,
      { description = 'reload picom', group = 'awesome' }),
   awful.key({ altkey,           }, 'e', function() awful.spawn(apps.terminal .. " -e yazi") end,
      { description = 'terminal file manager', group = 'launcher' }),
   awful.key({ altkey, mod.shift }, 'e', function() awful.spawn("caja") end,
      { description = 'gui file manager', group = 'launcher' }),
   awful.key({ altkey,           }, 'space', function() awful.spawn.with_shell("rofi -show drun -theme ~/.config/rofi/dmenu.rasi") end,
      { description = 'app launcher', group = 'launcher' }),
   awful.key({ altkey,           }, 'Tab', function() awful.spawn.with_shell("rofi -show window -theme ~/.config/rofi/dmenu.rasi") end,
      { description = 'window switcher', group = 'launcher' }),
   awful.key({ altkey,           }, 'r', function() awful.spawn.with_shell("rofi -show run -theme ~/.config/rofi/dmenu.rasi") end,
      { description = 'rofi run', group = 'launcher' }),
   awful.key({ altkey, mod.shift }, 's', function() awful.spawn.with_shell("scrot -Z 2 -d 1 -f '%Y-%m-%d_%H-%M-%S_scrot.png' -e 'mv $f ~/Pictures/Screenshots/'") end,
      { description = 'screenshot', group = 'launcher' }),

   -- WM Control
   awful.key({ altkey, mod.shift }, 'q', awesome.quit,
      { description = 'quit awesome', group = 'awesome' }),
   awful.key({ altkey, mod.shift }, 'r', awesome.restart,
      { description = 'reload awesome', group = 'awesome' }),
   awful.key({ altkey, mod.shift }, 'm', function() awful.layout.inc(1) end,
      { description = 'next layout', group = 'layout' }),

   -- Tag Navigation (alt + brackets)
   awful.key({ altkey,           }, '[', awful.tag.viewprev,
      { description = 'view previous tag', group = 'tag' }),
   awful.key({ altkey,           }, ']', awful.tag.viewnext,
      { description = 'view next tag', group = 'tag' }),

   -- Focus History (super + o/i)
   awful.key({ modkey,           }, 'o', function()
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
   end, { description = 'focus older', group = 'client' }),
   awful.key({ modkey,           }, 'i', function()
      -- Awesome doesn't have a "newer" focus history natively like bspwm,
      -- but we can use the default focus behavior as a proxy or just keep 'o'.
   end, { description = 'focus newer', group = 'client' }),

   -- Focus/Swap (Directional)
   awful.key({ altkey,           }, 'h', function() bsp.focus_direction("west") end,
      { description = 'focus west', group = 'client' }),
   awful.key({ altkey,           }, 'j', function() bsp.focus_direction("south") end,
      { description = 'focus south', group = 'client' }),
   awful.key({ altkey,           }, 'k', function() bsp.focus_direction("north") end,
      { description = 'focus north', group = 'client' }),
   awful.key({ altkey,           }, 'l', function() bsp.focus_direction("east") end,
      { description = 'focus east', group = 'client' }),

   awful.key({ altkey, mod.shift }, 'h', function() bsp.swap_direction("west") end,
      { description = 'swap west', group = 'client' }),
   awful.key({ altkey, mod.shift }, 'j', function() bsp.swap_direction("south") end,
      { description = 'swap south', group = 'client' }),
   awful.key({ altkey, mod.shift }, 'k', function() bsp.swap_direction("north") end,
      { description = 'swap north', group = 'client' }),
   awful.key({ altkey, mod.shift }, 'l', function() bsp.swap_direction("east") end,
      { description = 'swap east', group = 'client' }),

   -- Tag related (Super + 1-9)
   awful.key({
      modifiers   = { modkey },
      keygroup    = 'numrow',
      description = 'only view tag',
      group       = 'tag',
      on_press    = function(index)
         local tag = awful.screen.focused().tags[index]
         if tag then tag:view_only() end
      end
   }),
   awful.key({
      modifiers   = { modkey, mod.shift },
      keygroup    = 'numrow',
      description = 'move focused client to tag',
      group       = 'tag',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:move_to_tag(tag) end
         end
      end
   }),

   -- Resize (BSP style from sxhkdrc)
   -- Expand outward
   awful.key({ mod.ctrl,           }, 'h', function() bsp.resize('west',  0.05) end,
      { description = 'resize west outward', group = 'layout' }),
   awful.key({ mod.ctrl,           }, 'j', function() bsp.resize('south', 0.05) end,
      { description = 'resize south outward', group = 'layout' }),
   awful.key({ mod.ctrl,           }, 'k', function() bsp.resize('north', 0.05) end,
      { description = 'resize north outward', group = 'layout' }),
   awful.key({ mod.ctrl,           }, 'l', function() bsp.resize('east',  0.05) end,
      { description = 'resize east outward', group = 'layout' }),

   -- Contract inward
   awful.key({ mod.ctrl, altkey    }, 'h', function() bsp.resize('east',  -0.05) end,
      { description = 'resize east inward', group = 'layout' }),
   awful.key({ mod.ctrl, altkey    }, 'j', function() bsp.resize('north', -0.05) end,
      { description = 'resize north inward', group = 'layout' }),
   awful.key({ mod.ctrl, altkey    }, 'k', function() bsp.resize('south', -0.05) end,
      { description = 'resize south inward', group = 'layout' }),
   awful.key({ mod.ctrl, altkey    }, 'l', function() bsp.resize('west',  -0.05) end,
      { description = 'resize west inward', group = 'layout' }),

   -- BSP Rotate
   awful.key({ altkey, mod.ctrl    }, 'r', function() bsp.rotate() end,
      { description = 'rotate bsp split', group = 'layout' }),
   
   -- Standard Awesome keys preserved
   awful.key({ modkey,           }, 's', require('awful.hotkeys_popup').show_help,
      { description = 'show help', group = 'awesome' })
})
