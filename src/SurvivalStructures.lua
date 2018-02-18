newInstance = function()
    local makeInvincible = function(unit)
        unit:SetReclaimable(false);
        unit:SetCanTakeDamage(false);
        unit:SetDoNotTarget(true);
        unit:SetCanBeKilled(false);
        unit:SetCapturable(false);
    end

    local function NoHillsClimbingBitches()
        local police1 = CreateUnitHPR( "ual0401", "ARMY_10", 493.739227, 65.536545, 493.537750, 0.000000, 0.671952, 0.000000)
        local police2 = CreateUnitHPR( "ual0401", "ARMY_10", 477.215668, 65.875885, 477.170502, 0.000000, 0.733038, 0.000000)
        local police3 = CreateUnitHPR( "ual0401", "ARMY_10", 438.233734, 63.601822, 494.937134, 0.000000, -0.497419, 0.000000)
        local police4 = CreateUnitHPR( "ual0401", "ARMY_10", 495.536011, 62.919582, 438.201752, 0.000000, 2.487095, 0.000000)

        local police5 = CreateUnitHPR( "ual0401", "ARMY_10", 17.379473, 65.951057, 17.682734, 0.000000, -2.417280, 0.000000)
        local police6 = CreateUnitHPR( "ual0401", "ARMY_10", 35.684875, 65.957329, 35.915600, 0.000000, 0.654499, 0.000000)
        local police7 = CreateUnitHPR( "ual0401", "ARMY_10", 15.666634, 62.922352, 72.599403, 0.000000, 0.000000, 0.000000)
        local police8 = CreateUnitHPR( "ual0401", "ARMY_10", 74.871712, 63.439056, 16.922817, 0.000000, 1.439896, 0.000000)

        makeInvincible(police1)
        makeInvincible(police2)
        makeInvincible(police3)
        makeInvincible(police4)
        makeInvincible(police5)
        makeInvincible(police6)
        makeInvincible(police7)
        makeInvincible(police8)

        police1:SetCustomName("Hill Guards")
        police2:SetCustomName("Hill Guards")
        police3:SetCustomName("Hill Guards")
        police4:SetCustomName("Hill Guards")
        police5:SetCustomName("Hill Guards")
        police6:SetCustomName("Hill Guards")
        police7:SetCustomName("Hill Guards")
        police8:SetCustomName("Hill Guards")
    end

    return {
        createRadars = function()
            local radar1 = CreateUnitHPR("uab3104", "ARMY_9", 0, 0, 0, 0,0,0)
            local radar2 = CreateUnitHPR("uab3104", "NEUTRAL_CIVILIAN", 512, 0, 512, 0,0,0)

            makeInvincible(radar1)
            makeInvincible(radar2)
        end,
        createParagons = function()
            local para1 = CreateUnitHPR("xab1401", "ARMY_9", 0, 0, 0, 0,0,0)
            local para2 = CreateUnitHPR("xab1401", "NEUTRAL_CIVILIAN", 512, 0, 512, 0,0,0)

            makeInvincible(para1)
            makeInvincible(para2)
        end,
        createHillGuards = NoHillsClimbingBitches
    }
end