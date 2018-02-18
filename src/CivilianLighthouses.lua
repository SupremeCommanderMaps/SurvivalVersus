newInstance = function(textPrinter)
    local ScenarioFramework = import('/lua/ScenarioFramework.lua')

    local function preventDamage(unit)
        unit:SetReclaimable(false)
        unit:SetCanTakeDamage(false)
        unit:SetDoNotTarget(true)
        unit:SetCanBeKilled(false)
        unit:SetMaxHealth(31337)
        unit:SetHealth(unit, 31337)
    end

    local function initializeLighthouse(lighthouse, textLocation)
        local printText = function(txt, durationInSeconds)
            textPrinter.print("     " .. txt .. "     ", {location = textLocation, duration = durationInSeconds})
        end

        preventDamage(lighthouse)

        ScenarioFramework.CreateUnitCapturedTrigger(
            nil,
            function(newUnit)
                preventDamage(newUnit)
                printText("Converted to Christianity", 3)
            end,
            lighthouse
        )

        lighthouse:SetCustomName("Such NSA")

        lighthouse.OnStartBeingCaptured = function()
            printText("Wolololo", 2)
        end

        lighthouse.OnFailedBeingCaptured = function()
            printText("Nope.jpg", 2)
        end
    end

    return {
        spawn = function()
            local bp = GetUnitBlueprintByName("urc1901")
--            bp.Description = "Description"
--            bp.Interface.HelpText = "HelpText"
            bp.Intel.VisionRadius = 290
            bp.Economy.BuildTime = 800
--            bp.Defense.MaxHealth = 3133742
--            bp.Defense.Health = 3133742

            initializeLighthouse(
                CreateUnitHPR("urc1901", "NEUTRAL_CIVILIAN", 13.816323, 25.730654, 500.078125, 0,0,0),
                "leftcenter"
            )

            initializeLighthouse(
                CreateUnitHPR("urc1901", "ARMY_9", 498.060150, 25.724628, 12.122614, 0,0,0),
                "rightcenter"
            )
        end
    }
end