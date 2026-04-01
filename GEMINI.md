# AwesomeWM Modular Configuration Template

This project is a modularized template for Awesome Window Manager (AwesomeWM) configurations. It aims to provide a cleaner, more organized alternative to the default `rc.lua`, avoiding global variables and structuring logic into logical modules.

## Project Overview

- **Core Technology:** Lua (designed for AwesomeWM API level 4).
- **Architecture:** Modularized. Instead of a single monolithic `rc.lua`, the configuration is split into several directories based on functionality.
- **Goal:** Provide a maintainable and readable baseline for custom AwesomeWM setups.
- **IDE Support:** Includes `awesome-code-doc` in the `.lua/` directory for `lua-language-server` annotations, providing better autocompletion and type checking.

## Directory Structure

- `rc.lua`: The main entry point. Handles error initialization and loads core modules.
- `binds/`: Contains key and mouse bindings.
    - `global/`: WM-level bindings (e.g., switching tags, launching terminal).
    - `client/`: Window-level bindings (e.g., closing windows, toggling fullscreen).
- `config/`: User-specific preferences.
    - `apps.lua`: Default applications (terminal, editor).
    - `user.lua`: Layouts, tag names, and modkey definition.
    - `rules.lua`: Window rules (e.g., floating specific apps, assigning apps to tags).
- `signal/`: AwesomeWM signals for event-driven logic.
    - `client.lua`: Client signals (e.g., focus changes, window titles).
    - `screen.lua`: Screen-related signals (e.g., wallpaper, bar initialization).
    - `tag.lua`: Tag-related signals.
- `ui/`: User interface components.
    - `wibar/`: Status bar configuration and widgets.
    - `menu/`: Right-click menu definitions.
    - `notification/`: Naughty notification settings.
    - `titlebar/`: Window titlebar definitions.
- `module/`: Reserved for community-developed modules (e.g., `bling`, `rubato`).
- `.lua/`: Contains `awesome-code-doc` for Lua language server type annotations.

## Building and Running

AwesomeWM is a dynamic window manager; no compilation is needed for the configuration itself.

### Testing Changes
To test your configuration without restarting your current session, use `Xephyr`:
```bash
# Start Xephyr
Xephyr -br -ac -noreset -screen 1024x768 :1 &
sleep 1
# Launch AwesomeWM in Xephyr
DISPLAY=:1 awesome -c ~/.config/awesome/rc.lua
```

### Applying Changes
To apply the configuration to your live session:
1. Ensure the files are in `~/.config/awesome/`.
2. Press `Mod4 + Control + r` (default restart binding) to reload AwesomeWM.

## Development Conventions

- **No Global Variables:** Logic is encapsulated within modules and shared via `require`.
- **Signal-Driven:** Use signals (`connect_signal`) to decouple UI components from core logic.
- **Modular Imports:** Directories with multiple files often use an `init.lua` to export their contents.
- **Dynamic Loading:** The project uses `require(... .. '.submodule')` for relative imports within modules.

## Key Files

- `rc.lua`: The high-level orchestrator.
- `config/user.lua`: Where most users will change their modkey, tags, and preferred layouts.
- `config/apps.lua`: Where default terminal and editor are set.
- `.luarc.json`: Configuration for the Lua language server to use the provided annotations.
