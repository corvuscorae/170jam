-- Original code by Professor Graeme Devine!
-- entity.lua
-- Base Entity class for all game objects

local Entity = {}
Entity.__index = Entity

-- Constructor
function Entity:new(name, x, y, w, h)
    local instance = {}
    setmetatable(instance, self)
    
    -- Common properties for all entities
    instance.x = x or 0
    instance.y = y or 0
    instance.width =  w or 32
    instance.height = h or 32
    
    return instance
end

-- Common methods for all entities
function Entity:update(dt)
    -- Base update logic
end

return Entity
