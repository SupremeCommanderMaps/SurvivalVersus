newInstance = function(unitCreator, playerArmies, getRandomPlayer, getAllUnits, extraUnitInfo)
    local airSpawnZones = {
        ARMY_9 = {
            minX = 500,
            maxX = 512,
            minY = 0,
            maxY = 10,
        },
        NEUTRAL_CIVILIAN = {
            minX = 0,
            maxX = 10,
            minY = 500,
            maxY = 512,
        },
    }

    local navySpawnZones = {
        ARMY_9 = {
            minX = 480,
            maxX = 490,
            minY = 20,
            maxY = 30,
        },
        NEUTRAL_CIVILIAN = {
            minX = 20,
            maxX = 30,
            minY = 480,
            maxY = 490,
        },
    }

    local function isShipName(unitName)
        return string.lower(string.sub(unitName, 3, 3)) == "s"
    end

    local function getUnitInfo(unitName, armyName)
        local airSpawnZone = airSpawnZones[armyName]
        local navySpawnZone = navySpawnZones[armyName]

        local spawnZone = isShipName(unitName) and navySpawnZone or airSpawnZone

        local unitInfo = {
            blueprintName = unitName,
            armyName = armyName,
            x = Random(spawnZone.minX, spawnZone.maxX),
            y = Random(spawnZone.minY, spawnZone.maxY),
        }

        for key, value in extraUnitInfo do
            unitInfo[key] = value
        end

        return unitInfo
    end

    local function spawnUnitsFromName(unitNames, armyName)
        local units = {}

        for _, unitName in unitNames do
            table.insert(
                units,
                unitCreator.spawnSurvivalUnit(getUnitInfo(unitName, armyName))
            )
        end

        return units
    end

    local getAcuByArmyName = function(armyName)
        local armyIndex = playerArmies.getIndexForName(armyName)

        for _, unit in getAllUnits() do
            if EntityCategoryContains(categories.COMMAND, unit) and unit:GetArmy() == armyIndex then
                return unit
            end
        end

        return false
    end

    local function issueAggresiveMoveToAcuLocationByArmyName(units, targetArmyName)
        local acu = getAcuByArmyName(targetArmyName)

        if acu ~= false then
            IssueAggressiveMove(units, acu:GetPosition())
        end
    end

    local function sendUnitsInForAttack(units, targetArmyName, owningArmyName)
        IssueMove(units, VECTOR3( Random(235,275), 80, Random(235,275)))

        issueAggresiveMoveToAcuLocationByArmyName(units, targetArmyName)

        local teamIndex = owningArmyName == "ARMY_9" and 1 or 2
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
    end

    local function spawnUnitsForArmy(unitNames, armyName)
        local targetArmyName =
            playerArmies.getTargetsForArmy(armyName)
            .filterByName(function(aName)
                return not ArmyIsOutOfGame(aName)
            end)
            .getRandomArmyName()

        if targetArmyName ~= nil then
            ForkThread(
                sendUnitsInForAttack,
                spawnUnitsFromName(unitNames, armyName),
                targetArmyName,
                armyName
            )
        end
    end

    return {
        spawnUnits = function(unitNames)
            spawnUnitsForArmy(unitNames, "NEUTRAL_CIVILIAN")
            spawnUnitsForArmy(unitNames, "ARMY_9")
        end
    }
end

