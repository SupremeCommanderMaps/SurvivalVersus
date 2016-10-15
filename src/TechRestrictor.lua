newInstance = function(buildRestrictor, textPrinter, playerArmies, unlockTimeInSeconds)
    local function disableNonT1()
        for armyIndex in playerArmies.getIndexToNameMap() do
            AddBuildRestriction(armyIndex, categories.TECH3)
            AddBuildRestriction(armyIndex, categories.TECH2)
            AddBuildRestriction(armyIndex, categories.EXPERIMENTAL)
        end
    end

    local enableT2 = function()
        LOG("Waiting for T2 - ", unlockTimeInSeconds)
        WaitSeconds(unlockTimeInSeconds)
        for armyIndex in playerArmies.getIndexToNameMap() do
            RemoveBuildRestriction(armyIndex, categories.TECH2)
        end
        buildRestrictor.resetToStartingRestrictions()
        textPrinter.print("Tech 2 enabled");
    end

    local enableT3 = function()
        LOG("Waiting for t3 - ", unlockTimeInSeconds * 2)
        WaitSeconds(unlockTimeInSeconds * 2)
        for armyIndex in playerArmies.getIndexToNameMap() do
            RemoveBuildRestriction(armyIndex, categories.TECH3)
        end
        buildRestrictor.resetToStartingRestrictions()
        textPrinter.print("Tech 3 enabled");
    end

    local enableEXP = function()
        LOG("Waiting for t4 - ", unlockTimeInSeconds * 3)
        WaitSeconds(unlockTimeInSeconds * 3)
        for armyIndex in playerArmies.getIndexToNameMap() do
            RemoveBuildRestriction(armyIndex, categories.EXPERIMENTAL)
        end
        buildRestrictor.resetToStartingRestrictions()
        textPrinter.print("Experimentals enabled");
    end

    return {
        startRestrictedTechCascade = function()
            disableNonT1()
            ForkThread(enableT2)
            ForkThread(enableT3)
            ForkThread(enableEXP)
        end
    }
end