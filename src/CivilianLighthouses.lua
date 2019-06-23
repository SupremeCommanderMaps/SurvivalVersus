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

        lighthouse:SetCustomName("Such NSA")

        local setupLightouse

        setupLightouse = function(unit)
            preventDamage(unit)

            ScenarioFramework.CreateUnitCapturedTrigger(
                nil,
                function(newUnit)
                    setupLightouse(newUnit)
                    printText("Converted to Christianity", 3)
                end,
                unit
            )

            unit.OnStartBeingCaptured = function()
                printText("Wolololo", 2)
            end

            unit.OnFailedBeingCaptured = function()
                printText("Nope.jpg", 2)
            end
        end

        setupLightouse(lighthouse)
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
                CreateUnitHPR("urc1901", "TOP_BOT", 13.816323, 25.730654, 500.078125, 0,0,0),
                "leftcenter"
            )

            initializeLighthouse(
                CreateUnitHPR("urc1901", "BOTTOM_BOT", 498.060150, 25.724628, 12.122614, 0,0,0),
                "rightcenter"
            )
        end
    }
end