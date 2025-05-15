-- main.lua (currency system with higher repair cost scaling and full comments)
local Entity = require("entity")
local Car = require("car")
local Part = require("part")
local Util = require("util")

-- Time and day tracking
local time = 0
local day = 0

-- Currency system (renamed to dollars)
local dollars = math.random(150, 200)
local dailyIncome = 10

-- Mileage tracking
local dailyMileage = 100
local totalMiles = math.random(0, 50000)

-- Random event
local eventCooldown = 0;

-- Parts that have critically failed
local criticalRepairs = {}

-- Calculates the repair cost based on part attributes and health lost (scaled up)
function getPartCost(part)
    local base = part.baseRepairCost;  -- increased base cost
    if part.critical then base = base * 3 end  -- increased multiplier
    if part.exponential then base = base * 2 end  -- increased multiplier
    local lostHealth = part.lifespan - part.health
    local costScale = lostHealth / part.lifespan
    return math.floor((base + (part.lifespan / 500)) * costScale)  -- halved divisor increases cost
end

-- Repairs a part if the player can afford it
function fixPart(part, name)
    local cost = getPartCost(part)
    if dollars >= cost then
        dollars = dollars - cost
        part.health = part.lifespan
        local i = Util.indexOf(criticalRepairs, name)
        if i ~= nil then table.remove(criticalRepairs, i) end
    else
        print("!! insufficient funds to repair " .. name .. "; cost: " .. cost)
    end

end

-- Simulates a day of driving, grants passive income
function drive(maxMiles)
    local miles = 0
    time = time + 4 -- CHANGE BACK TO 1
    if time % 24 == 0 then
        day = day + 1

        if #criticalRepairs == 0 then
            miles = miles + math.random(0, maxMiles) 

            -- Random events
            tryEvent();
        end

        -- Give passive income every 7 days
        if day % 7 == 0 then
            local mod =  #criticalRepairs > 0 and 2 or 1
            local payday = ((dailyIncome / mod) * 7) + math.floor(0.1 * miles);     -- make less money when not driving
            dollars = dollars + payday;
        end

    end
    totalMiles = totalMiles + miles
    return miles
end

-- Decrement event cooldown and roll random to try to trigger an event
function tryEvent()
    eventCooldown = eventCooldown - 1;
    if eventCooldown <= 0 then
        local rand = math.random();
        if rand > 0.9 then
            if triggerEvent(rand, totalMiles) then
                eventCooldown = math.random(100,500);
            end
        end
    end
end

-- Triggers a random event with rarity scaling
function triggerEvent(r, mi)
    local eventID;

    -- events are more common over mileage threshold
    if(mi > 50000) then
        if r > 0.999 then       -- ultra rare event
            eventID = "ultra_rare";
        elseif r > 0.99 then    -- rare event
            eventID = "rare";
        else                    -- standard event
            eventID = "standard";
        end
    else
        if r > 0.9999 then     -- rare event
            eventID = "rare";
        elseif r > 0.999 then  -- standard event
            eventID = "standard";
        end
    end

    if eventID then
        -- pick a random part to have event happen to
        local partID = Util.randomFromTable(Car);
        local part = Car[partID];

        -- reduce part health by rate specified in obj
        part.health = part.health * part.event[eventID];

        -- TODO: some kind of visual on screen to communicate random event taking place
        -- TODO: grammars-based random text alerts for events? (stretch goal)

        print(eventID .. " event triggered! " .. mi .. " ".. r .. " " .. partID);
        return true;
    end

    return false;
end

-- Initializes the game window and car part entities
function love.load()
    screen = {width = 1000, height = 800}
    colors = {
        text = {1,1,1}, background = {0.3, 0.35, 0.1},
        info = {0.2,0.25,0.05}, icon = {0.2,0.2,0.2},
        health = {
            high = {0,1,0}, mid = {0.5,0.5,0}, low = {1,0,0}, dead = {0.1,0.1,0.1}
        }
    }
    font = love.graphics.newFont(14)
    love.graphics.setFont(font)
    love.window.setMode(screen.width, screen.height)

    -- Layout part entities on screen
    local col, row = 0, 0
    for name, part in pairs(Car) do
        part.health = part.lifespan
        col = col + 1
        if col > 4 then row, col = 1, 1 end
        local x = 180 * col
        local y = 20 + row * (screen.height - screen.height / 5)
        part.entity = Part:new(name, part.health, x, y, 100, 100)
    end
end

-- Draws the game screen and part statuses
function love.draw()
    local debugBox = {
        x = screen.width - 250,
        y = screen.height / 5 + 10,
        w = 250,
        h = 300,
        pad = 10,
        info = {
            days_elapsed = day,
            total_miles = totalMiles,
            dollars = dollars
        }
    }
    Util.drawBG(debugBox)

    local miles = #criticalRepairs > 0 and drive(0) or drive(dailyMileage)

    -- Display broken message if critical failure
    if #criticalRepairs > 0 then
        love.graphics.setFont(love.graphics.newFont(64))
        love.graphics.setColor(colors.text)
        love.graphics.print("BROKE DOWN :(", 40, screen.height / 2)
        love.graphics.setFont(font)
    end

    -- Update each part's health, draw, and manage autofix
    for name, part in pairs(Car) do
        local health = getHealth(part, Util.toInt(miles))
        local healthPct = (health / part.lifespan) * 100
        part.entity:setHealth(health)
        part.entity:setColor(healthPct)
        part.entity:draw(getPartCost(part));

        if part.autofix and part.health < 60 then
            fixPart(part, name)
        end

        if part.health == 0 and part.critical and not Util.indexOf(criticalRepairs, name) then
            table.insert(criticalRepairs, name)
        end
    end
end

-- Handles player input (left click = repair, right click = toggle autofix)
function love.mousepressed(x, y, button)
    for name, part in pairs(Car) do
        if Util.inRegion(x, y, part.entity:getRegion()) then
            if button == 1 then
                fixPart(part, name)
            elseif button == 2 then
                part.autofix = not part.autofix
                part.entity.autofix = part.autofix
            end
        end
    end
end

-- Calculates part health after mileage decay
function getHealth(part, miles)
    part.health = math.max(0, part.health - miles)
    return part.health
end
