newInstance = function(ScenarioInfo)
    local options = import('/maps/final_rush_pro_5.v0019/src/frp/FinalRushOptions.lua').newInstance(ScenarioInfo.Options)
    ScenarioInfo.Options = options.getRawOptions()

    local textPrinter = import('/maps/final_rush_pro_5.v0019/src/lib/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/final_rush_pro_5.v0019/src/frp/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/final_rush_pro_5.v0019/src/frp/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo, options)

    local welcomeMessages = import('/maps/final_rush_pro_5.v0019/src/frp/WelcomeMessages.lua').newInstance(ScenarioInfo, options, textPrinter)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            import('/maps/final_rush_pro_5.v0019/src/frp/PrebuildTents.lua')
                .newInstance(playerArmies)
                .spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/final_rush_pro_5.v0019/src/frp/CivilianLighthouses.lua')
            .newInstance(textPrinter, playerArmies)
            .spawn()
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/final_rush_pro_5.v0019/src/frp/TechRestrictor.lua').newInstance(
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
            import('/maps/final_rush_pro_5.v0019/src/paragon/ParagonWars.lua')
                .newInstance(playerArmies, textPrinter)
                .setUp()
        end
    end

    local function setupServival()
        if options.isSurvivalGame() then
            import('/maps/final_rush_pro_5.v0019/src/survival/Survival.lua')
                .newInstance(ScenarioInfo, options, textPrinter, playerArmies)
                .start()
        end
    end

    local function setupAutoReclaim()
        if options.getAutoReclaimPercentage() ~= 0 then
            ForkThread(
                import('/maps/final_rush_pro_5.v0019/src/frp/AutoReclaim.lua').AutoReclaimThread,
                options,
                playerArmies
            )
        end
    end

    local function showWelcomeMessage()
        welcomeMessages.startDisplay()
    end

    local function setupResourceDeposits()
        local resourcesSpawner = import('/maps/final_rush_pro_5.v0019/src/frp/ResourcesSpawner.lua').newInstance(
            import('/maps/final_rush_pro_5.v0019/src/lib/ResourceCreator.lua').newInstance(),
            import('/maps/final_rush_pro_5.v0019/final_rush_pro_5_tables.lua'),
            import('/lua/sim/ScenarioUtilities.lua').GetMarkers(),
            playerArmies
        )
        resourcesSpawner.spawnResources()
    end

    return {
        setUp = function()
            showWelcomeMessage()
            buildRestrictor.resetToStartingRestrictions()
            setupTents()
            setupLighthouses()
            restrictTechs()
            setupParagonWars()
            setupServival()
            setupAutoReclaim()
            setupResourceDeposits()
        end,
        printSettings = function()
            welcomeMessages.showSettings()
        end
    }
end