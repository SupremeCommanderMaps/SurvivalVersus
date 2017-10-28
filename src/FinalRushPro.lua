newInstance = function(ScenarioInfo)
    local textPrinter = import('/maps/Final_Rush_Pro_5.v0001/src/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/Final_Rush_Pro_5.v0001/src/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/Final_Rush_Pro_5.v0001/src/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            local tents = import('/maps/Final_Rush_Pro_5.v0001/src/PrebuildTents.lua').newInstance(playerArmies);
            LOG("Spawning " .. ScenarioInfo.Options.opt_tents .. " tents")
            tents.spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/Final_Rush_Pro_5.v0001/src/CivilianLighthouses.lua').newInstance(textPrinter, playerArmies).spawn();
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/Final_Rush_Pro_5.v0001/src/TechRestrictor.lua').newInstance(
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
            local paragonWars = import('/maps/Final_Rush_Pro_5.v0001/src/ParagonWars.lua').newInstance(playerArmies, textPrinter)
            paragonWars.setUp()
        end
    end

    local function setupServival()
        if ScenarioInfo.Options.opt_gamemode == 0 or ScenarioInfo.Options.opt_gamemode == 1 then
            local survival = import('/maps/Final_Rush_Pro_5.v0001/src/Survival.lua').newInstance(ScenarioInfo, textPrinter, playerArmies)
            survival.start()
        end
    end

    local function setupAutoReclaim()
        if ScenarioInfo.Options.opt_AutoReclaim > 0 then
            ForkThread(import('/maps/Final_Rush_Pro_5.v0001/src/AutoReclaim.lua').AutoResourceThread)
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

        ForkThread(function()
            local headerOptions = {color = "ffb4ffd4", duration = 11, location = "leftcenter", size = 35 }
            local textOptions = {color = "ffb4ffd4", duration = 11, location = "leftcenter" }

            textPrinter.print(string.rep( " ", 12 ) .. "Welcome to Final Rush Pro 5", headerOptions)
            textPrinter.printBlankLine(textOptions)
            textPrinter.print(string.rep( " ", 20 ) .. "Game mode: " ..  getGameMode(), textOptions)
			
			if ScenarioInfo.Options.opt_gamemode < 2 then
				textPrinter.print(string.rep( " ", 20 ) .. "Difficulty: " ..  getDifficuly(), textOptions)
			end
			
			if ScenarioInfo.Options.opt_gamemode == 2 then
				textPrinter.print(string.rep( " ", 20 ) .. "Civilian base: 100% Morgan Certified™", textOptions)
			end
            
            textPrinter.printBlankLine(textOptions)
            textPrinter.print(string.rep( " ", 20 ) .. "Docs at bit.ly/final-rush-pro", textOptions)
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