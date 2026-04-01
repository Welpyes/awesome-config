local Tree = require((...):match("(.-)src%.state$") .. "src.tree")

local state = {}
local tag_trees = setmetatable({}, { __mode = "k" })

function state.get_tree(t)
    if not tag_trees[t] then
        tag_trees[t] = Tree.new()
    end
    return tag_trees[t]
end

function state.set_tree(t, tree)
    tag_trees[t] = tree
end

return state
