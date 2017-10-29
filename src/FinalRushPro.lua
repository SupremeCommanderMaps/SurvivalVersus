newInstance = function(ScenarioInfo)
    local textPrinter = import('/maps/final_rush_pro_5.1.v0003/src/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/final_rush_pro_5.1.v0003/src/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/final_rush_pro_5.1.v0003/src/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            local tents = import('/maps/final_rush_pro_5.1.v0003/src/PrebuildTents.lua').newInstance(playerArmies);
            LOG("Spawning " .. ScenarioInfo.Options.opt_tents .. " tents")
            tents.spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/final_rush_pro_5.1.v0003/src/CivilianLighthouses.lua').newInstance(textPrinter, playerArmies).spawn();
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/final_rush_pro_5.1.v0003/src/TechRestrictor.lua').newInstance(
                buildRestrictor,
                textPrinter,
                playerArmies,
                ScenarioInfo.Options.opt_timeunlocked
            );

            techRestrictor.startRestrictedTechCascade()
        end
    end

    local function restrictTeleporation()
        if ScenarioInfo.Options.opt_Teleport == 1 then
            ScenarioFramework.RestrictEnhancements({'Teleporter'})
        end
    end

    local function setupParagonWars()
        if ScenarioInfo.Options.opt_gamemode == 2 then
            local paragonWars = import('/maps/final_rush_pro_5.1.v0003/src/ParagonWars.lua').newInstance(playerArmies, textPrinter)
            paragonWars.setUp()
        end
    end

    local function setupServival()
        if ScenarioInfo.Options.opt_gamemode == 0 or ScenarioInfo.Options.opt_gamemode == 1 then
            local survival = import('/maps/final_rush_pro_5.1.v0003/src/Survival.lua').newInstance(ScenarioInfo, textPrinter, playerArmies)
            survival.start()
        end
    end

    local function setupAutoReclaim()
        if ScenarioInfo.Options.opt_AutoReclaim > 0 then
            ForkThread(import('/maps/final_rush_pro_5.1.v0003/src/AutoReclaim.lua').AutoResourceThread)
        end
    end

    local function showWelcomeMessage()
        local getGameMode = function()
            local modeNames = {
                [0] = "Survival Versus",
                [1] = "Survival Classic",
                [2] = "Paragon Wars",
                [3] = "Nothing Special",
            }

            return modeNames[ScenarioInfo.Options.opt_gamemode]
        end

        local getDifficuly = function()
            local difficulyNames = {
                [1] = "Very easy",
                [2] = "Easy",
                [3] = "Normal",
                [4] = "Hard",
                [5] = "Insane",
            }

            return difficulyNames[ScenarioInfo.Options.opt_FinalRushDifficulty]
        end

        local headerOptions = {color = "ffb4ffd4", duration = 10, location = "leftcenter", size = 35 }
        local textOptions = {color = "ffb4ffd4", duration = 10, location = "leftcenter" }

        ForkThread(function()
            textPrinter.print(string.rep( " ", 12 ) .. "Welcome to Final Rush Pro 5.1", headerOptions)
            textPrinter.print(string.rep( " ", 20 ) .. "Version 5.x by EntropyWins", textOptions)

            textPrinter.printBlankLine(textOptions)

            textPrinter.print(string.rep( " ", 20 ) .. "Game mode: " ..  getGameMode(), textOptions)
            if ScenarioInfo.Options.opt_gamemode == 2 then
                textPrinter.print(string.rep( " ", 20 ) .. "Civilian base: 100% Morgan Certified™", textOptions)
            end

            textPrinter.printBlankLine(textOptions)

            textPrinter.print(string.rep( " ", 20 ) .. "Docs at bit.ly/final-rush-pro", textOptions)
        end)

        ForkThread(function()
            if ScenarioInfo.Options.opt_gamemode == 0 or ScenarioInfo.Options.opt_gamemode == 1 then
                WaitSeconds(10.01)
                textOptions.size = 18
                textOptions.duration = 21

                textPrinter.print(string.rep( " ", 20 ) .. "Difficulty preset: " ..  getDifficuly(), textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "Game mode: " ..  getGameMode(), textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "Water kills ACU: " .. ( ScenarioInfo.Options.opt_gamemode == 0 and "no" or "yes" ), textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "Can kill transports: " .. ( ScenarioInfo.Options.opt_gamemode == 0 and "yes" or "no" ), textOptions)

                textPrinter.printBlankLine(textOptions)

                textPrinter.print(string.rep( " ", 20 ) .. "Auto reclaim: " ..  ScenarioInfo.Options.opt_AutoReclaim .. "%", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "Health increase: " ..  ScenarioInfo.Options.opt_FinalRushHealthIncrease * 100 .. "% every 100 seconds", textOptions)

                textPrinter.printBlankLine(textOptions)

                textPrinter.print(string.rep( " ", 20 ) .. "T1 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushSpawnDelay .. " seconds", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "T2 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushT2Delay / 60 .. " minutes", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "T3 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushT3Delay / 60 .. " minutes", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "T4 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushT4Delay / 60 .. " minutes", textOptions)

                textPrinter.printBlankLine(textOptions)

                textPrinter.print(string.rep( " ", 20 ) .. "T1 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT1Frequency .. " seconds", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "T2 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT2Frequency .. " seconds", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "T3 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT3Frequency .. " seconds", textOptions)
                textPrinter.print(string.rep( " ", 20 ) .. "T4 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT4Frequency .. " seconds", textOptions)

                textPrinter.printBlankLine(textOptions)

                if ScenarioInfo.Options.opt_FinalRushRandomEvents == 0 then
                    textPrinter.print(string.rep( " ", 20 ) .. "No random events", textOptions)
                else
                    textPrinter.print(
                        string.rep( " ", 20 ) .. "Random events every " ..  ScenarioInfo.Options.opt_FinalRushRandomEvents .. " seconds with"
                            .. ( ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and "" or " NO" ) .. " notifications",
                        textOptions
                    )
                end

                if ScenarioInfo.Options.opt_FinalRushHunters == 0 then
                    textPrinter.print(string.rep( " ", 20 ) .. "No bounty hunters", textOptions)
                else
                    textPrinter.print(
                        string.rep( " ", 20 ) .. "Bounty hunters after " ..  ScenarioInfo.Options.opt_FinalRushHunterDelay / 60 .. " minutes, spawning every "
                            ..  ScenarioInfo.Options.opt_FinalRushHunters / 60 .. " minutes",
                        textOptions
                    )
                end
            end
        end)

    end

    return {
        setUp = function()
            showWelcomeMessage()
            buildRestrictor.resetToStartingRestrictions()
            setupTents()
            setupLighthouses()
            restrictTechs()
            restrictTeleporation()
            setupParagonWars()
            setupServival()
            setupAutoReclaim()
        end
    }
end