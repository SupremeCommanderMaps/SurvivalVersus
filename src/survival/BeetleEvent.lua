function newInstance(unitCreator, spawnEffect)
    local function spawnBeetle(positionOffset, armyName)
        local armyBasedOffset = armyName == "ARMY_9" and 2 or -2
        local armyBasedDirection = armyName == "ARMY_9" and 200 or -200
        local spawnX = 255 + armyBasedOffset + positionOffset
        local spawnY = 255 + armyBasedOffset - positionOffset

        local beetle = unitCreator.spawnSurvivalUnit({
            blueprintName = "XRL0302",
            armyName = armyName,
            x = spawnX,
            y = spawnY
        })

        ForkThread(spawnEffect, beetle)

        IssueAggressiveMove(
            {beetle},
            VECTOR3(
                spawnX + armyBasedDirection,
                25.9844,
                spawnY + armyBasedDirection
            )
        )
    end

    return {
        spawn = function()
            for positionOffset=-34, 34 do
                spawnBeetle(positionOffset, "ARMY_9")
                spawnBeetle(positionOffset, "NEUTRAL_CIVILIAN")
            end
        end
    }
end