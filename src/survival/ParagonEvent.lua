function newInstance(ScenarioFramework, unitCreator, playerArmies, positions, unitCreation)
    local function spawnTransport(botArmyName)
        local spawnPosition = positions.transports[botArmyName].spawnPosition

        local transport = unitCreator.create({
            armyName = botArmyName,
            blueprintName = "uaa0107",
            baseHealth = 13337,
            x = spawnPosition.x,
            y = spawnPosition.y,
            z = 80,
            isTransport = true
        })

        transport:SetSpeedMult(2)

        return transport
    end

--    local function getParagonPosition(armyBrain)
--        local CAN_BE_IDLE = false
--        local NEEDS_TO_BE_BUILD = true
--        local paragon = armyBrain:GetListOfUnits(categories.xab1401, CAN_BE_IDLE, NEEDS_TO_BE_BUILD)[1]
--        return paragon:GetPosition()
--    end

    local function createParagon(armyName)
        local paragon = unitCreator.create({
            armyName = armyName,
            blueprintName = "xab1401",
            baseHealth = 13337,
            x = 0,
            y = 0
        })

        paragon.CreateWreckage = function() end

        return paragon
    end

    local function loadParagonIntoTransports(transports, armyName)
        ScenarioFramework.AttachUnitsToTransports({createParagon(armyName)}, transports)
    end

    local function onParagonBuild(paragon)
        local botArmyName = playerArmies.isTopSideArmy(paragon:GetArmy()) and "TOP_BOT" or "BOTTOM_BOT"

        local transports = {spawnTransport(botArmyName)}

        loadParagonIntoTransports(transports, botArmyName)

        IssueMove(transports, positions.mapCenter)
        IssueMove(transports, paragon:GetPosition())
    end

    local function isPlayerParagon(unit)
        return EntityCategoryContains(categories.xab1401, unit) and playerArmies.getIndexToNameMap()[unit:GetArmy()]
    end

    local function setUp()
        unitCreation.addCallback(function(unit)
            if isPlayerParagon(unit) then
                onParagonBuild(unit)
            end
        end)
    end

    return {
        setUp = function()
            ForkThread(function()
                setUp()
            end)
        end
    }
end