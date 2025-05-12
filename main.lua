local Entity = require("entity");
local Car = require("car");
local Part = require("part");

local time = 0;
local day = 0;

-- TODO: implement currency system
local savings = 0; -- math.random(50,5000)  -- start with random amount of currency?
local maxSaved = 100;    -- can also randomize amount of currency that is set aside in savings

local dailyMileage = 100;
local totalMiles = 0;

local criticalRepairs = {};

function love.load()
    -- graphics
    screen = {
        width = 1000,
        height = 800
    }
    colors = {
        text = {1,1,1},
        background = {0.3, 0.35, 0.1},
        info = {0.2,0.25,0.05},
        icon = {0.2,0.2,0.2},
        health = {
            high = {0,1,0},
            mid = {0.5,0.5,0},
            low = {1,0,0},
            dead = {0.1,0.1,0.1}
        }
    }
    
    font = love.graphics.newFont(14)
    love.graphics.setFont(font)

    love.window.setMode(screen.width, screen.height) -- wider for split panel

    -- init car parts health + entities
    local col = 0;
    local row = 0;
    for name,part in pairs(Car) do
        part.health = part.lifespan

        col = col + 1;
        if col > 4 then 
            row = 1;
            col = 1;
        end
        local x = 180*col;
        local y = 20 + row * (screen.height - screen.height/5);

        part.entity = Part:new(
            name, part.health, x, y, 100, 100
        )
    end
end

function love.draw()
    drawBG();
    local miles;

    if #criticalRepairs > 0 then 
        -- display system failure text
        love.graphics.setFont(love.graphics.newFont(64));
        love.graphics.setColor(colors.text);
        love.graphics.print("BROKE DOWN :(", 40, screen.height / 2)
        love.graphics.setFont(font);
        miles = 0;
    else
        miles = drive();
    end

    for name,part in pairs(Car) do
            local health = getHealth(part, toInt(miles));
            local healthPercentage = (health / part.lifespan) * 100;
            part.entity:setHealth(health);
            part.entity:setColor(healthPercentage);
            part.entity:draw();

            if part.autofix == true and part.health < 60 then
                fixPart(part, name);
            end

            if part.health == 0 
                and part.critical == true 
                and indexOf(criticalRepairs, name) == nil 
                then 
                    table.insert(criticalRepairs, name);
            end
    end
end

function love.mousepressed(x, y, button)
    print(button)
    for name,part in pairs(Car) do
        if inRegion(x, y, part.entity:getRegion()) then
            -- LEFT-CLICK: RESTORE HEALTH
            if button == 1 then
                fixPart(part);                
            -- RIGHT-CLICK: AUTOMATE/UN-AUTOMATE REPAIRS
            elseif button == 2 then
                if part.autofix == false then part.autofix = true
                else part.autofix = false end
                part.entity.autofix = part.autofix;
            end
        
        end
    end
end

function inRegion(x, y, region)
    if x < region.min.x or x > region.max.x then return false end
    if y < region.min.y or y > region.max.y then return false end
    return true;
end

function toInt(num)
    return num - num % 1;
end

function drawBG()
    love.graphics.setColor(colors.background)
    love.graphics.rectangle("fill", 0, 0, screen.width, screen.height)

    -- car icon (center):
    love.graphics.setColor(colors.icon)
    love.graphics.ellipse("fill", screen.width/2, screen.height/2, screen.width/5, screen.height/6)
    
    -- top row:
    love.graphics.setColor(colors.info)
    love.graphics.rectangle("fill", 0, 0, screen.width, screen.height/5)

    -- bottom row:
    love.graphics.setColor(colors.info)
    love.graphics.rectangle("fill", 0, screen.height - screen.height/5, screen.width, screen.height/5)

    -- DEBUG BOX:
    local debugBox = {
        x = screen.width - 250,
        y = screen.height/5 + 10,
        w = 250,
        h = 300,
        pad = 10;
    }
    love.graphics.setColor({0.07,0.07,0.07});
    love.graphics.rectangle("fill", debugBox.x, debugBox.y, debugBox.w, debugBox.h)
    love.graphics.setColor(colors.text);
    love.graphics.printf("days elapsed: " .. tostring(day), 
        debugBox.x + debugBox.pad, debugBox.y + debugBox.pad, debugBox.w - debugBox.pad);
    love.graphics.printf("miles driven: " .. tostring(totalMiles), 
        debugBox.x + debugBox.pad, debugBox.y + debugBox.pad * 3, debugBox.w - debugBox.pad);
    
end

-- TIME HANDLING (pay day)
function drive()
    local miles = 0;
    time = time + 1
    if time % 24 == 0 then
        day = day + 1;

        if day % 14 == 0 then
            savings = savings + math.random(0,maxSaved);
        end
        miles = miles + math.random(0,dailyMileage);

        -- DEBUG: 
        print(day, miles, savings)
    end
    totalMiles = totalMiles + miles;
    return miles;
end

-- CALCULATE DECAY
function getDecay(part)
    local decay;
    if part.exponential == true then 
            -- DEBUG: print(tostring(i) .. ": EXP")
            -- exponential growth = initial value * (1 + rate) ^ time
            local rate = 1 / part.lifespan;
            decay = (1 + rate)^miles;
            decay = (decay - 1) * 100;
        else
            -- DEBUG: print(tostring(i) .. ": NON-EXP")
            decay = miles * (1 / part.lifespan);
    end

    -- DEBUG: 
    return decay;
end

-- UPDATE HEALTH
function getHealth(part, miles)
    local health = 0;

    part.health = part.health - miles;
    if part.health < 0 then part.health = 0 end
    health = part.health;
    
    return health;
end

function indexOf(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil  
end

function fixPart(part, name)
    -- TEMP: just restoring to original full health for now
    -- TODO: make part health restoration have a cost (currency)

    part.health = part.lifespan;

    local i = indexOf(criticalRepairs, name);
    if i ~= nil then
        table.remove(criticalRepairs, i);
    end
end