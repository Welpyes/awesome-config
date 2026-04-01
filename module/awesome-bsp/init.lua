local awful = require("awful")
local layout = require((... .. ".src.layout"))
local state = require((... .. ".src.state"))

local bsp = {
    name = "bsp",
    dragging_client = nil
}

bsp.arrange = function(p)
    return layout.arrange(p, bsp)
end

-- Helper to find a client under mouse coordinates
local function get_client_under_mouse(exclude)
    local m_coords = mouse.coords()
    local s = mouse.screen
    if not s then return nil end
    for _, c in ipairs(s.clients) do
        if c ~= exclude and c:isvisible() and not c.minimized then
            local geo = c:geometry()
            if m_coords.x >= geo.x and m_coords.x <= (geo.x + geo.width) and
               m_coords.y >= geo.y and m_coords.y <= (geo.y + geo.height) then
                return c
            end
        end
    end
    return nil
end

-- Support for interactive move and resize
client.connect_signal("request::geometry", function(c, context, hints)
    if not (c and c.valid and c.first_tag) then return end
    if awful.layout.get(c.screen) ~= bsp then return end

    if context == "mouse_move" then
        bsp.dragging_client = c
        if hints.x then c.x = hints.x end
        if hints.y then c.y = hints.y end
        if hints.width then c.width = hints.width end
        if hints.height then c.height = hints.height end
    elseif context == "mouse_resize" then
        local t = c.first_tag
        local bsp_tree = state.get_tree(t)
        local node = bsp_tree:find_node_by_client(c)
        if not node then return end

        local geo = c:geometry()
        
        -- Horizontal resizing (West/East)
        if hints.width or hints.x then
            local dx = (hints.width or geo.width) - geo.width
            local dx_x = geo.x - (hints.x or geo.x)
            
            -- If x changed, it's a left-edge resize (West)
            if dx_x ~= 0 then
                local fence = bsp_tree:find_fence(node, "west")
                if fence and fence.geometry then
                    fence.split_ratio = math.max(0.05, math.min(0.95, fence.split_ratio - (dx_x / fence.geometry.width)))
                end
            end
            -- If width changed but x didn't, it's a right-edge resize (East)
            if dx ~= 0 and dx_x == 0 then
                local fence = bsp_tree:find_fence(node, "east")
                if fence and fence.geometry then
                    fence.split_ratio = math.max(0.05, math.min(0.95, fence.split_ratio + (dx / fence.geometry.width)))
                end
            end
        end

        -- Vertical resizing (North/South)
        if hints.height or hints.y then
            local dy = (hints.height or geo.height) - geo.height
            local dy_y = geo.y - (hints.y or geo.y)

            -- If y changed, it's a top-edge resize (North)
            if dy_y ~= 0 then
                local fence = bsp_tree:find_fence(node, "north")
                if fence and fence.geometry then
                    fence.split_ratio = math.max(0.05, math.min(0.95, fence.split_ratio - (dy_y / fence.geometry.height)))
                end
            end
            -- If height changed but y didn't, it's a bottom-edge resize (South)
            if dy ~= 0 and dy_y == 0 then
                local fence = bsp_tree:find_fence(node, "south")
                if fence and fence.geometry then
                    fence.split_ratio = math.max(0.05, math.min(0.95, fence.split_ratio + (dy / fence.geometry.height)))
                end
            end
        end
        t:emit_signal("property::layout")
    end
end)

-- Handle the drop (swap when mouse is released after move)
client.connect_signal("button::release", function(c)
    if not (c and c.valid and c.first_tag) then return end
    if awful.layout.get(c.screen) ~= bsp then return end
    
    if bsp.dragging_client == c then
        bsp.dragging_client = nil
        local target = get_client_under_mouse(c)
        if target and target.first_tag == c.first_tag then
            local t = c.first_tag
            local bsp_tree = state.get_tree(t)
            local n1 = bsp_tree:find_node_by_client(c)
            local n2 = bsp_tree:find_node_by_client(target)
            if n1 and n2 then
                n1.client, n2.client = n2.client, n1.client
            end
        end
        c.first_tag:emit_signal("property::layout")
    end
end)

--- Resize the focused node in a given direction by a delta
function bsp.resize(direction, delta, c)
    c = c or client.focus
    if not c or not c.first_tag then return end

    local t = c.first_tag
    local bsp_tree = state.get_tree(t)
    local node = bsp_tree:find_node_by_client(c)
    if not node then return end

    local fence = bsp_tree:find_fence(node, direction)
    if not fence then return end

    -- Adjust the ratio. Some directions need to be inverted because
    -- increasing the ratio moves the fence "right" or "down".
    local actual_delta = delta
    if direction == "west" or direction == "north" then
        actual_delta = -delta
    end

    fence.split_ratio = math.max(0.05, math.min(0.95, fence.split_ratio + actual_delta))
    t:emit_signal("property::layout")
end

--- Rotate the split type of the focused node's parent
function bsp.rotate(c)
    c = c or client.focus
    if not c or not c.first_tag then return end

    local t = c.first_tag
    local bsp_tree = state.get_tree(t)
    local node = bsp_tree:find_node_by_client(c)
    if not node or not node.parent then return end

    local parent = node.parent
    parent.split_type = parent.split_type == "vertical" and "horizontal" or "vertical"
    t:emit_signal("property::layout")
end

--- Swap the focused client with another
function bsp.swap(c1, c2)
    if not c1 or not c2 or c1 == c2 then return end
    if not c1.first_tag or c1.first_tag ~= c2.first_tag then return end

    local t = c1.first_tag
    local bsp_tree = state.get_tree(t)
    local node1 = bsp_tree:find_node_by_client(c1)
    local node2 = bsp_tree:find_node_by_client(c2)

    if node1 and node2 then
        node1.client, node2.client = node2.client, node1.client
        t:emit_signal("property::layout")
    end
end

return bsp
