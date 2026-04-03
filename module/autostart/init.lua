local awful = require("awful")
local apps  = require("config.apps")

local autostart = {}

function autostart.run()
    if not apps.autostart then return end
    
    for _, app in ipairs(apps.autostart) do
        awful.spawn.with_shell(app)
    end
end

-- Run it immediately upon require
autostart.run()

return autostart
