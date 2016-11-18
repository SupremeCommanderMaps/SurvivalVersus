newInstance = function(ScenarioInfo, textPrinter, getAllUnits, ListArmies, survivalSpawnerFactory)

    local function spawnBombers(initialDelayInSeconds)
        textPrinter.print("T1 Bombers Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
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

    local SpawnT2Gunships = function(initialDelayInSeconds)
        textPrinter.print("T2 Gunships Detected");

        survivalSpawnerFactory.newUnitSpawner(initialDelayInSeconds).spawnUnits(
            {
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
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
        textPrinter.print("Ythotha Detected");

        survivalSpawnerFactory.newTransportSpawner(initialDelayInSeconds).spawnWithTransports(
            {
                "xsl0401",
            },
            "xea0306"
        )
    end

    local function spawnFatboy(initialDelayInSeconds)
        textPrinter.print("Fatboy Detected");

        survivalSpawnerFactory.newTransportSpawner(initialDelayInSeconds).spawnWithTransports(
            {
                "uel0401",
            },
            "xea0306"
        )
    end

    local isSurvivalUnit = function(unit)
        local armyName = ListArmies()[unit:GetArmy()]
        return armyName == "ARMY_9" or armyName == "NEUTRAL_CIVILIAN"
    end

    local SpeedCurrentUnits = function()
        textPrinter.print("Current Unit Speed Boosted");

        for _, unit in getAllUnits() do
            if EntityCategoryContains(categories.LAND + categories.NAVAL, unit) and isSurvivalUnit(unit) then
                unit:SetSpeedMult(2)
            end
        end
    end

    local function getPossibleEvents(elapsedTimeInSeconds, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        local possibleEvents = {}

        if elapsedTimeInSeconds >= t1spawndelay and elapsedTimeInSeconds < t2spawndelay then
            table.insert(possibleEvents, {spawnBombers, t2spawndelay})
            table.insert(possibleEvents, {spawnT1Gunships, t2spawndelay})
        end

        if elapsedTimeInSeconds >= t2spawndelay and elapsedTimeInSeconds < t3spawndelay then
            table.insert(possibleEvents, {spawnT2Bombers, t3spawndelay})
            table.insert(possibleEvents, {SpawnT2Gunships, t3spawndelay})
        end

        if elapsedTimeInSeconds >= t3spawndelay then
            table.insert(possibleEvents, {SpawnT2Destroyers, t3spawndelay})
            table.insert(possibleEvents, {spawnT3Bombers, t3spawndelay})
            table.insert(possibleEvents, {SpawnT3Gunships, t3spawndelay})

            if (ScenarioInfo.Options.opt_t3arty == 0) then
                table.insert(possibleEvents, {spawnT3Arty, t3spawndelay})
            end
        end

        if elapsedTimeInSeconds >= t4spawndelay then
            table.insert(possibleEvents, {spawnYthotha, t4spawndelay})

            if Random(1, 2) == 1 then
                table.insert(possibleEvents, {spawnFatboy, t4spawndelay})
            end
        end

        return possibleEvents
    end

    local function runEvent(eventCallable)
        if eventCallable ~= nil then
            ForkThread(eventCallable[1], eventCallable[2])
        end
    end

    local function runRandomEvents(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        local elapsedTimeInSeconds = GetGameTimeSeconds()

        local possibleEvents = getPossibleEvents(elapsedTimeInSeconds, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)

        runEvent(possibleEvents[Random(1, table.getn(possibleEvents))])

        if elapsedTimeInSeconds >= t4spawndelay then
            runEvent(possibleEvents[Random(1, table.getn(possibleEvents))])
        end

        if elapsedTimeInSeconds >= t1spawndelay and Random(1, 5) == 1 then
            ForkThread(SpeedCurrentUnits)
        end
    end

    local randomEventsThread = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        while true do
            runRandomEvents(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
            WaitSeconds(RandomFrequency)
        end
    end

    return {
        start = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
            ForkThread(randomEventsThread, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        end
    }
end