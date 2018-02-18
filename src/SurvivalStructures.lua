newInstance = function()
    local makeInvincible = function(unit)
        unit:SetReclaimable(false)
        unit:SetCanTakeDamage(false)
        unit:SetDoNotTarget(true)
        unit:SetCanBeKilled(false)
        unit:SetCapturable(false)
    end

    local function configureRadar(radar)
--        radar:SetIntelRadius('Vision', 50)

        makeInvincible(radar)
    end

    return {
        createRadars = function()
            local radar1 = CreateUnitHPR("uab3104", "HOSTILE_BOT", 0, 0, 0, 0,0,0)
            local radar2 = CreateUnitHPR("uab3104", "HOSTILE_BOT", 512, 0, 512, 0,0,0)

            configureRadar(radar1)
            configureRadar(radar2)
        end,
        createParagons = function()
            local para1 = CreateUnitHPR("xab1401", "ARMY_9", 0, 0, 0, 0,0,0)
            local para2 = CreateUnitHPR("xab1401", "NEUTRAL_CIVILIAN", 512, 0, 512, 0,0,0)

            makeInvincible(para1)
            makeInvincible(para2)
        end
    }
end