function newInstance(ScenarioFramework, unitCreator, playerArmies, positions)
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

    local function getParagonPosition(armyBrain)
        local CAN_BE_IDLE = false
        local NEEDS_TO_BE_BUILD = true
        local paragon = armyBrain:GetListOfUnits(categories.xab1401, CAN_BE_IDLE, NEEDS_TO_BE_BUILD)[1]
        return paragon:GetPosition()
    end

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

    local function onParagonBuild(armyName, armyBrain)
        local botArmyName = playerArmies.isTopSideArmy(armyName) and "TOP_BOT" or "BOTTOM_BOT"

        local transports = {spawnTransport(botArmyName)}

        loadParagonIntoTransports(transports, botArmyName)

        IssueMove(transports, positions.mapCenter)
        IssueMove(transports, getParagonPosition(armyBrain))
    end

    local function newOnParagonBuildFunction(armyName)
        return function(armyBrain)
            return onParagonBuild(armyName, armyBrain)
        end
    end

    local function setUp()
        for armyIndex, armyName in playerArmies.getIndexToNameMap() do
            ScenarioFramework.CreateArmyStatTrigger(
                newOnParagonBuildFunction(armyName),
                ArmyBrains[armyIndex],
                "DeliverParagon",
                {{
                    StatType = "Units_Active", -- TODO: Units_History
                    CompareType = 'GreaterThanOrEqual',
                    Value = 1,
                    Category = categories.xab1401
                }}
            )
        end
    end

    return {
        setUp = function()
            ForkThread(function()
                setUp()
            end)
        end
    }
end