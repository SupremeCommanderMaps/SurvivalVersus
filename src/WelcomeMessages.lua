newInstance = function(ScenarioInfo, options, textPrinter)
    local function newPrinter(durationInSeconds)
        local textOptions = {color = "ffb4ffd4", duration = durationInSeconds, location = "leftcenter" }

        return {
            print = function(text)
                textPrinter.print(string.rep( " ", 20 ) .. text, textOptions)
            end,
            printBlankLine = function()
                textPrinter.printBlankLine(textOptions)
            end
        }
    end

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

    local function showGameVersionMessage(printer)
        local headerOptions = {color = "ffa4dde4", duration = 7, location = "leftcenter", size = 35 }
        textPrinter.print(string.rep( " ", 12 ) .. "Welcome to Final Rush Pro 5.3", headerOptions)

        printer.print("Version 5.x by EntropyWins")

        printer.printBlankLine()

        printer.print("Game mode: " ..  getGameMode())

        if options.isParagonWars() then
            printer.print("Civilian base: 100% Morgan Certified™")
        end

        printer.printBlankLine()

        printer.print("Docs at bit.ly/final-rush-pro")
    end

    local function showGameSettingsMessage(printer)
        if not options.isSurvivalGame() then
            return
        end

        printer.printBlankLine()
        printer.printBlankLine()
        printer.printBlankLine()

        if ScenarioInfo.Options.opt_FinalRushAir ~= 0 then
            printer.print("Player air is ON")
        else
            printer.printBlankLine()
        end

        printer.print("Water kills ACU: " .. ( options.waterKillsAcu() == 0 and "no" or "yes" ))
        printer.print("Can kill transports: " .. ( options.canKillTransports() == 0 and "yes" or "no" ))

        printer.printBlankLine()

        printer.print("Difficulty preset: " ..  getDifficuly())
        printer.print("Auto reclaim: " ..  ScenarioInfo.Options.opt_AutoReclaim .. "%")
        printer.print("Health increase: " ..  ScenarioInfo.Options.opt_FinalRushHealthIncrease * 100 .. "% every 100 seconds")

        printer.printBlankLine()

        printer.print(
            "Spawn delay: T1 after " ..  ScenarioInfo.Options.opt_FinalRushSpawnDelay .. "s, "
                    .. "T2 " .. ScenarioInfo.Options.opt_FinalRushT2Delay / 60 .. "m, "
                    .. "T3 " .. ScenarioInfo.Options.opt_FinalRushT3Delay / 60 .. "m, "
                    .. "T4 " .. ScenarioInfo.Options.opt_FinalRushT4Delay / 60 .. "m"
        )

        printer.print(
            "Spawn frequency: T1 every " ..  ScenarioInfo.Options.opt_FinalRushT1Frequency .. "s, "
                    .. "T2 " .. ScenarioInfo.Options.opt_FinalRushT2Frequency .. "s, "
                    .. "T3 " .. ScenarioInfo.Options.opt_FinalRushT3Frequency .. "s, "
                    .. "T4 " .. ScenarioInfo.Options.opt_FinalRushT4Frequency .. "s"
        )

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
    end

    return {
        startDisplay = function()
            ForkThread(function()
                showGameVersionMessage(newPrinter(7))
                WaitSeconds(7.01)
                showGameSettingsMessage(newPrinter(13))
            end)
        end
    }
end