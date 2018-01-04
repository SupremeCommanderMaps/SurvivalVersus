newInstance = function(ScenarioInfo, options, textPrinter, playerArmies)
    local ScenarioFramework = import('/lua/ScenarioFramework.lua');

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
        ARMY_1 = false,
        ARMY_2 = false,
        ARMY_3 = false,
        ARMY_4 = false,
        ARMY_5 = false,
        ARMY_6 = false,
        ARMY_7 = false,
        ARMY_8 = false
    }

    local function createStartingPlayersExistance()
        if not ScenarioInfo.ArmySetup["ARMY_1"] == false then
            StartingPlayersExistance.ARMY_1 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_2"] == false then
            StartingPlayersExistance.ARMY_2 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_3"] == false then
            StartingPlayersExistance.ARMY_3 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_4"] == false then
            StartingPlayersExistance.ARMY_4 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_5"] == false then
            StartingPlayersExistance.ARMY_5 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_6"] == false then
            StartingPlayersExistance.ARMY_6 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_7"] == false then
            StartingPlayersExistance.ARMY_7 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_8"] == false then
            StartingPlayersExistance.ARMY_8 = true
        end
    end

    local function IsTotalVetEnabled()
        local ai = GetArmyBrain("ARMY_9")
        for _,unit  in ai:GetListOfUnits( categories.STRUCTURE, false ) do
            if unit:GetBlueprint().Economy.xpValue == nil then
                LOG('TVG Disabled')
                return false
            else
                LOG('TVG Enabled')
                return true
            end
        end
    end

    local function IsBLackOpsAcusEnabled()
        local bobp = GetUnitBlueprintByName("eal0001")
        if bobp.Economy.BuildTime  == nil then
            LOG('Blackops Disabled')
            return false
        else
            LOG('Blackops Enabled')
            return true
        end
    end

    local allUnits = function()
        return GetUnitsInRect({x0 = 0, x1 = ScenarioInfo.size[1], y0 = 0, y1 = ScenarioInfo.size[2]})
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

    local function RemoveWreckage(unitgroup)
        local bp
        if (ScenarioInfo.Options.opt_AutoReclaim > 0) then
            for _, unit in unitgroup do
                bp = unit:GetBlueprint()
                bp.Wreckage = nil
            end
        end
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

    local Killgroup = function(unitgroup)
        WaitSeconds(60*5)
        for _, value in unitgroup do
            if not value:IsDead() then
                spawnOutEffect(value)
            end
        end
    end

    local function disableWalls()
        for armyIndex in ListArmies() do
            AddBuildRestriction(armyIndex, categories.WALL)
        end
    end

    local setUp = function()
        disableWalls()

        if options.isSurvivalVersus() then
            local tblArmies = ListArmies()
            for index, name in tblArmies do
                if name == "ARMY_5" or name == "ARMY_6" or name == "ARMY_7" or name == "ARMY_8" then
                    SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
                    SetAlliance(index, "ARMY_9", 'Ally')
                elseif name == "ARMY_1" or name == "ARMY_2" or name == "ARMY_3" or name == "ARMY_4" then
                    SetAlliance(index, "ARMY_9", 'Enemy')
                    SetAlliance(index, "NEUTRAL_CIVILIAN", 'Ally')
                end
            end

            SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')
        end

        if options.isSurvivalClassic() then
            local tblArmies = ListArmies()
            for index in tblArmies do
                SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
                SetAlliance(index, "ARMY_9", 'Enemy')
            end
            SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')
        end

        local survivalStructures = import('/maps/final_rush_pro_5.4.v0001/src/SurvivalStructures.lua').newInstance()

        if options.waterKillsAcu() then
            local commanderWaterPain = import('/maps/final_rush_pro_5.4.v0001/src/CommanderWaterPain.lua').newInstance(allUnits)
            commanderWaterPain.runThread()

            survivalStructures.createHillGuards()
        end

        survivalStructures.createParagons()
        survivalStructures.createRadars()
    end

    local runBattle = function(textPrinter, playerArmies)
        local healthMultiplier = import('/maps/final_rush_pro_5.4.v0001/src/HealthMultiplier.lua').newInstance(
            ScenarioInfo.Options.opt_FinalRushDifficulty,
            ScenarioInfo.Options.opt_FinalRushHealthIncrease,
            IsTotalVetEnabled()
        )

        local t1spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay
        local t2spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushT2Delay
        local t3spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushT3Delay
        local t4spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushT4Delay

        if ScenarioInfo.Options.opt_FinalRushAggression == 1 then
            local agressionSpawner = import('/maps/final_rush_pro_5.4.v0001/src/AggressionSpawner.lua').newInstance(
                StartingPlayersExistance,
                import('/maps/final_rush_pro_5.4.v0001/src/RandomUnits.lua').newInstance(ScenarioInfo, ScenarioFramework),
                AttackLocations,
                TransportDestinations,
                ScenarioInfo,
                ScenarioFramework,
                GetRandomPlayer,
                Killgroup,
                RemoveWreckage,
                spawnOutEffect,
                healthMultiplier
            )

            agressionSpawner.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end

        local unitSpanwerFactory = import('/maps/final_rush_pro_5.4.v0001/src/SurvivalSpawnerFactory.lua').newInstance(
            options,
            ScenarioFramework,
            playerArmies,
            healthMultiplier,
            RemoveWreckage,
            GetRandomPlayer,
            Killgroup,
            spawnOutEffect,
            TransportDestinations,
            allUnits
        )

        local rounds = import('/maps/final_rush_pro_5.4.v0001/src/SurvivalRounds.lua').newInstance(
            textPrinter,
            unitSpanwerFactory
        )

        local SpawnMulti = table.getn(playerArmies.getIndexToNameMap()) / 8

        rounds.start({
            T1 = {
                initialDelayInSeconds = t1spawndelay,
                frequencyInSeconds = ScenarioInfo.Options.opt_FinalRushT1Frequency / SpawnMulti,
                spawnEndInSeconds = t2spawndelay,
            },
            T2 = {
                initialDelayInSeconds = t2spawndelay,
                frequencyInSeconds = ScenarioInfo.Options.opt_FinalRushT2Frequency / SpawnMulti,
                spawnEndInSeconds = nil,
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

        local eventTextPrinter =
            ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and textPrinter
                or import('/maps/final_rush_pro_5.4.v0001/src/NullTextPrinter.lua').newInstance()

        if ScenarioInfo.Options.opt_FinalRushRandomEvents > 0 then
            local randomEvents = import('/maps/final_rush_pro_5.4.v0001/src/RandomEvents.lua').newInstance(
                ScenarioInfo,
                eventTextPrinter,
                allUnits,
                ListArmies,
                unitSpanwerFactory
            )

            randomEvents.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, ScenarioInfo.Options.opt_FinalRushRandomEvents)
        end

        if ScenarioInfo.Options.opt_FinalRushHunters > 0 then
            local hunters = import('/maps/final_rush_pro_5.4.v0001/src/Hunters.lua').newInstance(
                eventTextPrinter,
                healthMultiplier,
                playerArmies,
                IsBLackOpsAcusEnabled(),
                spawnOutEffect,
                allUnits,
                spawnEffect
            )

            ForkThread(
                hunters.hunterSpanwer,
                ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushHunterDelay,
                ScenarioInfo.Options.opt_FinalRushHunters / SpawnMulti
            )
        end
    end

    return {
        start = function()
            createStartingPlayersExistance()
            setUp()
            ForkThread(runBattle, textPrinter, playerArmies)
        end
    }
end