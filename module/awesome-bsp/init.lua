local layout = require((... .. ".src.layout"))
local state = require((... .. ".src.state"))

local bsp = {
    name = "bsp",
    arrange = layout.arrange
}

--- Resize the focused node by a delta
function bsp.resize(delta, c)
    c = c or client.focus
    if not c or not c.first_tag then return end

    local t = c.first_tag
    local bsp_tree = state.get_tree(t)
    local node = bsp_tree:find_node_by_client(c)
    if not node or not node.parent then return end

    local parent = node.parent
    parent.split_ratio = math.max(0.1, math.min(0.9, parent.split_ratio + delta))
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
