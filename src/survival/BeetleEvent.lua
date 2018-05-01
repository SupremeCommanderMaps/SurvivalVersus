function newInstance(unitCreator, spawnEffect)
    local function waitForRetargetting(platoon)
        WaitSeconds(0.1)
        local secondsLocked = 0.1
        local maxSecondsLocked = Random(200, 300) / 100

        while secondsLocked < maxSecondsLocked and platoon:IsAttacking('Attack') do
            WaitSeconds(0.1)
            secondsLocked = secondsLocked + 0.1
        end
    end

    local function attackWithBeetle(beetle)
        WaitSeconds(10)

        local armyBrain = GetArmyBrain(beetle:GetArmy())

        local platoon = armyBrain:MakePlatoon('', '')
        armyBrain:AssignUnitsToPlatoon(platoon, {beetle}, 'Attack', 'None')

        while true do
            local target = platoon:FindClosestUnit('Attack', 'Enemy', true, categories.LAND + categories.STRUCTURE)
            local previousTarget

            if target then
                if target ~= previousTarget then
                    platoon:Stop()
                    platoon:AttackTarget(target, 'Attack')
                end

                previousTarget = target

                waitForRetargetting(platoon)
            else
                WaitSeconds(0.5)
            end
        end
    end

    local function spawnBeetle(positionOffset, armyName)
        local armyBasedOffset = armyName == "ARMY_9" and 2 or -2
        local armyBasedDirection = armyName == "ARMY_9" and 50 or -50
        local spawnX = 255 + armyBasedOffset + positionOffset
        local spawnY = 255 + armyBasedOffset - positionOffset

        local beetle = unitCreator.spawnSurvivalUnit({
            blueprintName = "XRL0302",
            armyName = armyName,
            x = spawnX,
            y = spawnY
        })

        ForkThread(spawnEffect, beetle)

        IssueMove(
            {beetle},
            VECTOR3(
                spawnX + armyBasedDirection,
                25.9844,
                spawnY + armyBasedDirection
            )
        )

        beetle:ForkThread(attackWithBeetle)
    end

    return {
        spawn = function()
            ForkThread(function()
                for positionOffset=-34, 34 do
                    spawnBeetle(positionOffset, "ARMY_9")
                    spawnBeetle(positionOffset, "NEUTRAL_CIVILIAN")
                end
            end)
        end
    }
end