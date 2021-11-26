function newInstance(options, textPrinter, playerArmies, notifier)
    local deathEvents = import('/maps/survival_versus.v0027/src/survival/DeathEvents.lua').newInstance(playerArmies)
    deathEvents.startMonitoring()

    local finalStageWasCompleted = false

    local function teamFightIsOngoing()
        LOG("SurvivalVictory: teamFightIsOngoing")
        --if options.isSurvivalClassic() then
        --   return false
        --end

        return deathEvents.topTeamIsAlive() and deathEvents.bottomTeamIsAlive()
    end

    local function endGameAfterSeconds(seconds)
        deathEvents.stopMonitoring()
        ForkThread(function()
            WaitSeconds(seconds)
            EndGame()
        end)
    end

    local function printTeamVictoryAndEndGame()
        LOG("SurvivalVictory: printTeamVictoryAndEndGame")
        textPrinter.print(
            deathEvents.topTeamIsAlive() and "TOP TEAM FULL VICTORY" or "BOTTOM TEAM FULL VICTORY",
            {
                duration = 6,
                size = 25,
                color = "ffffd4d4"
            }
        )

        for _, army in ListArmies() do
            GetArmyBrain(army):OnVictory()
        end

        endGameAfterSeconds(7)
    end

    local function printWaveContinues()
        LOG("SurvivalVictory: printWaveContinues")
        textPrinter.print(
            "Final stage continues till one team wins",
            {
                duration = 6,
                size = 25,
                color = "ffffd4d4"
            }
        )
    end

    local function printCongratsAndEndGame()
        LOG("SurvivalVictory: printCongratsAndEndGame")
        textPrinter.print(
            "You survived the final stage!",
            {
                duration = 6,
                size = 30,
                color = "ffffd4d4"
            }
        )

        for _, army in ListArmies() do
            GetArmyBrain(army):OnVictory()
        end

        endGameAfterSeconds(7)
    end

    local function printPartialVictory(deathTeamName)
        notifier.printMultiLine(
            {
                {
                    message = deathTeamName == "TOP" and "BOTTOM TEAM VICTORY" or "TOP TEAM VICTORY",
                    indent = 100,
                    options = {
                        duration = 10,
                        size = 30,
                        color = "ffffd4d4"
                    }
                },
                {
                    message = "You can keep playing to try and beat the final stage",
                    indent = 120,
                    options = {
                        duration = 10,
                        size = 20,
                        color = "ffffd4d4"
                    }
                }
            }
        )
    end

    local function grantVisionToDefeatedTeam()
        for topArmy in playerArmies.getTopSideArmies().getNameToIndexMap() do
            for bottomArmy in playerArmies.getBottomSideArmies().getNameToIndexMap() do
                SetAlliance(topArmy, bottomArmy, 'Ally')
            end
        end
    end

    local function printSecondTeamDefeat()
        textPrinter.print(
            "You won but did not beat the final stage",
            {
                duration = 6.5,
                size = 25,
                color = "ffffd4d4"
            }
        )
    end

    return {
        finalStageComplete = function()
            LOG("SurvivalVictory: finalStageComplete")
            finalStageWasCompleted = true

            --if options.isSurvivalClassic() then
            --    LOG("SurvivalVictory: finalStageComplete: is classic")
            --    printCongratsAndEndGame()
            --elseif teamFightIsOngoing() then
            if teamFightIsOngoing() then
                LOG("SurvivalVictory: finalStageComplete: ongoing fight")
                printWaveContinues()

                deathEvents.onTeamDeath(function()
                    printTeamVictoryAndEndGame()
                end)
            else
                LOG("SurvivalVictory: finalStageComplete: full victory")
                printTeamVictoryAndEndGame()
            end
        end,
        watchForTeamDeath = function()
            local isFirstTeamDeath = true

            deathEvents.onTeamDeath(function(teamName)
                LOG("SurvivalVictory: watchForTeamDeath")
                if finalStageWasCompleted then
                   return
                end

                if isFirstTeamDeath then
                    LOG("SurvivalVictory: partial victory")
                    isFirstTeamDeath = false

                    printPartialVictory(teamName)
                    grantVisionToDefeatedTeam()
                else
                    LOG("SurvivalVictory: You won but did not beat the final stage")
                    printSecondTeamDefeat()
                    endGameAfterSeconds(7)
                end
            end)
        end
    }
end

