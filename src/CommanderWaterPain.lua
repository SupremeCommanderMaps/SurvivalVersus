newInstance = function(getAllUnits)
    local killCommandUnitsOnLayer = function(layers)
        --get all units on the map
        local units = getAllUnits()
        --if there are units on the map
        if units and table.getn(units) > 0 then
            for _, unit in units do
                local delete = false

                --is the unit on one of the specified layers?
                for _, layer in layers do
                    if unit:GetCurrentLayer() == layer and EntityCategoryContains(categories.COMMAND, unit) then
                        delete = true
                    end
                end

                if delete then
                    if unit and not unit:IsDead() then
                        unit:SetHealth(unit ,unit:GetHealth() - (unit:GetMaxHealth() / 10))
                        if unit:GetHealth() < 10 then
                            unit:Kill()
                        end
                    end
                end
            end
        end
    end

    local function waterPainThread()
        while true do
            WaitSeconds(2)
            killCommandUnitsOnLayer({'Water','Seabed','Sub'})
        end
    end

    return {
        runThread = function()
            ForkThread(waterPainThread)
        end
    }
end