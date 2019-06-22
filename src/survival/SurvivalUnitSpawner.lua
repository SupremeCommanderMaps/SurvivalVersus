newInstance = function(unitCreator, playerArmies, getRandomPlayer, extraUnitInfo)
    local spawnForTop = true
    local spawnForBottom = true

    local airSpawnZones = {
        BOTTOM_BOT = {
            minX = 500,
            maxX = 512,
            minY = 0,
            maxY = 10,
        },
        TOP_BOT = {
            minX = 0,
            maxX = 10,
            minY = 500,
            maxY = 512,
        },
    }

    local navySpawnZones = {
        BOTTOM_BOT = {
            minX = 480,
            maxX = 490,
            minY = 20,
            maxY = 30,
        },
        TOP_BOT = {
            minX = 20,
            maxX = 30,
            minY = 480,
            maxY = 490,
        },
    }

    local function isShipName(unitName)
        return string.lower(string.sub(unitName, 3, 3)) == "s"
    end

    local function getFullUnitInfo(unitInfo, armyName)
        if type(unitInfo) == "string" then
            unitInfo = {
                blueprintName = unitInfo
            }
        end

        local airSpawnZone = airSpawnZones[armyName]
        local navySpawnZone = navySpawnZones[armyName]

        local spawnZone = isShipName(unitInfo.blueprintName) and navySpawnZone or airSpawnZone

        unitInfo.armyName = armyName
        unitInfo.x = Random(spawnZone.minX, spawnZone.maxX)
        unitInfo.y = Random(spawnZone.minY, spawnZone.maxY)

        for key, value in extraUnitInfo do
            unitInfo[key] = value
        end

        return unitInfo
    end

    local function spawnUnitsFromName(unitInfos, armyName)
        local units = {}

        for _, unitInfo in unitInfos do
            table.insert(
                units,
                unitCreator.spawnSurvivalUnit(getFullUnitInfo(unitInfo, armyName))
            )
        end

        return units
    end

    local getAcuByArmyName = function(armyName)
        local CAN_BE_IDLE = true
        local acus = GetArmyBrain(armyName):GetListOfUnits(categories.COMMAND, CAN_BE_IDLE)
        return next(acus)
    end

    local function issueAggresiveMoveToAcuLocationByArmyName(units, targetArmyName)
        local acu = getAcuByArmyName(targetArmyName)

        if acu then
            IssueAggressiveMove(units, acu:GetPosition())
        end
    end

    local function sendUnitsInForAttack(units, targetArmyName, owningArmyName)
        IssueMove(units, VECTOR3( Random(235,275), 80, Random(235,275)))

        issueAggresiveMoveToAcuLocationByArmyName(units, targetArmyName)

        local teamIndex = owningArmyName == "BOTTOM_BOT" and 1 or 2
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
    end

    local function spawnUnitsForArmy(unitInfos, armyName)
        local targetArmyName =
            playerArmies.getTargetsForArmy(armyName)
            .filterByName(function(aName)
                return not ArmyIsOutOfGame(aName)
            end)
            .getRandomArmyName()

        if targetArmyName ~= nil then
            ForkThread(
                sendUnitsInForAttack,
                spawnUnitsFromName(unitInfos, armyName),
                targetArmyName,
                armyName
            )
        end
    end

    return {
        -- unitInfos is an array of unitInfo maps. They need to at least contain blueprintName.
        -- For legacy reasons the array elements can also be a string with the blueprintName.
        spawnUnits = function(unitInfos)
            if spawnForTop then
                spawnUnitsForArmy(unitInfos, "TOP_BOT")
            end

            if spawnForBottom then
                spawnUnitsForArmy(unitInfos, "BOTTOM_BOT")
            end
        end,
        stopSpawningForTop = function()
            spawnForTop = false
        end,
        stopSpawningForBottom = function()
            spawnForBottom = false
        end
    }
end

