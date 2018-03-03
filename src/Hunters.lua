newInstance = function(unitCreator, textPrinter, healthMultiplier, playerArmies, acuEn, spawnOutEffect, allUnits, spawnEffect)
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

    local function spawnCommander(armyName, unitName)
        local commander = unitCreator.spawnSurvivalUnit({
            blueprintName = unitName,
            armyName = armyName,
            x = Random(250,260),
            y = Random(250,260)
        })

        ForkThread(spawnEffect, commander)
        ForkThread(CommanderUpgrades, commander)

        return commander
    end

    local function spawnRandomCommander(hunterArmyName)
        return spawnCommander(hunterArmyName, getCommanderNames()[Random(1,4)])
    end

    local getAcuByArmyName = function(armyName)
        local armyIndex = playerArmies.getIndexForName(armyName)

        for _, unit in allUnits() do
            if EntityCategoryContains(categories.COMMAND, unit) and unit:GetArmy() == armyIndex then
                return unit
            end
        end

        return false
    end

    local huntingThread = function(targetArmyName, hunterArmyName, initialSpawnDelayInSeconds)
        local targetAcu = getAcuByArmyName(targetArmyName)

        if targetAcu == false then
            return
        end

        textPrinter.print("Hunters are targeting " .. getUsername(targetArmyName));

        local leadBountyHunter = spawnRandomCommander(hunterArmyName)
        leadBountyHunter:SetCustomName("Bounty Hunter = Target: " .. getUsername(targetArmyName))

        local aeonHunter = spawnCommander(hunterArmyName, "ual0301")  --Aeon T3 Support Armored Command Unit
        local cyranHunter = spawnCommander(hunterArmyName, "url0301")  --Cybran T3 Support Armored Command Unit
        local spaceNazi = spawnCommander(hunterArmyName, "uel0301")  --UEF T3 Support Armored Command Unit
        local seraHunter = spawnCommander(hunterArmyName, "xsl0301")  --Seraphim T3 Support Armored Command Unit

        local bountryHunters = { leadBountyHunter, aeonHunter, cyranHunter, spaceNazi, seraHunter }

        healthMultiplier.increaseHealth(bountryHunters, initialSpawnDelayInSeconds)

        IssueAttack(bountryHunters, targetAcu)

        while not targetAcu:IsDead() do
            WaitSeconds(3)
        end

        textPrinter.print("Bounty " .. getUsername(targetArmyName) .. " Collected");

        WaitSeconds(5)

        for _, unit in bountryHunters do
            -- FIXME: this causes an error for some of the commanders that halts that thread before unit:Destroy() is reached
            ForkThread(spawnOutEffect, unit)

            ForkThread(function(unit)
                WaitSeconds(1)
                unit:Destroy()
            end, unit)
        end
    end

    local function huntRandomArmy(hunterArmyName, initialSpawnDelayInSeconds)
        local targetArmyName = playerArmies
            .getTargetsForArmy(hunterArmyName)
            .filterByName(function(aName)
                return not ArmyIsOutOfGame(aName)
            end)
            .getRandomArmyName()

        if targetArmyName ~= nil then
            ForkThread(
                huntingThread,
                targetArmyName,
                hunterArmyName,
                initialSpawnDelayInSeconds
            )
        end
    end

    return {
        hunterSpanwer = function(initialSpawnDelayInSeconds, frequency)
            WaitSeconds(initialSpawnDelayInSeconds)
            textPrinter.print("Hunters inbound")

            while true do
                huntRandomArmy("NEUTRAL_CIVILIAN", initialSpawnDelayInSeconds)
                huntRandomArmy("ARMY_9", initialSpawnDelayInSeconds)
                WaitSeconds(frequency)
            end
        end
    }
end