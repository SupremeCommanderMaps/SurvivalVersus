newInstance = function(ScenarioInfo, ScenarioFramework)
    local TableUnitID = {
        Tech1 = { "ual0201", "ual0103", "url0107", "url0103", "uel0201", "uel0103", "xsl0201", "xsl0103" },
        Tech2 = { "xal0203", "ual0202", "ual0111", "url0203", "url0202", "url0111", "drl0204", "uel0203", "del0204", "uel0202", "uel0111", "uel0303", "xsl0202", "xsl0203"},
        Tech2NoTml = { "xal0203", "ual0202", "ual0103", "url0203", "url0202", "xsl0203", "drl0204", "uel0203", "del0204", "uel0202", "uel0307", "uel0303", "xsl0202", "xsl0203", "uel0203"},
        Tech3 = { "ual0303", "xal0305", "xrl0305", "url0303", "xel0305", "xsl0303", "xsl0305"},
        Tech3NoSniper = { "ual0303", "xrl0305", "url0303", "xel0305", "xsl0303", "uel0303", "url0303", "xsl0202"},
        Aggro = { "ual0304", "url0304", "uel0304", "xsl0304", "dal0310" },
        AggroNoArty = { "ual0303", "xrl0305", "url0303", "xel0305", "dal0310" }
    }

    return {
        getRandomUnit = function(tech)
            if tech == 1 then
                return ScenarioFramework.GetRandomEntry(TableUnitID.Tech1)
            elseif tech == 2 then
                if (ScenarioInfo.Options.opt_t2tml == 0) then
                    return ScenarioFramework.GetRandomEntry(TableUnitID.Tech2)
                else
                    return ScenarioFramework.GetRandomEntry(TableUnitID.Tech2NoTml)
                end
            elseif tech == 3 then
                if (ScenarioInfo.Options.opt_snipers == 0) then
                    return ScenarioFramework.GetRandomEntry(TableUnitID.Tech3)
                else
                    return ScenarioFramework.GetRandomEntry(TableUnitID.Tech3NoSniper)
                end
            elseif tech == 4 then
                if (ScenarioInfo.Options.opt_t3arty == 0) then
                    return ScenarioFramework.GetRandomEntry(TableUnitID.Aggro)
                else
                    return ScenarioFramework.GetRandomEntry(TableUnitID.AggroNoArty)
                end
            end
        end
    }
end