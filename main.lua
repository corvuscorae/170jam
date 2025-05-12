local car = require("parts")

local time = 0;
local day = 0;

-- TODO: implement currency system
local savings = 0; -- math.random(50,5000)  -- start with random amount of currency?
local pay = 100;    -- can also randomize amount of currency that is set aside in savings

local miles = 0;
local rate = 0.5;

function love.load()
end

function love.draw()
    miles = miles + math.random(0,rate);
    -- DEBUG: print(miles);

    time = time + 0.25
    if time % 24 == 0 then
        day = day + 1;

        if day % 14 == 0 then
            savings = savings + pay;
        end
        -- DEBUG: 
        print(day, miles, savings)

    end

    -- calculate decay of all car parts
    for i,part in pairs(car) do
        local decay;
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
        end

        -- DEBUG: print("decay: " .. tostring(decay));

        if type(part.health) == "table" then
            -- TODO: include some randomization so sub parts dont decay at 
            --      the exact same rate?
            for i,atr in pairs(part.health) do
                atr = 100 - decay;
                --  DEBUG: print(atr);
            end
        else
            part.health = part.health - decay;
            -- DEBUG: print(part.health);
        end
    end
end

function toInt(num)
    return num - num % 1;
end