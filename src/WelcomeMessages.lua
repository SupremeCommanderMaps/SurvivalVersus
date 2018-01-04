newInstance = function(ScenarioInfo, options, textPrinter)
    local WELCOME_MESSAGE_DURATION = 7
    local SETTINGS_MESSAGE_DURATION = 13

    local function newPrinter(durationInSeconds)
        local textOptions = { color = "ffb4ffd4", duration = durationInSeconds, location = "leftcenter" }
        local modifiedTextOptions = { color = "ffffd4d4", duration = durationInSeconds, location = "leftcenter" }

        local this = {}

        this.print = function(text)
            textPrinter.print(string.rep(" ", 20) .. text, textOptions)
        end

        this.printBlankLine = function()
            textPrinter.printBlankLine(textOptions)
        end

        this.printOption = function(optionName, text)
            textPrinter.print(string.rep(" ", 20) .. text, options.isNonDefault(optionName) and textOptions or modifiedTextOptions)
        end

        return this
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
        local headerOptions = { color = "ffa4dde4", duration = WELCOME_MESSAGE_DURATION, location = "leftcenter", size = 35 }
        textPrinter.print(string.rep(" ", 12) .. "Welcome to Final Rush Pro 5.4 ALPHA", headerOptions)

        printer.print("Version 5.x by EntropyWins")

        printer.printBlankLine()

        printer.printOption("opt_gamemode", "Game mode: " .. getGameMode())

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
            printer.printOption("opt_FinalRushAir", "Player air is ON")
        else
            printer.printBlankLine()
        end

        printer.printOption("opt_FinalRushWaterKillsACUs", "Can hide ACU: " .. (options.waterKillsAcu() and "no" or "yes"))
        printer.printOption("opt_FinalRushKillableTransports", "Can kill transports: " .. (options.canKillTransports() and "yes" or "no"))

        printer.printBlankLine()

        printer.printOption("opt_FinalRushDifficulty", "Difficulty preset: " .. getDifficuly())
        printer.printOption("opt_AutoReclaim", "Auto reclaim: " .. ScenarioInfo.Options.opt_AutoReclaim .. "%")
        printer.printOption("opt_FinalRushHealthIncrease", "Health increase: " .. ScenarioInfo.Options.opt_FinalRushHealthIncrease * 100 .. "% every 100 seconds")

        printer.printBlankLine()

        printer.printOption(
            "opt_FinalRushSpawnDelay",
            "Spawn delay: T1 after " .. ScenarioInfo.Options.opt_FinalRushSpawnDelay .. "s, "
                .. "T2 " .. ScenarioInfo.Options.opt_FinalRushT2Delay / 60 .. "m, "
                .. "T3 " .. ScenarioInfo.Options.opt_FinalRushT3Delay / 60 .. "m, "
                .. "T4 " .. ScenarioInfo.Options.opt_FinalRushT4Delay / 60 .. "m"
        )

        printer.printOption(
            "opt_FinalRushT1Frequency",
            "Spawn frequency: T1 every " .. ScenarioInfo.Options.opt_FinalRushT1Frequency .. "s, "
                .. "T2 " .. ScenarioInfo.Options.opt_FinalRushT2Frequency .. "s, "
                .. "T3 " .. ScenarioInfo.Options.opt_FinalRushT3Frequency .. "s, "
                .. "T4 " .. ScenarioInfo.Options.opt_FinalRushT4Frequency .. "s"
        )

        printer.printBlankLine()

        if ScenarioInfo.Options.opt_FinalRushRandomEvents == 0 then
            printer.printOption("opt_FinalRushRandomEvents", "No random events")
        else
            printer.printOption("opt_FinalRushRandomEvents", "Random events every " .. ScenarioInfo.Options.opt_FinalRushRandomEvents .. " seconds with"
                    .. (ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and "" or " NO") .. " notifications")
        end

        if ScenarioInfo.Options.opt_FinalRushHunters == 0 then
            printer.printOption("opt_FinalRushHunters", "No bounty hunters")
        else
            printer.printOption("opt_FinalRushHunters", "Bounty hunters after " .. ScenarioInfo.Options.opt_FinalRushHunterDelay / 60 .. " minutes, spawning every "
                    .. ScenarioInfo.Options.opt_FinalRushHunters / 60 .. " minutes")
        end
    end

    return {
        startDisplay = function()
            ForkThread(function()
                showGameVersionMessage(newPrinter(WELCOME_MESSAGE_DURATION))
                WaitSeconds(WELCOME_MESSAGE_DURATION + 0.01)
                showGameSettingsMessage(newPrinter(SETTINGS_MESSAGE_DURATION))
            end)
        end
    }
end