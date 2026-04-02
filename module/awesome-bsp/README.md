# awesome-bsp

A modular, bspwm-style binary tree tiling layout for AwesomeWM.

This module brings the predictable and highly scriptable tiling behavior of `bspwm` (Binary Space Partitioning Window Manager) to AwesomeWM, allowing you to manage windows as leaf nodes in a binary tree.

## Features

- **Binary Tree Tiling**: Windows are leaf nodes in a full binary tree. Every split is either horizontal or vertical.
- **Automatic Insertion**: New windows automatically split the currently focused window or follow a "longest-side" policy to maintain a balanced layout.
- **Healing on Removal**: When a window is closed, the tree "collapses" and adjusts the remaining split to maintain an optimal layout (similar to bspwm's `removal_adjustment`).
- **Interactive Mouse Swapping**: Drag and drop windows to swap their positions in the tree.
- **Directional Resizing**: Resize any window boundary (North, South, East, West) using either the mouse or keyboard shortcuts.
- **Enlarge/Shrink**: Quickly grow or shrink a window by moving all its boundaries simultaneously.
- **Tree Rotation**: Rotate the split type of a node's parent (Vertical ↔ Horizontal).

## Installation

1. Clone or copy this directory into your AwesomeWM configuration folder:
   ```bash
   cp -r awesome-bsp ~/.config/awesome/module/
   ```

2. Add the layout to your `rc.lua` or `user.lua` configuration:
   ```lua
   local bsp = require("module.awesome-bsp")

   awful.layout.layouts = {
       bsp,
       -- ... other layouts
   }
   ```

## Usage

### Keybindings

The following keybindings are recommended for a full bspwm-like experience (assuming `modkey` is Super and `alt` is Alt):

| Binding | Action |
| :--- | :--- |
| `Mod + Alt + r` | Rotate split type of focused node |
| `Mod + Alt + h` | Resize boundary to the West |
| `Mod + Alt + j` | Resize boundary to the South |
| `Mod + Alt + k` | Resize boundary to the North |
| `Mod + Alt + l` | Resize boundary to the East |
| `Mod + Alt + i` | Enlarge window (all boundaries outward) |
| `Mod + Alt + o` | Shrink window (all boundaries inward) |

### Mouse Interactions

- **Drag and Drop**: Grab a window by its titlebar (or `Mod + Left Click`) and drop it onto another window to swap their positions.
- **Resizing**: Resizing is currently best handled via keyboard or by the layout's internal `split_ratio` logic.

## API

The module exports several functions for manual control:

- `bsp.rotate(c)`: Rotates the split type of the client's parent node.
- `bsp.resize(direction, delta, c)`: Resizes the boundary in the given direction (`"north"`, `"south"`, `"east"`, `"west"`).
- `bsp.enlarge(delta, c)`: Moves all boundaries of the client outward.
- `bsp.shrink(delta, c)`: Moves all boundaries of the client inward.
- `bsp.swap(c1, c2)`: Swaps the positions of two clients in the tree.

## Configuration

The layout defaults to an automatic insertion policy where new windows split the currently focused window based on the longest side of its current geometry.

## License

MIT
