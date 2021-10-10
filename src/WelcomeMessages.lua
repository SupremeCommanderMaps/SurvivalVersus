newInstance = function(ScenarioInfo, options, textPrinter)
    local WELCOME_MESSAGE_DURATION = 9
    local SETTINGS_MESSAGE_DURATION = 14
    local BONUS_MESSAGE_DURATION = 6

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
        local difficultyNames = {
            [1] = "Very easy",
            [2] = "Easier",
            [3] = "Easy",
            [4] = "Normal",
            [5] = "Hard",
            [6] = "Harder",
            [7] = "Very hard",
            [8] = "Insane",
        }

        return difficultyNames[ScenarioInfo.Options.opt_FinalRushDifficulty]
    end

    local function showGameVersionMessage(printer)
        textPrinter.print(
            string.rep(" ", 12) .. "Welcome to Survival Versus v" .. ScenarioInfo.map_version,
            { color = "ffafdde4", duration = WELCOME_MESSAGE_DURATION, location = "leftcenter", size = 35 }
        )

        textPrinter.print(
            string.rep(" ", 41) .. "by EntropyWins",
            { color = "ffafdde4", duration = WELCOME_MESSAGE_DURATION, location = "leftcenter" }
        )

        printer.printBlankLine()

        printer.printOption("opt_gamemode", "Game mode: " .. getGameMode())

        if options.isParagonWars() then
            printer.print("Civilian base: 100% Morgan Certified™")
        end

        printer.printBlankLine()

        printer.print("Docs at bit.ly/final-rush-pro")
    end

    local function showGameSettingsMessage(printer)
        printer.printBlankLine()
        printer.printBlankLine()

        if ScenarioInfo.Options.opt_FinalRushAir ~= 0 then
            printer.printOption("opt_FinalRushAir", "Player air is ON")
        else
            printer.printBlankLine()
        end

        if options.shouldDisableNukesAndArty() then
            printer.printBlankLine()
        else
            printer.printOption("opt_FinalRushNukesAndArty", "Player nukes and T3/T4 arty are ON")
        end

        printer.printOption("opt_FinalRushWaterKillsACUs", "Can hide ACU: " .. (options.waterKillsAcu() and "no" or "yes"))
        printer.printOption("opt_FinalRushKillableTransports", "Can kill transports: " .. (options.canKillTransports() and "yes" or "no"))

        printer.printBlankLine()

        printer.printOption("opt_FinalRushDifficulty", "Difficulty preset: " .. getDifficuly())
        printer.printOption("opt_FinalRushEscalationSpeed", "Escalation speed: " .. ScenarioInfo.Options.opt_FinalRushEscalationSpeed / 60 .. " minutes/stage")
        printer.printOption("opt_FinalRushUnitCount", "Unit count: " .. ScenarioInfo.Options.opt_FinalRushUnitCount * 100 .. "%")
        printer.printOption("opt_FinalRushHealthIncrease", "Health increase: " .. ScenarioInfo.Options.opt_FinalRushHealthIncrease * 100 .. "% every 100 seconds")
        printer.printOption(
            "opt_FinalRushAutoReclaim",
            "Auto reclaim: "
                    .. (options.autoRelciamDeclines() and "declining " or "fixed ")
                    .. math.abs(ScenarioInfo.Options.opt_FinalRushAutoReclaim) .. "%"
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

    local function showTeamBonusMessage(printer)
        printer.printBlankLine()
        printer.printBlankLine()
        printer.printBlankLine()

        if ScenarioInfo.Options.opt_FinalRushTeamBonusHP ~= 0 then
            printer.printOption(
                "opt_FinalRushTeamBonusHP",
                "HP bonus: units " .. math.abs( ScenarioInfo.Options.opt_FinalRushTeamBonusHP ) .. "% weaker for the "
                        .. ( ScenarioInfo.Options.opt_FinalRushTeamBonusHP > 0 and "top team" or "bottom team" )
            )
        end

        if ScenarioInfo.Options.opt_FinalRushTeamBonusReclaim ~= 0 then
            printer.printOption(
                "opt_FinalRushTeamBonusReclaim",
                "Reclaim bonus: extra " .. math.abs( ScenarioInfo.Options.opt_FinalRushTeamBonusReclaim ) .. "% for the "
                        .. ( ScenarioInfo.Options.opt_FinalRushTeamBonusReclaim > 0 and "top team" or "bottom team" )
            )
        end
    end

    return {
        startDisplay = function()
            ForkThread(function()
                showGameVersionMessage(newPrinter(WELCOME_MESSAGE_DURATION))

                if options.isSurvivalGame() then
                    WaitSeconds(WELCOME_MESSAGE_DURATION + 0.05)
                    showGameSettingsMessage(newPrinter(SETTINGS_MESSAGE_DURATION))

                    WaitSeconds(SETTINGS_MESSAGE_DURATION + 0.05)
                    showTeamBonusMessage(newPrinter(BONUS_MESSAGE_DURATION))
                end
            end)
        end,
        showSettings = function()
            if options.isSurvivalGame() then
                ForkThread(function()
                    showGameSettingsMessage(newPrinter(SETTINGS_MESSAGE_DURATION))

                    WaitSeconds(SETTINGS_MESSAGE_DURATION + 0.05)
                    showTeamBonusMessage(newPrinter(BONUS_MESSAGE_DURATION))
                end)
            end
        end
    }
end