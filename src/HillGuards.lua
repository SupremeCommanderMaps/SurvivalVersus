newInstance = function()
    local OWNING_ARMY_NAME = "HOSTILE_BOT"

    local makeInvincible = function(unit)
        unit:SetReclaimable(false)
        unit:SetCanTakeDamage(false)
        unit:SetDoNotTarget(true)
        unit:SetCanBeKilled(false)
        unit:SetCapturable(false)
    end

    local function NoHillsClimbingBitches()
        local hillGuards = {
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 493.739227, 65.536545, 493.537750, 0.000000, 0.671952, 0.000000),
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 477.215668, 65.875885, 477.170502, 0.000000, 0.733038, 0.000000),
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 438.233734, 63.601822, 494.937134, 0.000000, -0.497419, 0.000000),
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 495.536011, 62.919582, 438.201752, 0.000000, 2.487095, 0.000000),

            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 17.379473, 65.951057, 17.682734, 0.000000, -2.417280, 0.000000),
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 35.684875, 65.957329, 35.915600, 0.000000, 0.654499, 0.000000),
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 15.666634, 62.922352, 72.599403, 0.000000, 0.000000, 0.000000),
            CreateUnitHPR( "ual0401", OWNING_ARMY_NAME, 74.871712, 63.439056, 16.922817, 0.000000, 1.439896, 0.000000)
        }

        for _, guard in hillGuards do
            makeInvincible(guard)
            guard:SetCustomName("Hill Guard")
        end
    end

    return {
        createHillGuards = function()
            NoHillsClimbingBitches()
        end
    }
end