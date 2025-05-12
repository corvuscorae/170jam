math.randomseed(os.time())

-- car parts health percentage
local car = {
    headlight = {
        autofix = false,
        critical = false,
        exponential = false,
        lifespan = math.floor(math.random(14, 140)) * 1000,
    },
    engine = {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(100, 300)) * 1000,
    },
    battery =  {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(30, 50)) * 1000,
    },
    alternator = {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(80, 150)) * 1000,
    },
    tire =  {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(30, 70)) * 1000,
    },
    brakes =  {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(25, 60)) * 1000,
    },
    gas = {
        autofix = false,
        critical = true,
        exponential = false,
        lifespan = math.floor(math.random(20, 40)) * math.floor(math.random(10, 20)),
    },
    taillight =  {
        autofix = false,
        critical = false,
        exponential = false,
        lifespan = math.floor(math.random(70, 170)) * 1000,
    }
}

return car;