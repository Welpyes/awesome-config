local awful = require("awful")
local state = require((...):match("(.-)src%.layout$") .. "src.state")

local layout = {}

function layout.arrange(p)
    local s = screen[p.screen]
    local t = s.selected_tag
    -- If no selected tag or we are arranging a different set of clients, 
    -- try to find the tag from the clients themselves.
    if not t or (#p.clients > 0 and p.clients[1].first_tag ~= t) then
        if #p.clients > 0 then
            t = p.clients[1].first_tag
        end
    end

    if not t then return end

    local bsp_tree = state.get_tree(t)
    local clients = p.clients
    local focused_client = (screen[p.screen] and screen[p.screen].focused_client) or client.focus

    -- 1. Synchronize the tree with the actual client list
    local tree_clients = bsp_tree:get_clients()
    local client_set = {}
    for _, c in ipairs(clients) do
        client_set[c] = true
    end

    -- Remove clients that are no longer present
    for _, c in ipairs(tree_clients) do
        if not client_set[c] then
            bsp_tree:remove(c)
        end
    end

    -- Add new clients
    local tree_client_set = {}
    for _, c in ipairs(bsp_tree:get_clients()) do
        tree_client_set[c] = true
    end

    -- The "focused_client" might be one of the new clients.
    -- We want to find the client that was focused BEFORE these new clients arrived.
    local last_focused = focused_client
    if tree_client_set[last_focused] == nil then
        -- Find the first already-managed client in the history
        for i = 0, 100 do
            local c = awful.client.focus.history.get(s, i)
            if not c then break end
            if tree_client_set[c] then
                last_focused = c
                break
            end
        end
    end

    for _, c in ipairs(clients) do
        if not tree_client_set[c] then
            bsp_tree:insert(c, last_focused)
            -- After inserting, the new client becomes the potential last_focused 
            -- for the next client in the same arrange call
            tree_client_set[c] = true
            last_focused = c
        end
    end

    -- 1.5 Synchronize internal tree slots with the master client list order.
    -- This allows mouse/keyboard swapping to work by reordering p.clients.
    local leaves = bsp_tree:get_leaf_nodes()
    if #leaves == #clients then
        for i = 1, #leaves do
            leaves[i].client = clients[i]
        end
    end

    -- 2. Calculate geometries
    if not bsp_tree.root then return end

    local function calculate(node, area)
        node.geometry = area -- Save for potential "healing" on removal
        if node:is_leaf() then
            if node.client then
                local bw = p.border_width or 0
                local gap = p.useless_gap or 0
                
                p.geometries[node.client] = {
                    x = area.x + gap,
                    y = area.y + gap,
                    width = math.max(1, area.width - gap * 2 - bw * 2),
                    height = math.max(1, area.height - gap * 2 - bw * 2)
                }
            end
            return
        end

        local area1, area2 = {}, {}
        if node.split_type == "vertical" then
            local w1 = math.floor(area.width * node.split_ratio)
            area1 = { x = area.x, y = area.y, width = w1, height = area.height }
            area2 = { x = area.x + w1, y = area.y, width = area.width - w1, height = area.height }
        else
            local h1 = math.floor(area.height * node.split_ratio)
            area1 = { x = area.x, y = area.y, width = area.width, height = h1 }
            area2 = { x = area.x, y = area.y + h1, width = area.width, height = area.height - h1 }
        end

        calculate(node.first_child, area1)
        calculate(node.second_child, area2)
    end

    calculate(bsp_tree.root, p.workarea)
end

return layout
