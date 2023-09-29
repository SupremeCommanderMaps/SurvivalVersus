newInstance = function()
    local makeInvincible = function(unit)
        unit:SetReclaimable(false)
        unit:SetCanTakeDamage(false)
        unit:SetDoNotTarget(true)
        unit:SetCanBeKilled(false)
        unit:SetCapturable(false)
    end

    local PARAGON = "xab1401"
    local T3RADAR = "uab3104"
    local T1RADAR = "uab3101"

    local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
    local topPos = ScenarioUtils.MarkerToPosition("SurvivalStructuresTop")
    local bottomPos = ScenarioUtils.MarkerToPosition("SurvivalStructuresBottom")

    local function configureOmni(omni)
        makeInvincible(omni)
        omni:SetIntelRadius('Vision', 500)
        omni:SetIntelRadius('WaterVision', 500)
        omni:SetIntelRadius('Omni', 500)

        omni:SetConsumptionPerSecondEnergy(0)
    end

    local function configureRadar(radar)
        makeInvincible(radar)
        radar:SetConsumptionPerSecondEnergy(0)
    end

    return {
        createTopParagon = function(owningArmyName)
            makeInvincible(CreateUnitHPR(PARAGON, owningArmyName, topPos[1], topPos[2], topPos[3], 0, 0, 0))
        end,
        createBottomParagon = function(owningArmyName)
            makeInvincible(CreateUnitHPR(PARAGON, owningArmyName, bottomPos[1], bottomPos[2], bottomPos[3], 0, 0, 0))
        end,
        createTopRadar = function(owningArmyName)
            configureRadar(CreateUnitHPR(T1RADAR, owningArmyName, topPos[1], topPos[2], topPos[3], 0, 0, 0))
        end,
        createBottomRadar = function(owningArmyName)
            configureRadar(CreateUnitHPR(T1RADAR, owningArmyName, bottomPos[1], bottomPos[2], bottomPos[3], 0, 0, 0))
        end,
        createTopOmni = function(owningArmyName)
            configureOmni(CreateUnitHPR(T3RADAR, owningArmyName, topPos[1], topPos[2], topPos[3], 0, 0, 0))
        end,
        createBottomOmni = function(owningArmyName)
            configureOmni(CreateUnitHPR(T3RADAR, owningArmyName, bottomPos[1], bottomPos[2], bottomPos[3], 0, 0, 0))
        end
    }
end