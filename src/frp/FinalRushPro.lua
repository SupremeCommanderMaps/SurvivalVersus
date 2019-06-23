newInstance = function(ScenarioInfo)
    local function localImport(fileName)
        return import('/maps/final_rush_pro_5.v0021/src/' .. fileName)
    end

    local function vendorImport(fileName)
        return import('/maps/final_rush_pro_5.v0021/vendor/' .. fileName)
    end

    local options = localImport('frp/FinalRushOptions.lua').newInstance(ScenarioInfo.Options)
    ScenarioInfo.Options = options.getRawOptions()

    local textPrinter = vendorImport('lib/TextPrinter.lua').newInstance()
    local playerArmies = localImport('frp/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = localImport('frp/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo, options)

    local welcomeMessages = localImport('frp/WelcomeMessages.lua').newInstance(ScenarioInfo, options, textPrinter)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            localImport('frp/PrebuildTents.lua')
                .newInstance(playerArmies)
                .spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        localImport('frp/CivilianLighthouses.lua')
            .newInstance(textPrinter, playerArmies)
            .spawn()
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = localImport('frp/TechRestrictor.lua').newInstance(
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
            localImport('paragonWars/ParagonWars.lua')
                .newInstance(playerArmies, textPrinter)
                .setUp()
        end
    end

    local function setupServival()
        if options.isSurvivalGame() then
            localImport('survival/Survival.lua')
                .newInstance(ScenarioInfo, localImport, options, textPrinter, playerArmies)
                .start()
        end
    end

    local function setupAutoReclaim()
        if options.getAutoReclaimPercentage() ~= 0 then
            ForkThread(
                localImport('frp/AutoReclaim.lua').AutoReclaimThread,
                options,
                playerArmies
            )
        end
    end

    local function showWelcomeMessage()
        welcomeMessages.startDisplay()
    end

    local function setupResourceDeposits()
        local resourcesSpawner = localImport('frp/ResourcesSpawner.lua').newInstance(
            vendorImport('lib/ResourceCreator.lua').newInstance(),
            import('/maps/final_rush_pro_5.v0021/final_rush_pro_5_tables.lua'),
            import('/lua/sim/ScenarioUtilities.lua').GetMarkers(),
            playerArmies
        )
        resourcesSpawner.spawnResources()
    end

    local function setupAllFactions()
        local allFactions = vendorImport('lib/AllFactions.lua')

        if options.allFactionsIsEnabled() then
            for armyIndex in playerArmies.getIndexToNameMap() do
                allFactions.spawnExtraAcus(ArmyBrains[armyIndex])
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