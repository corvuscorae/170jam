local car = require("parts")

local time = 0;
local day = 0;

-- TODO: implement currency system
local savings = 0; -- math.random(50,5000)  -- start with random amount of currency?
local pay = 100;    -- can also randomize amount of currency that is set aside in savings

local miles = 0;
local rate = 0.5;

function love.load()
    print(car.engine.lifespan)
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

end

function love.draw()
    miles = miles + math.random(0,rate);
    -- DEBUG: print(miles);

    handleTime();

    drawBG();
    local col = 0;
    local row = 0;

    for name,part in pairs(car) do
        local health = getHealth(part);

        col = col + 1;
        if col > 4 then 
            row = 1;
            col = 1;
        end
        local x = 180*col;
        local y = 20 + row * (screen.height - screen.height/5);

        love.graphics.setColor(setPartColor(health));
        love.graphics.rectangle("fill", x, y, 100, 100)
        love.graphics.setColor(colors.text);
        love.graphics.print(name, x, y)
        love.graphics.print(health, x, y+20)
    end
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
end

-- TIME HANDLING (pay day)
function handleTime()
    time = time + 0.25
    if time % 24 == 0 then
        day = day + 1;

        if day % 14 == 0 then
            savings = savings + pay;
        end
        -- DEBUG: 
        print(day, miles, savings)
    end
end

-- CALCULATE DECAY
function getDecay(part)
    local decay;
    --[[
    if part.exponential == true then 
            -- DEBUG: print(tostring(i) .. ": EXP")
            -- exponential growth = initial value * (1 + rate) ^ time
            local rate = 1 / part.lifespan;
            decay = (1 + rate)^miles;
            decay = (decay - 1) * 100;
        else
            -- DEBUG: print(tostring(i) .. ": NON-EXP")
            -- TODO: LEFT OFF HERE
            -- implement non-exponential health degradation
            decay = 1 / part.lifespan;
            print("decay: " .. tostring(decay));
    end
    ]]
    decay = 1 / part.lifespan;

    -- DEBUG: 
    return decay;
end

-- UPDATE HEALTH
function getHealth(part)
    local health = 0;
    local decay = getDecay(part);

    if type(part.health) == "table" then
        -- TODO: include some randomization so sub parts dont decay at 
        --      the exact same rate?
        local n = 0;
        for i,atr in pairs(part.health) do
            atr = 100 - decay;
            if atr < 0 then atr = 0 end
            --  DEBUG: print(atr);
            health = health + atr;
            n = n + 1;
        end
        health = health / n;  -- get avg health
    else
        part.health = part.health - decay;
        if part.health < 0 then part.health = 0 end
        -- DEBUG: print(part.health);
        health = part.health;
    end
    
    return health;
end

-- SETS COLOR BASED ON HEALTH
function setPartColor(health)
    if      health == 0 then        return colors.health.dead
    elseif  health < 40 then        return colors.health.low
    elseif  health < 60 then        return colors.health.mid
    else                            return colors.health.high end
end