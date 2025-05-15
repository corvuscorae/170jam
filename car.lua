math.randomseed(os.time())

-- car parts health percentage
local car = {
    headlight = {
        autofix = false,
        critical = false,
        exponential = false,
        lifespan = math.floor(math.random(14, 140)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    engine = {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(100, 300)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    battery =  {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(30, 50)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    alternator = {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(80, 150)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    tire =  {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(30, 70)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    brakes =  {
        autofix = false,
        critical = true,
        exponential = true,
        lifespan = math.floor(math.random(25, 60)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    gas = {
        autofix = false,
        critical = true,
        exponential = false,
        lifespan = math.floor(math.random(20, 40)) * math.floor(math.random(10, 20)),
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    },
    taillight =  {
        autofix = false,
        critical = false,
        exponential = false,
        lifespan = math.floor(math.random(70, 170)) * 1000,
        event = {
            ultra_rare = 0,
            rare = 0.25,
            standard = 0.5
        }
    }
}

return car;