local node = {}

---@class Node
---@field parent Node|nil
---@field type "internal"|"leaf"
---@field first_child Node|nil
---@field second_child Node|nil
---@field split_type "vertical"|"horizontal"|nil
---@field split_ratio number|nil
---@field client client|nil

function node.new(args)
    local self = setmetatable({}, { __index = node })
    self.parent = args.parent
    self.type = args.type or "leaf"
    self.client = args.client
    self.first_child = args.first_child
    self.second_child = args.second_child
    self.split_type = args.split_type or "vertical"
    self.split_ratio = args.split_ratio or 0.5
    self.geometry = nil -- Last calculated rectangle
    return self
end

function node:is_leaf()
    return self.type == "leaf"
end

function node:get_sibling()
    if not self.parent then return nil end
    if self.parent.first_child == self then
        return self.parent.second_child
    else
        return self.parent.first_child
    end
end

return node
