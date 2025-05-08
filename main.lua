local car = require("parts")

local miles = 0;
local rate = 0.1;

-- local day = 0;      -- track for paydays

function love.load()

end

function love.draw()
    miles = miles + rate;
    -- DEBUG: print(miles);

    -- calculate decay of all car parts
    for i,part in pairs(car) do
        local decay;
        if part.exponential == true then 
            --print(tostring(i) .. ": EXP")
            -- exponential growth = initial value * (1 + rate) ^ time
            local rate = 1 / part.lifespan;
            decay = (1 + rate)^miles;
            decay = (decay - 1) * 100;
        else
            --print(tostring(i) .. ": NON-EXP")
            -- TODO: LEFT OFF HERE
            -- implement non-exponential health degradation
            decay = rate;
        end

        --print("decay: " .. tostring(decay));

        if type(part.health) == "table" then
            -- TODO: include some randomization so sub parts dont decay at 
            --      the exact same rate?
            for i,atr in pairs(part.health) do
                atr = 100 - decay;
                --print(atr);
            end
        else
            part.health = part.health - decay;
            --print(part.health);
        end
    end
end

