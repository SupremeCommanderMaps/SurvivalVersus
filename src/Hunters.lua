newInstance = function(textPrinter, healthMultiplier, acuEn, spawnOutEffect)
    local GetRandomCommander = function()
        local army = false
        local randomnum

        while army == false do
            randomnum = Random(1,8)
            if randomnum == 1 and StartingPlayersExistance.ARMY_1 and ArmyIsOutOfGame("ARMY_1") == false then
                army = "ARMY_1"
            elseif randomnum == 2 and StartingPlayersExistance.ARMY_2 and ArmyIsOutOfGame("ARMY_2") == false then
                army = "ARMY_2"
            elseif randomnum == 3 and StartingPlayersExistance.ARMY_3 and ArmyIsOutOfGame("ARMY_3") == false then
                army = "ARMY_3"
            elseif randomnum == 4 and StartingPlayersExistance.ARMY_4 and ArmyIsOutOfGame("ARMY_4") == false then
                army = "ARMY_4"
            elseif randomnum == 5 and StartingPlayersExistance.ARMY_5 and ArmyIsOutOfGame("ARMY_5") == false then
                army = "ARMY_5"
            elseif randomnum == 6 and StartingPlayersExistance.ARMY_6 and ArmyIsOutOfGame("ARMY_6") == false then
                army = "ARMY_6"
            elseif randomnum == 7 and StartingPlayersExistance.ARMY_7 and ArmyIsOutOfGame("ARMY_7") == false then
                army = "ARMY_7"
            elseif randomnum == 8 and StartingPlayersExistance.ARMY_8 and ArmyIsOutOfGame("ARMY_8") == false then
                army = "ARMY_8"
            end
        end

        textPrinter.print("Hunters are targeting " .. getUsername(army), 20, "ffffffff", 5, 'center');
        return army
    end

    local GetArmyCommander = function(army)
        local units = allUnits()
        local commander = false
        for _, unit in units do
            if EntityCategoryContains(categories.COMMAND, unit) and scnArmy(unit) ==  army then
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

    local Hunters = function(hpincreasedelay)
        local AttackTeam = GetRandomCommander() --returns army ie. ARMY_1
        local AttackCommander = GetArmyCommander(AttackTeam)
        local Leader
        local spawnrandomcommander = Random(1,4)


        local acu_cyran
        local acu_uef
        local acu_aeon
        local acu_seraphim

        if acuEn == false then
            acu_cyran	 =	"url0001"
            acu_uef		 =	"uel0001"
            acu_aeon	 =	"ual0001"
            acu_seraphim =	"xsl0001"
        elseif acuEn == true then
            acu_cyran	 =	"erl0001"
            acu_uef		 =	"eel0001"
            acu_aeon	 =	"eal0001"
            acu_seraphim =	"esl0001"
        end

        if spawnrandomcommander == 1 then
            Leader = CreateUnitHPR(acu_aeon, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Aeon Armored Command Unit
        elseif spawnrandomcommander == 2 then
            Leader = CreateUnitHPR(acu_cyran, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Cybran Armored Command Unit
        elseif spawnrandomcommander == 3 then
            Leader = CreateUnitHPR(acu_uef, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --UEF Armored Command Unit
        elseif spawnrandomcommander == 4 then
            Leader = CreateUnitHPR(acu_seraphim, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Seraphim Armored Command Unit
        end
        Leader:SetCustomName("Bounty Hunter = Target: " .. getUsername(AttackTeam))
        local unit_aeon  = CreateUnitHPR("ual0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Aeon T3 Support Armored Command Unit
        local unit_cyran = CreateUnitHPR("url0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Cybran T3 Support Armored Command Unit
        local unit_uef   = CreateUnitHPR("uel0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --UEF T3 Support Armored Command Unit
        local unit_sera  = CreateUnitHPR("xsl0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Seraphim T3 Support Armored Command Unit

        local unit_list = {Leader,unit_aeon,unit_cyran,unit_uef,unit_sera}

        for _, spawnunit in unit_list do
            ForkThread(spawnEffect,spawnunit)
            ForkThread(CommanderUpgrades,spawnunit)
        end

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(unit_list, hpincreasedelay)
        end

        if AttackCommander == false then --team has no commander
        WaitSeconds(3)
        for _, unit in unit_list do
            ForkThread(spawnOutEffect,unit)
        end
        else
            IssueAttack(unit_list,AttackCommander)

            while not AttackCommander:IsDead() do
                WaitSeconds(3)
            end

            textPrinter.print("Bounty " .. getUsername(AttackTeam) .. " Collected" , 20, "ffffffff", 5, 'center');

            WaitSeconds(6)

            for index, unit in unit_list do
                ForkThread(spawnOutEffect,unit)
            end
        end
    end

    return {
        hunterSpanwer = function(delay, frequency)
            WaitSeconds(delay)
            textPrinter.print("Hunters inbound", 20, "ffffffff", 5, 'center')
            while true do
                ForkThread(Hunters,delay)
                WaitSeconds(frequency)
            end
        end
    }
end