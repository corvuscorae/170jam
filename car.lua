math.randomseed(os.time())

-- car parts health percentage
local car = {
    headlight = {
        exponential = false,
        lifespan = math.floor(math.random(14, 140)) * 1000,
    },
    engine = {
        exponential = true,
        lifespan = math.floor(math.random(100, 300)) * 1000,
    },
    battery =  {
        exponential = true,
        lifespan = math.floor(math.random(30, 50)) * 1000,
    },
    alternator = {
        exponential = true,
        lifespan = math.floor(math.random(80, 150)) * 1000,
    },
    tire =  {
        exponential = true,
        lifespan = math.floor(math.random(30, 70)) * 1000,
    },
    brakes =  {
        exponential = true,
        lifespan = math.floor(math.random(25, 60)) * 1000,
    },
    gas = {
        exponential = false,
        lifespan = math.floor(math.random(20, 40)) * math.floor(math.random(10, 20)),
    },
    taillight =  {
        exponential = false,
        lifespan = math.floor(math.random(70, 170)) * 1000,
    }
}

return car;