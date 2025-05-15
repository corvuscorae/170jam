local U = {};

function U.inRegion(x, y, region)
    if x < region.min.x or x > region.max.x then return false end
    if y < region.min.y or y > region.max.y then return false end
    return true;
end

function U.toInt(num)
    return num - num % 1;
end

function U.indexOf(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil  
end

-- draw screen regions
function U.drawBG(debugBox)
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", 0, 0, screen.width, screen.height)

    -- car icon (center):
    love.graphics.setColor(colors.icon)
    love.graphics.ellipse("fill", screen.width/2, screen.height/2, screen.width/5, screen.height/6)
    
    -- top row:
    love.graphics.setColor(colors.info)
    love.graphics.rectangle("fill", 0, 0, screen.width, screen.height/5)

    -- instructions
    love.graphics.print("click on a part to repair it", 20, screen.height/5 + 20);
    love.graphics.print("right-click on a part to automate repairs", 20, screen.height/5 + 40);
            

    -- bottom row:
    love.graphics.setColor(colors.info)
    love.graphics.rectangle("fill", 0, screen.height - screen.height/5, screen.width, screen.height/5)

    -- DEBUG BOX:
    if debugBox ~= nil then
        love.graphics.setColor({0.07,0.07,0.07});
        love.graphics.rectangle("fill", debugBox.x, debugBox.y, debugBox.w, debugBox.h)
        love.graphics.setColor(colors.text);
        local i = 1;
        for n,v in pairs(debugBox.info) do
            love.graphics.printf(n .. ": " .. tostring(v), 
                debugBox.x + debugBox.pad, debugBox.y + debugBox.pad * i, debugBox.w - debugBox.pad);
            i = i + 2;
        end
    end
end

-- returns a random key from table
function U.randomFromTable(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end

    local randomKey = keys[math.random(1, #keys)]
    return randomKey
end

return U;