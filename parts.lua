math.randomseed(os.time())

-- car parts health percentage
local car = {
    headlight = {
        exponential = false,
        lifespan = math.floor(math.random(14, 140)) * 1000,
        health = {
            left = 100,
            right = 100
        }
    },
    engine = {
        exponential = true,
        lifespan = math.floor(math.random(100, 300)) * 1000,
        health = 100
    },
    battery =  {
        exponential = true,
        lifespan = math.floor(math.random(30, 50)) * 1000,
        health = 100
    },
    alternator = {
        exponential = true,
        lifespan = math.floor(math.random(80, 150)) * 1000,
        health = 100
    },
    tire =  {
        exponential = true,
        lifespan = math.floor(math.random(30, 70)) * 1000,
        health = {
            frontleft = 100,
            frontright = 100,
            backleft = 100,
            backright = 100,
        }
    },
    brakes =  {
        exponential = true,
        lifespan = math.floor(math.random(25, 60)) * 1000,
        health = {
            front = 100,
            back = 100,
        }
    },
    gas = {
        exponential = false,
        lifespan = math.floor(math.random(20, 40)),
        health = 100
    },
    taillight =  {
        exponential = false,
        lifespan = math.floor(math.random(70, 170)) * 1000,
        health = {
            left = 100,
            right = 100
        }
    }
}

return car;