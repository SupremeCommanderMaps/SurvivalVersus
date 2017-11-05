newInstance = function(ScenarioInfo)
    local options = import('/maps/final_rush_pro_5.2.v0001/src/FinalRushOptions.lua').newInstance(ScenarioInfo.Options)
    ScenarioInfo.Options = options.getRawOptions()

    local textPrinter = import('/maps/final_rush_pro_5.2.v0001/src/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/final_rush_pro_5.2.v0001/src/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/final_rush_pro_5.2.v0001/src/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            local tents = import('/maps/final_rush_pro_5.2.v0001/src/PrebuildTents.lua').newInstance(playerArmies);
            LOG("Spawning " .. ScenarioInfo.Options.opt_tents .. " tents")
            tents.spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/final_rush_pro_5.2.v0001/src/CivilianLighthouses.lua').newInstance(textPrinter, playerArmies).spawn();
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/final_rush_pro_5.2.v0001/src/TechRestrictor.lua').newInstance(
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
        if options.isParagonWars() then
            local paragonWars = import('/maps/final_rush_pro_5.2.v0001/src/ParagonWars.lua').newInstance(playerArmies, textPrinter)
            paragonWars.setUp()
        end
    end

    local function setupServival()
        if options.isSurvivalGame() then
            local survival = import('/maps/final_rush_pro_5.2.v0001/src/Survival.lua').newInstance(ScenarioInfo, options, textPrinter, playerArmies)
            survival.start()
        end
    end

    local function setupAutoReclaim()
        if ScenarioInfo.Options.opt_AutoReclaim > 0 then
            ForkThread(import('/maps/final_rush_pro_5.2.v0001/src/AutoReclaim.lua').AutoResourceThread)
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
            textPrinter.print(string.rep( " ", 12 ) .. "Welcome to Final Rush Pro 5.2 alpha", headerOptions)
            textPrinter.print(string.rep( " ", 20 ) .. "Version 5.x by EntropyWins", textOptions)

            textPrinter.printBlankLine(textOptions)

            textPrinter.print(string.rep( " ", 20 ) .. "Game mode: " ..  getGameMode(), textOptions)
            if options.isParagonWars() then
                textPrinter.print(string.rep( " ", 20 ) .. "Civilian base: 100% Morgan Certified™", textOptions)
            end

            textPrinter.printBlankLine(textOptions)

            textPrinter.print(string.rep( " ", 20 ) .. "Docs at bit.ly/final-rush-pro", textOptions)
        end)

        ForkThread(function()
            if options.isSurvivalGame() then
                WaitSeconds(10.01)

                local printer = {
                    print = function(text)
                        textPrinter.print(string.rep( " ", 20 ) .. text, textOptions)
                    end,
                    printBlankLine = function()
                        textPrinter.printBlankLine(textOptions)
                    end
                }

--                local printedText = ""
--                local printer = {
--                    print = function(text)
--                        printedText = printedText .. "\n" .. text .. " "
--                    end,
--                    printBlankLine = function()
--                        printedText = printedText .. "\n"
--                    end
--                }

                printer.print("Difficulty preset: " ..  getDifficuly())
                printer.print("Game mode: " ..  getGameMode())
                printer.print("Water kills ACU: " .. ( options.isSurvivalVersus() == 0 and "no" or "yes" ))
                printer.print("Can kill transports: " .. ( options.canKillTransports() == 0 and "yes" or "no" ))

                printer.printBlankLine()

                printer.print("Auto reclaim: " ..  ScenarioInfo.Options.opt_AutoReclaim .. "%")
                printer.print("Health increase: " ..  ScenarioInfo.Options.opt_FinalRushHealthIncrease * 100 .. "% every 100 seconds")

                printer.printBlankLine()

                printer.print("T1 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushSpawnDelay .. " seconds")
                printer.print("T2 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushT2Delay / 60 .. " minutes")
                printer.print("T3 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushT3Delay / 60 .. " minutes")
                printer.print("T4 spawn delay: " ..  ScenarioInfo.Options.opt_FinalRushT4Delay / 60 .. " minutes")

                printer.printBlankLine()

                printer.print("T1 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT1Frequency .. " seconds")
                printer.print("T2 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT2Frequency .. " seconds")
                printer.print("T3 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT3Frequency .. " seconds")
                printer.print("T4 frequency: every " ..  ScenarioInfo.Options.opt_FinalRushT4Frequency .. " seconds")

                printer.printBlankLine()

                if ScenarioInfo.Options.opt_FinalRushRandomEvents == 0 then
                    printer.print("No random events")
                else
                    printer.print(
                        "Random events every " ..  ScenarioInfo.Options.opt_FinalRushRandomEvents .. " seconds with"
                            .. ( ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and "" or " NO" ) .. " notifications"
                    )
                end

                if ScenarioInfo.Options.opt_FinalRushHunters == 0 then
                    printer.print("No bounty hunters")
                else
                    printer.print(
                        "Bounty hunters after " ..  ScenarioInfo.Options.opt_FinalRushHunterDelay / 60 .. " minutes, spawning every "
                            ..  ScenarioInfo.Options.opt_FinalRushHunters / 60 .. " minutes"
                    )
                end

--local d = CreateDialogue([[a kinda long is line that is kinda long ish
--MJHAU]], {"Close"}, "right")
--                LOG(repr(d))
--
--                d.OnButtonPressed = function(self, info)
--                    d.Width.Set(500)
--                    --d:Destroy()
--                end
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