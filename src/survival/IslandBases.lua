newInstance = function()
    local spawnerClass = import('/maps/survival_versus.v0024/vendor/EntropyLib/src/BaseSpanwer.lua')
    local unitModifier = import('/maps/survival_versus.v0024/vendor/EntropyLib/src/CapturableUnitModifier.lua').newInstance()

    local function spawnCentralMex(baseSpawner)
        local mex = baseSpawner.spawnCentralStructure("uab1302") -- T3 mex

        unitModifier.modify(
            mex,
            function(unit)
                unit:SetMaxHealth(13337)
                unit:SetProductionPerSecondMass(36)
                unit:SetCustomName("Capture for 36 mass/s")
            end
        )

        mex:SetHealth(mex, 9001)
    end

    local function spawnBase(baseSpawner)
        spawnCentralMex(baseSpawner)

        baseSpawner.spawnAroundStraight("uab2101", {distance = 8, numberOfPoints = 8}) -- T1 PD
        baseSpawner.spawnAroundDiagonally("uab2304", {distance = 8, numberOfPoints = 8}) -- T3 AA
    end

    return {
        spawn = function()
            spawnBase(spawnerClass.newInstance(
                {
                    x = 360,
                    y = 153
                },
                "TOP_BOT"
            ))
            spawnBase(spawnerClass.newInstance(
                {
                    x = 154,
                    y = 359
                },
                "BOTTOM_BOT"
            ))
        end
    }
end