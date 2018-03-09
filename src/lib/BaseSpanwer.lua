newInstance = function(baseCenter, baseOwnerName)
    local spawnUnit = function(blueprintName, armyName, x, y, yawInRadians)
        return CreateUnitHPR(blueprintName, armyName, x, 25.984375, y, 0, yawInRadians or 0, 0)
    end

    local function spawnAround(blueprintName, options)
        local radius = options.distance
        local anglePerElement = 360 / options.numberOfPoints
        local pointFilter = options.pointFilter or function() return true end

        options.numberOfPoints = options.numberOfPoints or 8

        for pointNumber=1, options.numberOfPoints do
            if pointFilter(pointNumber) then
                local angle = math.rad(anglePerElement * pointNumber)

                local unit = spawnUnit(
                    blueprintName,
                    baseOwnerName,
                    baseCenter.x + radius * math.sin(angle),
                    baseCenter.y + radius * math.cos(angle),
                    angle
                )
            end
        end
    end

    local function spawnAroundDiagonally(blueprintName, options)
        spawnAround(
            blueprintName,
            {
                distance = options.distance,
                numberOfPoints = options.numberOfPoints,
                pointFilter = function(pointNumber)
                    return math.mod(pointNumber, 2) == 1
                end
            }
        )
    end

    local function spawnAroundStraight(blueprintName, options)
        spawnAround(
            blueprintName,
            {
                distance = options.distance,
                numberOfPoints = options.numberOfPoints,
                pointFilter = function(pointNumber)
                    return math.mod(pointNumber, 2) == 0
                end
            }
        )
    end

    return {
        spawnCentralStructure = function(blueprintName)
            return spawnUnit(blueprintName, baseOwnerName, baseCenter.x, baseCenter.y)
        end,
        spawnAroundDiagonally = spawnAroundDiagonally,
        spawnAroundStraight = spawnAroundStraight,
        spawnAround = spawnAround
    }
end
