local Node = require((...):match("(.-)src%.tree$") .. "src.node")

local tree = {}

function tree.new()
    return setmetatable({
        root = nil
    }, { __index = tree })
end

--- Find the node containing the client
function tree:find_node_by_client(c, current_node)
    current_node = current_node or self.root
    if not current_node then return nil end
    if current_node:is_leaf() then
        return current_node.client == c and current_node or nil
    end
    return self:find_node_by_client(c, current_node.first_child) or
           self:find_node_by_client(c, current_node.second_child)
end

--- Find the "best" node to split for automatic insertion
function tree:find_insertion_point(focused_client)
    if not self.root then return nil end
    
    if focused_client then
        local focused_node = self:find_node_by_client(focused_client)
        if focused_node then return focused_node end
    end

    -- Fallback: Find the first leaf node (usually the root if it's a leaf)
    local current = self.root
    while not current:is_leaf() do
        current = current.first_child
    end
    return current
end

function tree:insert(c, focused_client)
    if not self.root then
        self.root = Node.new({ client = c, type = "leaf" })
        return
    end

    local target = self:find_insertion_point(focused_client)
    if not target then return end

    local parent = target.parent
    
    -- Determine split type based on longest side of the target client
    local split_type = "vertical"
    if target.client and target.client.valid then
        local geo = target.client:geometry()
        if geo.height > geo.width then
            split_type = "horizontal"
        end
    end

    local new_internal = Node.new({
        type = "internal",
        parent = parent,
        split_type = split_type,
        split_ratio = 0.5
    })

    if not parent then
        self.root = new_internal
    elseif parent.first_child == target then
        parent.first_child = new_internal
    else
        parent.second_child = new_internal
    end

    local new_leaf = Node.new({ client = c, type = "leaf", parent = new_internal })
    target.parent = new_internal
    
    new_internal.first_child = target
    new_internal.second_child = new_leaf
end

function tree:remove(c)
    local target = self:find_node_by_client(c)
    if not target then return end

    if not target.parent then
        self.root = nil
        return
    end

    local parent = target.parent
    local sibling = target:get_sibling()
    local grandparent = parent.parent

    -- Healing logic (similar to bspwm)
    if not sibling:is_leaf() and parent.geometry then
        if parent.geometry.width > parent.geometry.height then
            sibling.split_type = "vertical"
        else
            sibling.split_type = "horizontal"
        end
    end

    sibling.parent = grandparent
    if not grandparent then
        self.root = sibling
    elseif grandparent.first_child == parent then
        grandparent.first_child = sibling
    else
        grandparent.second_child = sibling
    end
end

--- Find the ancestor node that acts as a boundary in a given direction
function tree:find_fence(node, direction)
    local current = node
    while current and current.parent do
        local p = current.parent
        if p.split_type == "vertical" then
            if direction == "west" and p.second_child == current then
                return p
            elseif direction == "east" and p.first_child == current then
                return p
            end
        elseif p.split_type == "horizontal" then
            if direction == "north" and p.second_child == current then
                return p
            elseif direction == "south" and p.first_child == current then
                return p
            end
        end
        current = p
    end
    return nil
end

function tree:get_leaf_nodes(current_node, leaves)
    leaves = leaves or {}
    current_node = current_node or self.root
    if not current_node then return leaves end
    if current_node:is_leaf() then
        table.insert(leaves, current_node)
    else
        self:get_leaf_nodes(current_node.first_child, leaves)
        self:get_leaf_nodes(current_node.second_child, leaves)
    end
    return leaves
end

function tree:get_clients(current_node, clients)
    clients = clients or {}
    current_node = current_node or self.root
    if not current_node then return clients end
    if current_node:is_leaf() then
        if current_node.client then
            table.insert(clients, current_node.client)
        end
    else
        self:get_clients(current_node.first_child, clients)
        self:get_clients(current_node.second_child, clients)
    end
    return clients
end

return tree
