-- This is used later as the default terminal and editor to run.
local apps = {}
apps.terminal   = 'st'
apps.editor     = os.getenv('EDITOR') or 'vi'
apps.editor_cmd = apps.terminal .. ' -e ' .. apps.editor

apps.autostart = {
   'dunst',
   "fastcompmgr -c -r 1 -o 1 -l 5 -t 5 --shadow-color '#8a8a96'"
}

-- Set the terminal for the menubar.
require('menubar').utils.terminal = apps.terminal

return apps
