newInstance = function(ScenarioInfo, options, textPrinter, playerArmies)
    local ScenarioFramework = import('/lua/ScenarioFramework.lua')

    local TransportDestinations = {
        SouthernAttackerEnd = VECTOR3(500,80,10),
        NorthernAttackerEnd = VECTOR3(10,80,500)
    }

    local AttackLocations = {
        Team1 = {
            Player1 = VECTOR3( 305.5, 25.9844, 451.5 ),
            Player2 = VECTOR3( 375.5, 25.9844, 435.5 ),
            Player3 = VECTOR3( 435.5, 25.9844, 375.5 ),
            Player4 = VECTOR3( 451.5, 25.9844, 305.5 )
        },
        Team2 = {
            Player1 = VECTOR3( 206.5, 25.9844, 60.5 ),
            Player2 = VECTOR3( 132.5, 25.9922, 71.5 ),
            Player3 = VECTOR3( 71.5, 25.9922, 132.5 ),
            Player4 = VECTOR3( 68.5, 25.9844, 214.5 )
        }
    }

    local StartingPlayersExistance = {
        ARMY_BOTTOM_LEFT = false,
        ARMY_BOTTOM_LMID = false,
        ARMY_BOTTOM_RMID = false,
        ARMY_BOTTOM_RIGHT = false,
        ARMY_TOP_RIGHT = false,
        ARMY_TOP_RMID = false,
        ARMY_TOP_LMID = false,
        ARMY_TOP_LEFT = false
    }

    local t1spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay
    local t2spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushT2Delay
    local t3spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushT3Delay
    local t4spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushT4Delay

    local function createStartingPlayersExistance()
        if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_LEFT"] == false then
            StartingPlayersExistance.ARMY_BOTTOM_LEFT = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_LMID"] == false then
            StartingPlayersExistance.ARMY_BOTTOM_LMID = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_RMID"] == false then
            StartingPlayersExistance.ARMY_BOTTOM_RMID = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_RIGHT"] == false then
            StartingPlayersExistance.ARMY_BOTTOM_RIGHT = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_TOP_RIGHT"] == false then
            StartingPlayersExistance.ARMY_TOP_RIGHT = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_TOP_RMID"] == false then
            StartingPlayersExistance.ARMY_TOP_RMID = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_TOP_LMID"] == false then
            StartingPlayersExistance.ARMY_TOP_LMID = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_TOP_LEFT"] == false then
            StartingPlayersExistance.ARMY_TOP_LEFT = true
        end
    end

    local allUnits = function()
        return GetUnitsInRect({x0 = 0, x1 = ScenarioInfo.size[1], y0 = 0, y1 = ScenarioInfo.size[2]})
    end

    local function isSurvivalUnit(unit)
        local armyName = ListArmies()[unit:GetArmy()]
        return armyName == "BOTTOM_BOT" or armyName == "TOP_BOT"
    end

    local GetRandomPlayer = function(team)
        local selectplayertoattack = Random(1,4)
        local Units_FinalFight

        if team == 1 then
            if selectplayertoattack == 1 then
                Units_FinalFight = AttackLocations.Team1.Player1
            elseif selectplayertoattack == 2 then
                Units_FinalFight = AttackLocations.Team1.Player2
            elseif selectplayertoattack == 3 then
                Units_FinalFight = AttackLocations.Team1.Player3
            elseif selectplayertoattack == 4 then
                Units_FinalFight = AttackLocations.Team1.Player4
            end
        elseif team == 2 then
            if selectplayertoattack == 1 then
                Units_FinalFight = AttackLocations.Team2.Player1
            elseif selectplayertoattack == 2 then
                Units_FinalFight = AttackLocations.Team2.Player2
            elseif selectplayertoattack == 3 then
                Units_FinalFight = AttackLocations.Team2.Player3
            elseif selectplayertoattack == 4 then
                Units_FinalFight = AttackLocations.Team2.Player4
            end
        end
        return Units_FinalFight
    end

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

    local function disableWalls()
        for armyIndex in ListArmies() do
            AddBuildRestriction(armyIndex, categories.WALL)
        end
    end

    local function setSurvivalVersusAlliances()
        local tblArmies = ListArmies()
        for index, name in tblArmies do
            SetAlliance(index, "FRIENDLY_BOT", 'Ally')

            if name == "ARMY_TOP_RIGHT" or name == "ARMY_TOP_RMID" or name == "ARMY_TOP_LMID" or name == "ARMY_TOP_LEFT" then
                SetAlliance(index, "TOP_BOT", 'Enemy')
                SetAlliance(index, "BOTTOM_BOT", 'Ally')
                SetAlliance(index, "HOSTILE_BOT", 'Enemy')
            elseif name == "ARMY_BOTTOM_LEFT" or name == "ARMY_BOTTOM_LMID" or name == "ARMY_BOTTOM_RMID" or name == "ARMY_BOTTOM_RIGHT" then
                SetAlliance(index, "BOTTOM_BOT", 'Enemy')
                SetAlliance(index, "TOP_BOT", 'Ally')
                SetAlliance(index, "HOSTILE_BOT", 'Enemy')
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
        local survivalStructures = import('/maps/final_rush_pro_5.v0013/src/survival/SurvivalStructures.lua').newInstance()

        survivalStructures.createTopParagon("BOTTOM_BOT")
        survivalStructures.createTopOmni("HOSTILE_BOT")
        survivalStructures.createTopRadar("FRIENDLY_BOT")

        survivalStructures.createBottomParagon("TOP_BOT")
        survivalStructures.createBottomOmni("HOSTILE_BOT")
        survivalStructures.createBottomRadar("FRIENDLY_BOT")

        import('/maps/final_rush_pro_5.v0013/src/survival/IslandBases.lua').newInstance().spawn()
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
            import('/maps/final_rush_pro_5.v0013/src/survival/CommanderWaterPain.lua')
                .newInstance(allUnits, textPrinter, isSurvivalUnit).runThread()

            import('/maps/final_rush_pro_5.v0013/src/artifacts/HillGuards.lua').newInstance().createHillGuards()
        end
    end

    local function setupAutoReclaim(unitCreator)
        if ScenarioInfo.Options.opt_AutoReclaim > 0 then
            unitCreator.onUnitCreated(function(unit, unitInfo)
                if unitInfo.isSurvivalSpawned then
                    unit.CreateWreckage = function() end
                end
            end)
        end
    end

    local function setupUnitTimeouts(unitCreator)
        unitCreator.onUnitCreated(function(unit, unitInfo)
            if unitInfo.isSurvivalSpawned then
                ForkThread(function()
                    WaitSeconds(60*5)
                    if not unit:IsDead() then
                        spawnOutEffect(unit)
                    end
                end)
            end
        end)
    end

    local function setupTeamBalanceBonus(unitCreator)
        if ScenarioInfo.Options.opt_FinalRushTeamBonusHP ~= 0 then
            local hpMultiplier = import('/maps/final_rush_pro_5.v0013/src/survival/TeamBonusHealthMultiplier.lua').newInstance(
                ScenarioInfo.Options.opt_FinalRushTeamBonusHP
            )

            unitCreator.onUnitCreated(function(unit, unitInfo)
                if unitInfo.isSurvivalSpawned or unitInfo.isTransport then
                    hpMultiplier.multiplyHealth(unit)
                end
            end)
        end
    end

    local function setupHealthMultiplication(unitCreator)
        if ScenarioInfo.Options.opt_FinalRushHealthIncrease ~= 0 then
            local healthMultiplier = import('/maps/final_rush_pro_5.v0013/src/survival/HealthMultiplier.lua').newInstance(
                ScenarioInfo.Options.opt_FinalRushHealthIncrease
            )

            unitCreator.onUnitCreated(function(unit, unitInfo)
                if unitInfo.hpIncrease ~= nil then
                    local hpIncreaseDelays = {
                        [categories.TECH1] = options.getT1spawnDelay(),
                        [categories.TECH2] = options.getT2spawnDelay(),
                        [categories.TECH3] = options.getT3spawnDelay(),
                        [categories.EXPERIMENTAL] = options.getT4spawnDelay(),
                    }

                    if unitInfo.hpIncrease == true then
                        for techCategory, hpIncreaseDelay in hpIncreaseDelays do
                            if EntityCategoryContains(techCategory, unit) then
                                healthMultiplier.increaseHealth({unit}, hpIncreaseDelay)
                                break
                            end
                        end
                    elseif hpIncreaseDelays[unitInfo.hpIncrease] ~= nil then
                        healthMultiplier.increaseHealth({unit}, hpIncreaseDelays[unitInfo.hpIncrease])
                    end

                elseif unitInfo.hpIncreaseDelay ~= nil then
                    healthMultiplier.increaseHealth({unit}, unitInfo.hpIncreaseDelay)
                end
            end)
        end
    end

    local function newUnitCreator()
        local unitCreator = import('/maps/final_rush_pro_5.v0013/src/lib/UnitCreator.lua').newUnitCreator()

        setupAutoReclaim(unitCreator)
        setupUnitTimeouts(unitCreator)
        setupTeamBalanceBonus(unitCreator)
        setupHealthMultiplication(unitCreator)

        return unitCreator
    end

    local runBattle = function(textPrinter, playerArmies)
        local unitCreator = newUnitCreator()

        if ScenarioInfo.Options.opt_FinalRushAggression == 1 then
            local agressionSpawner = import('/maps/final_rush_pro_5.v0013/src/survival/AggressionSpawner.lua').newInstance(
                StartingPlayersExistance,
                import('/maps/final_rush_pro_5.v0013/src/survival/RandomUnits.lua').newInstance(ScenarioInfo, ScenarioFramework),
                AttackLocations,
                TransportDestinations,
                ScenarioInfo,
                ScenarioFramework,
                GetRandomPlayer,
                spawnOutEffect,
                unitCreator
            )

            agressionSpawner.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end

        local unitSpanwerFactory = import('/maps/final_rush_pro_5.v0013/src/survival/SurvivalSpawnerFactory.lua').newInstance(
            options,
            ScenarioFramework,
            unitCreator,
            playerArmies,
            GetRandomPlayer,
            spawnOutEffect,
            TransportDestinations,
            allUnits
        )

        local SpawnMulti = table.getn(playerArmies.getIndexToNameMap()) / 8

        local function getEventTextPrinter()
            return ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and textPrinter
                    or import('/maps/final_rush_pro_5.v0013/src/lib/NullTextPrinter.lua').newInstance()
        end

        local function runSurvivalRounds()
            local rounds = import('/maps/final_rush_pro_5.v0013/src/survival/SurvivalRounds.lua').newInstance(
                textPrinter,
                unitSpanwerFactory,
                options
            )

            rounds.start({
                T1 = {
                    initialDelayInSeconds = t1spawndelay,
                    frequencyInSeconds = ScenarioInfo.Options.opt_FinalRushT1Frequency / SpawnMulti,
                    spawnEndInSeconds = t2spawndelay,
                },
                T2 = {
                    initialDelayInSeconds = t2spawndelay,
                    frequencyInSeconds = ScenarioInfo.Options.opt_FinalRushT2Frequency / SpawnMulti,
                    spawnEndInSeconds = t4spawndelay,
                },
                T3 = {
                    initialDelayInSeconds = t3spawndelay,
                    frequencyInSeconds = ScenarioInfo.Options.opt_FinalRushT3Frequency / SpawnMulti,
                    spawnEndInSeconds = nil,
                },
                T4 = {
                    initialDelayInSeconds = t4spawndelay,
                    frequencyInSeconds = ScenarioInfo.Options.opt_FinalRushT4Frequency / SpawnMulti,
                    spawnEndInSeconds = nil,
                },
            })
        end

        local function runRandomEvents()
            if ScenarioInfo.Options.opt_FinalRushRandomEvents > 0 then
                local randomEvents = import('/maps/final_rush_pro_5.v0013/src/survival/RandomEvents.lua').newInstance(
                    ScenarioInfo,
                    getEventTextPrinter(),
                    allUnits,
                    isSurvivalUnit,
                    unitSpanwerFactory,
                    import('/maps/final_rush_pro_5.v0013/src/survival/BeetleEvent.lua').newInstance(unitCreator, spawnEffect)
                )

                randomEvents.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, ScenarioInfo.Options.opt_FinalRushRandomEvents)
            end
        end

        local function IsBLackOpsAcusEnabled()
            local bobp = GetUnitBlueprintByName("eal0001")
            return bobp.Economy.BuildTime  ~= nil
        end

        local function runBountyHunters()
            if ScenarioInfo.Options.opt_FinalRushHunters > 0 then
                local hunters = import('/maps/final_rush_pro_5.v0013/src/survival/Hunters.lua').newInstance(
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
            createStartingPlayersExistance()
            setUp()
            ForkThread(runBattle, textPrinter, playerArmies)
        end
    }
end