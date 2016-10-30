newInstance = function(ScenarioInfo, textPrinter, allUnits, ListArmies, survivalSpawnerFactory)

    local function spawnT3Arty(initialDelayInSeconds)
        textPrinter.print("T3 Mobile Artillery Detected");

        survivalSpawnerFactory.newTransportSpawner(initialDelayInSeconds).spawnWithTransports(
            {
                "url0304", --Cybran T3 Mobile Heavy Artillery: Trebuchet
                "url0304",
                "url0304",
                "url0304",
                "uel0304", --UEF T3 Mobile Heavy Artillery: Demolisher
                "uel0304",
                "uel0304",
                "uel0304",
            },
            "xea0306"
        )
    end

    local function spawnYthotha(initialDelayInSeconds)
        textPrinter.print("Ythothas Detected");

        survivalSpawnerFactory.newTransportSpawner(initialDelayInSeconds).spawnWithTransports(
            {
                "xsl0401",
            },
            "xea0306"
        )
    end

    local function spawnBombers(initialDelayInSeconds)
        textPrinter.print("T1 Bombers Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
            }
        )
    end

    local function spawnT1Gunships(initialDelayInSeconds)
        textPrinter.print("T1 Gunships Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "xra0105",
                "xra0105",
                "xra0105",
                "xra0105",
                "xra0105",
                "xra0105",
                "xra0105",
                "xra0105",
            }
        )
    end

    local function spawnT2Bombers(initialDelayInSeconds)
        textPrinter.print("T2 Bombers Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
            }
        )
    end

    local function spawnT3Bombers(initialDelayInSeconds)
        textPrinter.print("T3 Bombers Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "uea0304",
                "uea0304",
                "uea0304",
                "uea0304",
                "uea0304",
                "uea0304",
                "uea0304",
                "uea0304",
            }
        )
    end

    local SpawnT3Gunships = function(initialDelayInSeconds)
        textPrinter.print("T3 Gunships Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
            }
        )
    end

    local SpawnT2Destroyers = function(initialDelayInSeconds)
        textPrinter.print("Destroyers Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
            }
        )
    end

    --given an army index returns an army
    local indexToArmy = function(armyIndex)
        local army = ListArmies()[armyIndex]
        return army
    end

    --given a unit returns the army
    local scnArmy = function(unit)
        local armyIndex = unit:GetArmy()
        return indexToArmy(armyIndex)
    end

    local SpeedCurrentUnits = function()
        textPrinter.print("Current Unit Speed Boosted");

        local units = allUnits()
        for _, unit in units do
            if EntityCategoryContains(categories.LAND + categories.NAVAL, unit) and scnArmy(unit) ==  "ARMY_9" or scnArmy(unit) == "NEUTRAL_CIVILIAN" then
                unit:SetSpeedMult(2)
            end
        end
    end

    local randomEventsThread = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        while true do
            --T2 Section
            if GetGameTimeSeconds() - t2spawndelay > 0 then
                local RandomEvent = Random(1,3)
                if RandomEvent == 1 then
                    ForkThread(spawnBombers,t2spawndelay)
                elseif RandomEvent == 2 then
                    ForkThread(spawnT1Gunships, t3spawndelay)
                elseif RandomEvent == 3 then
                    ForkThread(SpeedCurrentUnits)
                end
            end

            --T3 Section
            if GetGameTimeSeconds() - t3spawndelay > 0 then
                local RandomEvent = Random(1,4)
                if RandomEvent == 1 then
                    if (ScenarioInfo.Options.opt_t3arty == 0) then
                        ForkThread(spawnT3Arty, t3spawndelay)
                    else
                        ForkThread(spawnT3Bombers, t4spawndelay)
                    end
                elseif RandomEvent == 2 then
                    ForkThread(spawnT2Bombers, t3spawndelay)
                elseif RandomEvent == 3 then
                    ForkThread(SpawnT3Gunships, t3spawndelay)
                elseif RandomEvent == 4 then
                    ForkThread(SpawnT2Destroyers, t3spawndelay)
                end
            end

            --T4 Section
            if GetGameTimeSeconds() - t4spawndelay > 0 then
                local RandomEvent = Random(1,2)
                if RandomEvent == 1 then
                    ForkThread(spawnYthotha, t4spawndelay)
                elseif RandomEvent == 2 then
                    ForkThread(spawnT3Bombers, t4spawndelay)
                end
            end

            WaitSeconds(RandomFrequency)
        end
    end

    return {
        start = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
            ForkThread(randomEventsThread, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        end
    }
end