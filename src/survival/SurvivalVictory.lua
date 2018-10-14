function newInstance(options, textPrinter, playerArmies)
    local deathEvents = import('/maps/final_rush_pro_5.v0019/src/survival/DeathEvents.lua').newInstance(playerArmies)
    deathEvents.startMonitoring()

    local finalStageWasReached = false

    local function teamFightIsOngoing()
        LOG("SurvivalVictory: teamFightIsOngoing")
        if options.isSurvivalClassic() then
           return false
        end

        return deathEvents.topTeamIsAlive() and deathEvents.bottomTeamIsAlive()
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

    local function endGameAfterSeconds(seconds)
        deathEvents.stopMonitoring()
        ForkThread(function()
            WaitSeconds(seconds)
            EndGame()
        end)
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

    return {
        finalStageComplete = function()
            LOG("SurvivalVictory: finalStageComplete")
            finalStageWasReached = true

            if options.isSurvivalClassic() then
                printCongratsAndEndGame()
            elseif teamFightIsOngoing() then
                printWaveContinues()

                deathEvents.onTeamDeath(function()
                    printTeamVictoryAndEndGame()
                end)
            else
                printTeamVictoryAndEndGame()
            end
        end,
        watchForTeamDeath = function()
            local isFirstTeamDeath = true

            if options.isSurvivalVersus() then
                deathEvents.onTeamDeath(function(teamName)
                    LOG("SurvivalVictory: watchForTeamDeath")
                    if not finalStageWasReached then
                        if isFirstTeamDeath then
                            isFirstTeamDeath = false
                            textPrinter.print(
                                teamName == "TOP" and "BOTTOM TEAM VICTORY" or "TOP TEAM VICTORY",
                                {
                                    duration = 8.5,
                                    size = 30,
                                    color = "ffffd4d4"
                                }
                            )
                            textPrinter.print(
                                "You can keep playing to try and beat the final stage",
                                {
                                    duration = 8.5,
                                    size = 20,
                                    color = "ffffd4d4"
                                }
                            )
                        else
                            textPrinter.print(
                                "You won but did not beat the final stage",
                                {
                                    duration = 6,
                                    size = 25,
                                    color = "ffffd4d4"
                                }
                            )
                            endGameAfterSeconds(7)
                        end
                    end
                end)
            end
        end
    }
end

