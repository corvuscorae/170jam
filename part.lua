-- part entity derived from base Entity

local Entity = require("entity")

local Part = {}
Part.__index = Part
setmetatable(Part, {__index = Entity})

function Part:new(name, health, x, y, w, h)
    local instance = Entity:new(name, x, y, w, h)
    setmetatable(instance, Part)
    
    instance.name = name;
    instance.health = health;
    instance.color = self:getColor(health)
    instance.speed = 0;
    instance.autofix = false;
    
    return instance
end

-- SETS COLOR BASED ON HEALTH
function Part:setColor(health)
    self.color = self:getColor(health);
end

function Part:getColor(health)
    if      health == 0 then        return colors.health.dead
    elseif  health < 40 then        return colors.health.low
    elseif  health < 60 then        return colors.health.mid
    else                            return colors.health.high end
end

function Part:onCollision(other)
    -- Player-specific collision behavior
    -- if other.type == "player" then
    -- end
end

function Part:setHealth(amt)
    self.health = amt;
end

function Part:getRegion()
    return {
        min = {
            x = self.x,
            y = self.y
        },
        max = {
            x = self.x + self.width,
            y = self.y + self.height
        }
    }
end

function Part:draw(cost)
    -- Set color and draw rectangle
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, 
                            self.width, self.height)
    
    -- Draw entity type
    love.graphics.setColor(colors.text)
    love.graphics.print(self.name, self.x, self.y);

    -- Debug text
    -- *health
    love.graphics.print(self.health, self.x, self.y + 20);

    -- *repair cost (passed in as param for now)
    love.graphics.print("$" .. tostring(cost), self.x, self.y + 50);

    -- *autofix toggle
    if self.autofix == true then
        love.graphics.print("auto fix", self.x, self.y + self.height - 20);
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

return Part