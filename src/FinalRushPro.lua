newInstance = function(ScenarioInfo)
    local textPrinter = import('/maps/Final Rush Pro 5/src/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/Final Rush Pro 5/src/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/Final Rush Pro 5/src/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            local tents = import('/maps/Final Rush Pro 5/src/PrebuildTents.lua').newInstance(playerArmies);
            LOG("Spawning " .. ScenarioInfo.Options.opt_tents .. " tents")
            tents.spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/Final Rush Pro 5/src/CivilianLighthouses.lua').newInstance().spawn();
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/Final Rush Pro 5/src/TechRestrictor.lua').newInstance(
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
            local paragonWars = import('/maps/Final Rush Pro 5/src/ParagonWars.lua').newInstance(playerArmies, textPrinter)
            paragonWars.setUp()
        end
    end

    local function setupServival()
        if ScenarioInfo.Options.opt_gamemode == 0 or ScenarioInfo.Options.opt_gamemode == 1 then
            local survival = import('/maps/Final Rush Pro 5/src/Survival.lua').newInstance(ScenarioInfo, textPrinter, playerArmies)
            survival.start()
        end
    end

    local function setupAutoReclaim()
        if ScenarioInfo.Options.opt_AutoReclaim > 0 then
            ForkThread(import('/maps/Final Rush Pro 5/src/AutoReclaim.lua').AutoResourceThread)
        end
    end

    local function showWelcomeMessage()
        ForkThread(function()
            local modeNames = {
                [0] = "Survival Versus",
                [1] = "Survival Classic",
                [2] = "Paragon Wars",
                [3] = "Nothing Special",
            }

            local difficulyNames = {
                [1] = "Very easy",
                [2] = "Easy",
                [3] = "Normal",
                [4] = "Hard",
                [5] = "Insane",
            }

            local textColor = "ffb4ffd4"
            local duration = 9

            textPrinter.print("Welcome to Final Rush Pro 5", {size = 35, color = textColor, duration = duration})
            textPrinter.printBlankLine()
            textPrinter.print("Game mode: " ..  modeNames[ScenarioInfo.Options.opt_gamemode], {color = textColor, duration = duration})
            textPrinter.print("Difficulty: " ..  difficulyNames[ScenarioInfo.Options.opt_FinalRushDifficulty], {color = textColor, duration = duration})
            textPrinter.printBlankLine()
            textPrinter.print("Docs at bit.ly/final-rush-pro", {color = textColor, duration = duration})
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