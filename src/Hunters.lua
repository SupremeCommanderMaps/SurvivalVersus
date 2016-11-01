newInstance = function(textPrinter, healthMultiplier, playerArmies, acuEn, spawnOutEffect, allUnits, spawnEffect)
    local getRandomArmy = function()
        local armyName
        local armies = playerArmies.getIndexToNameMap()

        repeat
            armyName = armies[Random(1, table.getn(armies))]
        until not ArmyIsOutOfGame(armyName)

        return armyName
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

    local GetArmyCommander = function(army)
        local units = allUnits()
        local commander = false
        for _, unit in units do
            if EntityCategoryContains(categories.COMMAND, unit) and scnArmy(unit) == army then
                commander = unit
            end
        end
        return commander
    end

    local CommanderUpgrades = function(unit)
        local unitid = unit:GetUnitId()
        if unitid == "ual0001" then 							--Aeon Armored Command Unit
            unit:CreateEnhancement("Shield")
            unit:CreateEnhancement("ShieldHeavy")
            unit:CreateEnhancement("HeatSink")
            unit:CreateEnhancement("CrysalisBeam")
        elseif unitid == "url0001" then 						--Cybran Armored Command Unit
            unit:CreateEnhancement("StealthGenerator")
            unit:CreateEnhancement("CloakingGenerator")
            unit:CreateEnhancement("CoolingUpgrade")
            unit:CreateEnhancement("MicrowaveLaserGenerator")
        elseif unitid == "uel0001" then 						--UEF Armored Command Unit
            unit:CreateEnhancement("DamageStablization")
            unit:CreateEnhancement("HeavyAntiMatterCannon")
            unit:CreateEnhancement("Shield")
        elseif unitid == "xsl0001" then 						--Seraphim Armored Command Unit
            unit:CreateEnhancement("BlastAttack")
            unit:CreateEnhancement("DamageStabilization")
            unit:CreateEnhancement("DamageStabilizationAdvanced")
            unit:CreateEnhancement("RateOfFire")
        elseif unitid == "eal0001" then 						--Aeon Blackops Armored Command Unit
            unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
            unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
            unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
            unit:CreateEnhancement("EXBeamPhason")
            unit:CreateEnhancement("EXImprovedCoolingSystem")
            unit:CreateEnhancement("EXPowerBooster")
            unit:CreateEnhancement("EXShieldBattery")
            unit:CreateEnhancement("EXActiveShielding")
            unit:CreateEnhancement("EXImprovedShieldBattery")
        elseif unitid == "erl0001" then 						--Cybran Blackops Armored Command Unit
            unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
            unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
            unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
            unit:CreateEnhancement("EXMasor")
            unit:CreateEnhancement("EXImprovedCoolingSystem")
            unit:CreateEnhancement("EXAdvancedEmitterArray")
            unit:CreateEnhancement("EXArmorPlating")
            unit:CreateEnhancement("EXStructuralIntegrity")
            unit:CreateEnhancement("EXCompositeMaterials")
        elseif unitid == "eel0001" then 						--UEF Blackops Armored Command Unit
            unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
            unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
            unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
            unit:CreateEnhancement("EXAntiMatterCannon")
            unit:CreateEnhancement("EXImprovedContainmentBottle")
            unit:CreateEnhancement("EXPowerBooster")
            unit:CreateEnhancement("EXShieldBattery")
            unit:CreateEnhancement("EXActiveShielding")
            unit:CreateEnhancement("EXImprovedShieldBattery")
        elseif unitid == "esl0001" then 						--Seraphim Blackops Armored Command Unit
            unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
            unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
            unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
            unit:CreateEnhancement("EXCannonBigBall")
            unit:CreateEnhancement("EXImprovedContainmentBottle")
            unit:CreateEnhancement("EXPowerBooster")
            unit:CreateEnhancement("EXL1Lambda")
            unit:CreateEnhancement("EXL2Lambda")
            unit:CreateEnhancement("EXL3Lambda")
        elseif unitid == "ual0301" then 						--Aeon T3 Support Armored Command Unit
            unit:CreateEnhancement("Shield") 	 					--back
            unit:CreateEnhancement("ShieldHeavy") 	 				--back
            unit:CreateEnhancement("StabilitySuppressant")  		--right
            unit:CreateEnhancement("EngineeringFocusingModule")  	--left
        elseif unitid == "url0301" then --Cybran T3 Support Armored Command Unit
            unit:CreateEnhancement("StealthGenerator")  			--back
            unit:CreateEnhancement("CloakingGenerator")  			--back
            unit:CreateEnhancement("EMPCharge")						--left
            unit:CreateEnhancement("FocusConvertor")				--right
        elseif unitid == "uel0301" then --UEF T3 Support Armored Command Unit
            unit:CreateEnhancement("AdvancedCoolingUpgrade")		--left
            unit:CreateEnhancement("HighExplosiveOrdnance")			--right
            unit:CreateEnhancement("Shield")						--back
        elseif unitid == "xsl0301" then --Seraphim T3 Support Armored Command Unit
            unit:CreateEnhancement("DamageStabilization")			--left
            unit:CreateEnhancement("Shield")						--back
            unit:CreateEnhancement("Overcharge")					--right
        end
    end

    --given a player returns a proper username
    local getUsername = function(army)
        return GetArmyBrain(army).Nickname;
    end

    local function getCommanderNames()
        if acuEn then
            return { "erl0001", "eel0001", "eal0001", "esl0001" }
        end

        return { "url0001", "uel0001", "ual0001", "xsl0001" }
    end

    local function spawnCommander(unitName)
        local commander = CreateUnitHPR(unitName, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)

        ForkThread(spawnEffect, commander)
        ForkThread(CommanderUpgrades, commander)

        return commander
    end

    local function spawnRandomCommander()
        return spawnCommander(getCommanderNames()[Random(1,4)])
    end

    local Hunters = function(initialSpawnDelayInSeconds)
        local AttackTeam = getRandomArmy()

        textPrinter.print("Hunters are targeting " .. getUsername(AttackTeam));

        local leadBountyHunter = spawnRandomCommander()
        leadBountyHunter:SetCustomName("Bounty Hunter = Target: " .. getUsername(AttackTeam))

        local unit_aeon  = spawnCommander("ual0301")  --Aeon T3 Support Armored Command Unit
        local unit_cyran = spawnCommander("url0301")  --Cybran T3 Support Armored Command Unit
        local unit_uef   = spawnCommander("uel0301")  --UEF T3 Support Armored Command Unit
        local unit_sera  = spawnCommander("xsl0301")  --Seraphim T3 Support Armored Command Unit

        local unit_list = { leadBountyHunter, unit_aeon, unit_cyran, unit_uef, unit_sera }

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(unit_list, initialSpawnDelayInSeconds)
        end

        local AttackCommander = GetArmyCommander(AttackTeam)

        if AttackCommander == false then
            --team has no commander
            WaitSeconds(3)
            for _, unit in unit_list do
                ForkThread(spawnOutEffect,unit)
            end
        else
            IssueAttack(unit_list, AttackCommander)

            while not AttackCommander:IsDead() do
                WaitSeconds(3)
            end

            textPrinter.print("Bounty " .. getUsername(AttackTeam) .. " Collected");

            WaitSeconds(6)

            for _, unit in unit_list do
                ForkThread(spawnOutEffect,unit)
            end
        end
    end

    return {
        hunterSpanwer = function(initialSpawnDelayInSeconds, frequency)
            WaitSeconds(delay)
            textPrinter.print("Hunters inbound")

            while true do
                ForkThread(Hunters, initialSpawnDelayInSeconds)
                WaitSeconds(frequency)
            end
        end
    }
end