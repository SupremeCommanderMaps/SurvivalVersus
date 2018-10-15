newInstance = function(ScenarioInfo)
    local options = import('/maps/final_rush_pro_5.v0020/src/frp/FinalRushOptions.lua').newInstance(ScenarioInfo.Options)
    ScenarioInfo.Options = options.getRawOptions()

    local textPrinter = import('/maps/final_rush_pro_5.v0020/src/lib/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/final_rush_pro_5.v0020/src/frp/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/final_rush_pro_5.v0020/src/frp/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo, options)

    local welcomeMessages = import('/maps/final_rush_pro_5.v0020/src/frp/WelcomeMessages.lua').newInstance(ScenarioInfo, options, textPrinter)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            import('/maps/final_rush_pro_5.v0020/src/frp/PrebuildTents.lua')
                .newInstance(playerArmies)
                .spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/final_rush_pro_5.v0020/src/frp/CivilianLighthouses.lua')
            .newInstance(textPrinter, playerArmies)
            .spawn()
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/final_rush_pro_5.v0020/src/frp/TechRestrictor.lua').newInstance(
                buildRestrictor,
                textPrinter,
                playerArmies,
                ScenarioInfo.Options.opt_timeunlocked
            );

            techRestrictor.startRestrictedTechCascade()
        end
    end

    local function setupParagonWars()
        if options.isParagonWars() then
            import('/maps/final_rush_pro_5.v0020/src/paragon/ParagonWars.lua')
                .newInstance(playerArmies, textPrinter)
                .setUp()
        end
    end

    local function setupServival()
        if options.isSurvivalGame() then
            import('/maps/final_rush_pro_5.v0020/src/survival/Survival.lua')
                .newInstance(ScenarioInfo, options, textPrinter, playerArmies)
                .start()
        end
    end

    local function setupAutoReclaim()
        if options.getAutoReclaimPercentage() ~= 0 then
            ForkThread(
                import('/maps/final_rush_pro_5.v0020/src/frp/AutoReclaim.lua').AutoReclaimThread,
                options,
                playerArmies
            )
        end
    end

    local function showWelcomeMessage()
        welcomeMessages.startDisplay()
    end

    local function setupResourceDeposits()
        local resourcesSpawner = import('/maps/final_rush_pro_5.v0020/src/frp/ResourcesSpawner.lua').newInstance(
            import('/maps/final_rush_pro_5.v0020/src/lib/ResourceCreator.lua').newInstance(),
            import('/maps/final_rush_pro_5.v0020/final_rush_pro_5_tables.lua'),
            import('/lua/sim/ScenarioUtilities.lua').GetMarkers(),
            playerArmies
        )
        resourcesSpawner.spawnResources()
    end

    local function spawnExtraAcus(armyBrain)
        local UEF_ACU = "UEL0001"
        local AEON_ACU = "UAL0001"
        local CYBRAN_ACU = "URL0001"
        local SERA_ACU = "XSL0001"

        local extraACUs = {}
        local factionIndex = armyBrain:GetFactionIndex()

        if factionIndex ~= 1 then
            table.insert(extraACUs, UEF_ACU)
        end
        if factionIndex ~= 2 then
            table.insert(extraACUs, AEON_ACU)
        end
        if factionIndex ~= 3 then
            table.insert(extraACUs, CYBRAN_ACU)
        end
        if factionIndex ~= 4 then
            table.insert(extraACUs, SERA_ACU)
        end

        local posX, posY = armyBrain:GetArmyStartPos()

        for _, acu in extraACUs do
            armyBrain:CreateUnitNearSpot(acu, posX, posY)
        end
    end

    local function setupAllFactions()
        if options.allFactionsIsEnabled() then
            for armyIndex in playerArmies.getIndexToNameMap() do
                spawnExtraAcus(ArmyBrains[armyIndex])
            end
        end
    end

    return {
        setUp = function()
            setupResourceDeposits()
            buildRestrictor.resetToStartingRestrictions()
            setupTents()
            setupLighthouses()
            restrictTechs()
            setupParagonWars()
            setupServival()
            setupAutoReclaim()
            showWelcomeMessage()
            setupAllFactions()
        end,
        printSettings = function()
            welcomeMessages.showSettings()
        end
    }
end