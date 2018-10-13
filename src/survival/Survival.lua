newInstance = function(ScenarioInfo, options, textPrinter, playerArmies)
    local ScenarioFramework = import('/lua/ScenarioFramework.lua')

    local spawnEffect = function(unit)
        unit:PlayUnitSound('TeleportStart')
        unit:PlayUnitAmbientSound('TeleportLoop')
        WaitSeconds( 0.1 )
        unit:PlayTeleportInEffects()
        WaitSeconds( 0.1 )
        unit:StopUnitAmbientSound('TeleportLoop')
        unit:PlayUnitSound('TeleportEnd')
    end

    local spawnOutEffect = function(unit)
        unit:PlayUnitSound('TeleportStart')
        unit:PlayUnitAmbientSound('TeleportLoop')
        WaitSeconds( 0.1 )
        unit:PlayTeleportInEffects()
        WaitSeconds( 0.1 )
        unit:StopUnitAmbientSound('TeleportLoop')
        unit:PlayUnitSound('TeleportEnd')
        unit:Destroy()
    end

    local unitCreator = import('/maps/final_rush_pro_5.v0018/src/survival/SurvivalUnitCreator.lua').newUnitCreator(
        ScenarioInfo,
        options,
        spawnOutEffect
    )

    local positions = import('/maps/final_rush_pro_5.v0018/src/frp/Positions.lua').newInstance()

    local TransportDestinations = positions.TransportDestinations
    local AttackLocations = positions.AttackLocations

    local allUnits = function()
        return GetUnitsInRect({x0 = 0, x1 = ScenarioInfo.size[1], y0 = 0, y1 = ScenarioInfo.size[2]})
    end

    local getRandomPlayer = function(team)
        local randomNumber = Random(1,4)

        if team == 1 then
            if randomNumber == 1 then
                return AttackLocations.Team1.Player1
            elseif randomNumber == 2 then
                return AttackLocations.Team1.Player2
            elseif randomNumber == 3 then
                return AttackLocations.Team1.Player3
            elseif randomNumber == 4 then
                return AttackLocations.Team1.Player4
            end
        elseif team == 2 then
            if randomNumber == 1 then
                return AttackLocations.Team2.Player1
            elseif randomNumber == 2 then
                return AttackLocations.Team2.Player2
            elseif randomNumber == 3 then
                return AttackLocations.Team2.Player3
            elseif randomNumber == 4 then
                return AttackLocations.Team2.Player4
            end
        end
    end

    local function disableWalls()
        for armyIndex in ListArmies() do
            AddBuildRestriction(armyIndex, categories.WALL)
        end
    end

    local function setSurvivalVersusAlliances()
        for armyIndex in ListArmies() do
            SetAlliance(armyIndex, "FRIENDLY_BOT", 'Ally')
        end

        local topArmies = playerArmies.getTopSideArmies().getNameToIndexMap()

        for armyName in topArmies do
            SetAlliance(armyName, "TOP_BOT", 'Enemy')
            SetAlliance(armyName, "BOTTOM_BOT", 'Ally')
            SetAlliance(armyName, "HOSTILE_BOT", 'Enemy')

            for otherArmyName in topArmies do
                if armyName ~= otherArmyName then
                    SetAlliance(armyName, otherArmyName, 'Ally')
                end
            end
        end

        local bottomArmies = playerArmies.getBottomSideArmies().getNameToIndexMap()

        for armyName in bottomArmies do
            SetAlliance(armyName, "TOP_BOT", 'Ally')
            SetAlliance(armyName, "BOTTOM_BOT", 'Enemy')
            SetAlliance(armyName, "HOSTILE_BOT", 'Enemy')

            for otherArmyName in bottomArmies do
                if armyName ~= otherArmyName then
                    SetAlliance(armyName, otherArmyName, 'Ally')
                end
            end
        end
    end

    local function setSurvivalClassicAlliances()
        local tblArmies = ListArmies()
        for index in tblArmies do
            SetAlliance(index, "FRIENDLY_BOT", 'Ally')

            SetAlliance(index, "TOP_BOT", 'Enemy')
            SetAlliance(index, "BOTTOM_BOT", 'Enemy')
            SetAlliance(index, "HOSTILE_BOT", 'Enemy')
        end
    end

    local function colorBots()
        SetArmyColor("BOTTOM_BOT", 110, 90, 90)
        SetArmyColor("TOP_BOT", 150, 170, 150)
    end

    local function allyBotsWithEachOther()
        SetAlliance("BOTTOM_BOT", "TOP_BOT", 'Ally')
        SetAlliance("HOSTILE_BOT", "TOP_BOT", 'Ally')
        SetAlliance("HOSTILE_BOT", "BOTTOM_BOT", 'Ally')

        SetAlliance("FRIENDLY_BOT", "TOP_BOT", 'Ally')
        SetAlliance("FRIENDLY_BOT", "BOTTOM_BOT", 'Ally')
        SetAlliance("FRIENDLY_BOT", "HOSTILE_BOT", 'Ally')
    end

    local function giveStorage(armyName)
        local brain = GetArmyBrain(armyName)
        brain:GiveStorage('MASS', 4242)
        brain:GiveStorage('ENERGY', 4242)
    end

    local function giveBotsStorage()
        giveStorage("BOTTOM_BOT")
        giveStorage("TOP_BOT")
        giveStorage("HOSTILE_BOT")
        giveStorage("FRIENDLY_BOT")
    end

    local function disableBotResourceOverflow()
        GetArmyBrain("HOSTILE_BOT"):SetResourceSharing(false)
        GetArmyBrain("FRIENDLY_BOT"):SetResourceSharing(false)
    end

    local function createSurvivalStructures()
        local survivalStructures = import('/maps/final_rush_pro_5.v0018/src/survival/SurvivalStructures.lua').newInstance()

        survivalStructures.createTopParagon("BOTTOM_BOT")
        survivalStructures.createTopOmni("HOSTILE_BOT")
        survivalStructures.createTopRadar("FRIENDLY_BOT")

        survivalStructures.createBottomParagon("TOP_BOT")
        survivalStructures.createBottomOmni("HOSTILE_BOT")
        survivalStructures.createBottomRadar("FRIENDLY_BOT")

        import('/maps/final_rush_pro_5.v0018/src/survival/IslandBases.lua').newInstance().spawn()
    end

    local setUp = function()
        disableWalls()

        if options.isSurvivalVersus() then
            setSurvivalVersusAlliances()
        end

        if options.isSurvivalClassic() then
            setSurvivalClassicAlliances()
        end

        colorBots()
        allyBotsWithEachOther()
        giveBotsStorage()
        disableBotResourceOverflow()

        createSurvivalStructures()

        if options.waterKillsAcu() then
            import('/maps/final_rush_pro_5.v0018/src/survival/CommanderWaterPain.lua')
                .newInstance(playerArmies, textPrinter).runThread()

            import('/maps/final_rush_pro_5.v0018/src/frp/HillGuards.lua').newInstance().createHillGuards()
        end

        import('/maps/final_rush_pro_5.v0018/src/survival/ParagonEvent.lua').newInstance(
            ScenarioFramework,
            unitCreator,
            playerArmies,
            positions,
            import('/maps/final_rush_pro_5.v0018/src/lib/UnitCreationCallbacks.lua').newInstance(allUnits),
            textPrinter
        ).setUp()
    end

    local runBattle = function(textPrinter, playerArmies)
        local unitSpanwerFactory = import('/maps/final_rush_pro_5.v0018/src/survival/SurvivalSpawnerFactory.lua').newInstance(
            options,
            ScenarioFramework,
            unitCreator,
            playerArmies,
            getRandomPlayer,
            spawnOutEffect,
            TransportDestinations,
            allUnits
        )

        local SpawnMulti = ScenarioInfo.Options.opt_FinalRushUnitCount * table.getn(playerArmies.getIndexToNameMap()) / 8

        local function runSurvivalRounds()
            local rounds = import('/maps/final_rush_pro_5.v0018/src/survival/SurvivalRounds.lua').newInstance(
                ScenarioInfo,
                textPrinter,
                unitSpanwerFactory,
                options,
                SpawnMulti,
                import('/maps/final_rush_pro_5.v0018/src/survival/SurvivalVictory.lua').newInstance(
                    options,
                    textPrinter,
                    playerArmies
                )
            )

            rounds.start()
        end

        local function getEventTextPrinter()
            return ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and textPrinter
                    or import('/maps/final_rush_pro_5.v0018/src/lib/NullTextPrinter.lua').newInstance()
        end

        local function runRandomEvents()
            if ScenarioInfo.Options.opt_FinalRushRandomEvents > 0 then
                local randomEvents = import('/maps/final_rush_pro_5.v0018/src/survival/RandomEvents.lua').newInstance(
                    ScenarioInfo,
                    getEventTextPrinter(),
                    allUnits,
                    unitSpanwerFactory,
                    import('/maps/final_rush_pro_5.v0018/src/survival/BeetleEvent.lua').newInstance(unitCreator, spawnEffect)
                )

                randomEvents.start(
                    options.getT1spawnDelay(),
                    options.getT2spawnDelay(),
                    options.getT3spawnDelay(),
                    options.getT4spawnDelay(),
                    ScenarioInfo.Options.opt_FinalRushRandomEvents
                )
            end
        end

        local function IsBLackOpsAcusEnabled()
            local bobp = GetUnitBlueprintByName("eal0001")
            return bobp.Economy.BuildTime  ~= nil
        end

        local function runBountyHunters()
            if ScenarioInfo.Options.opt_FinalRushHunters > 0 then
                local hunters = import('/maps/final_rush_pro_5.v0018/src/survival/Hunters.lua').newInstance(
                    ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushHunterDelay,
                    unitCreator,
                    getEventTextPrinter(),
                    playerArmies,
                    IsBLackOpsAcusEnabled(),
                    spawnOutEffect,
                    allUnits,
                    spawnEffect
                )

                ForkThread(
                    hunters.hunterSpanwer,
                    ScenarioInfo.Options.opt_FinalRushHunters / SpawnMulti
                )
            end
        end

        runSurvivalRounds()
        runRandomEvents()
        runBountyHunters()
    end

    return {
        start = function()
            setUp()
            ForkThread(runBattle, textPrinter, playerArmies)
        end
    }
end