# bspwm Window Management Analysis

This document provides an overview of how `bspwm` (Binary Space Partitioning Window Manager) manages windows based on an analysis of its source code and documentation.

## 1. Core Philosophy

`bspwm` is a tiling window manager that represents windows as the leaves of a full binary tree. Its primary features are:
- **Tree-based Tiling:** Windows are nodes in a full binary tree.
- **Client-Server Architecture:** `bspwm` is the server; `bspc` is the client that sends commands via a Unix socket.
- **Input Neutrality:** It does not handle keyboard or pointer events directly. A third-party program (like `sxhkd`) is required to translate inputs into `bspc` commands.
- **Scriptable Configuration:** Configuration is typically a shell script (`bspwmrc`) that calls `bspc`.

## 2. Data Structures

The core data structures are defined in `src/types.h`:

- **`node_t`**: The fundamental unit of the window tree.
  - Internal nodes have exactly two children (`first_child`, `second_child`).
  - Leaf nodes contain a `client_t` (a window) or are "receptacles" (empty leaves).
  - Each node has a `split_type` (Horizontal or Vertical) and a `split_ratio` (0.0 to 1.0).
- **`client_t`**: Represents an X window with its properties (state, layer, geometry).
- **`desktop_t`**: Holds a pointer to the `root` of a window tree. Each desktop has its own tree.
- **`monitor_t`**: Represents a physical display containing multiple desktops.

## 3. Window Management Lifecycle

### Mapping a New Window
When a new window is created and requests to be mapped (`XCB_MAP_REQUEST`):
1.  **`events.c:handle_event`** catches the request and calls `map_request`.
2.  **`window.c:schedule_window`** is called, which applies rules (e.g., specific desktop, state).
3.  **`window.c:manage_window`** creates a new `node_t` for the window and inserts it into the tree.
4.  **`tree.c:insert_node`** performs the actual tree manipulation:
    - If the desktop is empty, the window becomes the root.
    - If there is an existing tree, the "insertion point" (usually the focused window) is split. A new internal node is created, becoming the parent of both the old window and the new window.
    - **Insertion Modes:**
        - **Automatic:** Split direction is chosen based on schemes like `longest_side`, `alternate`, or `spiral`.
        - **Manual:** Uses user-defined preselection (direction and ratio).

### Unmapping/Destroying a Window
When a window is closed or destroyed:
1.  **`events.c:handle_event`** catches `XCB_UNMAP_NOTIFY` or `XCB_DESTROY_NOTIFY` and calls `unmanage_window`.
2.  **`window.c:unmanage_window`** locates the node and calls `remove_node`.
3.  **`tree.c:remove_node`** calls `unlink_node` and frees the node and its client.
4.  **`tree.c:unlink_node`** collapses the tree: the parent node is removed, and the "brother" of the removed window is promoted to the parent's position, maintaining the full binary tree structure.

## 4. Tiling and Layouts

`bspwm` does not have "layouts" in the traditional sense (like XMonad or dwm). Instead:
- **Tiling is Dynamic:** Every insertion and removal modifies the tree.
- **Node States:** Windows can be `tiled`, `pseudo_tiled`, `floating`, or `fullscreen`.
- **Preselection:** Users can "preselect" a region of a window. The next window inserted at that point will occupy the preselected area.
- **Receptacles:** Empty leaf nodes that can be used to reserve space or build complex layout templates.

## 5. IPC and Messaging

`bspwm` listens on a Unix socket for messages. 
- **Protocol:** Null-terminated strings (arguments) are sent over the socket.
- **`messages.c:handle_message`** parses the incoming byte stream into an argument array.
- **`messages.c:process_message`** dispatches the command to specific handlers (`cmd_node`, `cmd_desktop`, `cmd_monitor`, etc.).
- **Feedback:** Command handlers can write responses back to the socket, which `bspc` then prints.

## 6. Summary

`bspwm` provides a highly flexible and predictable window management system by strictly adhering to a binary tree representation. Its separation of concerns (WM logic in `bspwm`, input handling in `sxhkd`, and control in `bspc`) makes it one of the most modular and scriptable window managers available.
