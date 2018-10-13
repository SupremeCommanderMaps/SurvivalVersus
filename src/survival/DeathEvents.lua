newInstance = function(playerArmies)
    local playerDeathCallbacks = {}
    local teamDeathCallbacks = {}

    local isMonitoring
    local deadArmies = {}
    local topTeamIsAlive = true
    local bottomTeamIsAlive = true

    local function playersAreDead(playerArmyList)
        for armyIndex in playerArmyList.getIndexToNameMap() do
            if not ArmyBrains[armyIndex]:IsDefeated() then
                return false
            end
        end

        return true
    end

    table.insert(
        playerDeathCallbacks,
        function(armyIndex)
            ArmyBrains[armyIndex]:OnDefeat()
        end
    )

    table.insert(
        playerDeathCallbacks,
        function()
            if topTeamIsAlive and playersAreDead(playerArmies.getTopSideArmies()) then
                topTeamIsAlive = false
                LOG("DeathEvents: team death: TOP")

                for _, callback in teamDeathCallbacks do
                    callback("TOP")
                end
            end
            if bottomTeamIsAlive and playersAreDead(playerArmies.getBottomSideArmies()) then
                bottomTeamIsAlive = false
                LOG("DeathEvents: team death: BOTTOM")

                for _, callback in teamDeathCallbacks do
                    callback("BOTTOM")
                end
            end
        end
    )

    local function armyIsDead(armyIndex)
        local CAN_BE_IDLE = true
        local NEEDS_TO_BE_BUILD = true
        return next(ArmyBrains[armyIndex]:GetListOfUnits(categories.COMMAND, CAN_BE_IDLE, NEEDS_TO_BE_BUILD)) == nil
    end

    local function detectNewlyDeadArmies()
        for armyIndex, armyName in playerArmies.getIndexToNameMap() do
            if not deadArmies[armyIndex] and armyIsDead(armyIndex) then
                deadArmies[armyIndex] = true
                LOG("DeathEvents: player death: " .. armyName)

                for _, callback in playerDeathCallbacks do
                    callback(armyIndex)
                end
            end
        end
    end

    return {
        startMonitoring = function()
            isMonitoring = true

            ForkThread(function()
                while isMonitoring do
                    detectNewlyDeadArmies()
                    WaitSeconds(0.1)
                end
            end)
        end,
        stopMonitoring = function()
            isMonitoring = false
        end,
        -- Gets called with armyIndex
        onPlayerDeath = function(callback)
            table.insert(playerDeathCallbacks, callback)
        end,
        -- Gets called with string that is either TOP or BOTTOM
        onTeamDeath = function(callback)
            table.insert(teamDeathCallbacks, callback)
        end,
        topTeamIsAlive = function()
            return topTeamIsAlive
        end,
        bottomTeamIsAlive = function()
            return bottomTeamIsAlive
        end
    }
end