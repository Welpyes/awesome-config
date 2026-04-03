-- awesome_mode: api-level=4:screen=on
pcall(require, 'luarocks.loader')
package.loaded["naughty"] = {
  notify = function() end,
  connect_signal = function() end,
  config = {},
  notification_closed_reason = {},
}

require('awful.autofocus')
require('awful.hotkeys_popup.keys')
require('theme')
require('signal')
require('binds')
require('config.rules')
require('module.autostart')
