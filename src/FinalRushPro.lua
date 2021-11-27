newInstance = function(ScenarioInfo)
    local function localImport(fileName)
        return import('/maps/survival_versus.v0028/src/' .. fileName)
    end

    local function vendorImport(fileName)
        return import('/maps/survival_versus.v0028/vendor/EntropyLib/src/' .. fileName)
    end

    local options = localImport('FinalRushOptions.lua').newInstance(ScenarioInfo.Options)
    ScenarioInfo.Options = options.getRawOptions()

    local textPrinter = vendorImport('TextPrinter.lua').newInstance()
    local playerArmies = localImport('PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = localImport('BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo, options)

    local welcomeMessages = localImport('WelcomeMessages.lua').newInstance(ScenarioInfo, options, textPrinter)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            localImport('PrebuildTents.lua')
                .newInstance(playerArmies)
                .spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        localImport('CivilianLighthouses.lua')
            .newInstance(textPrinter, playerArmies)
            .spawn()
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = localImport('TechRestrictor.lua').newInstance(
                buildRestrictor,
                textPrinter,
                playerArmies,
                ScenarioInfo.Options.opt_timeunlocked
            );

            techRestrictor.startRestrictedTechCascade()
        end
    end

    local function setupSurvival()
        localImport('survival/Survival.lua')
            .newInstance(ScenarioInfo, localImport, options, textPrinter, playerArmies)
            .start()
    end

    local function setupAutoReclaim()
        if options.getAutoReclaimPercentage() ~= 0 then
            ForkThread(
                localImport('AutoReclaim.lua').AutoReclaimThread,
                options,
                playerArmies
            )
        end
    end

    local function showWelcomeMessage()
        welcomeMessages.startDisplay()
    end

    local function setupResourceDeposits()
        local resourcesSpawner = localImport('ResourcesSpawner.lua').newInstance(
            vendorImport('ResourceCreator.lua').newInstance(),
            import('/maps/survival_versus.v0028/survival_versus_tables.lua'),
            import('/lua/sim/ScenarioUtilities.lua').GetMarkers(),
            playerArmies
        )
        resourcesSpawner.spawnResources()
    end

    local function setupAllFactions()
        local allFactions = vendorImport('AllFactions.lua')

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
            setupSurvival()
            setupAutoReclaim()
            showWelcomeMessage()
            setupAllFactions()
        end,
        printSettings = function()
            welcomeMessages.showSettings()
        end
    }
end