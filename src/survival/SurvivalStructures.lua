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
            makeInvincible(CreateUnitHPR(PARAGON, owningArmyName, 0, 0, 0, 0, 0, 0))
        end,
        createBottomParagon = function(owningArmyName)
            makeInvincible(CreateUnitHPR(PARAGON, owningArmyName, 512, 0, 512, 0, 0, 0))
        end,
        createTopRadar = function(owningArmyName)
            configureRadar(CreateUnitHPR(T1RADAR, owningArmyName, 0, 0, 0, 0, 0, 0))
        end,
        createBottomRadar = function(owningArmyName)
            configureRadar(CreateUnitHPR(T1RADAR, owningArmyName, 512, 0, 512, 0, 0, 0))
        end,
        createTopOmni = function(owningArmyName)
            configureOmni(CreateUnitHPR(T3RADAR, owningArmyName, 0, 0, 0, 0, 0, 0))
        end,
        createBottomOmni = function(owningArmyName)
            configureOmni(CreateUnitHPR(T3RADAR, owningArmyName, 512, 0, 512, 0, 0, 0))
        end
    }
end