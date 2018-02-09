newInstance = function(playerArmies, ScenarioInfo)
    local function enableUefTransportsAndScouts(index)
        AddBuildRestriction(index, categories.uea0103) --UEF T1 Attack Bomber: Scorcher
        AddBuildRestriction(index, categories.uea0102) --UEF T1 Interceptor: Cyclone
        AddBuildRestriction(index, categories.dea0202) --UEF T2 Fighter/Bomber: Janus
        AddBuildRestriction(index, categories.uea0203) --UEF T2 Gunship: Stinger
        AddBuildRestriction(index, categories.uea0204) --UEF T2 Torpedo Bomber: Stork
        AddBuildRestriction(index, categories.uea0304) --UEF T3 Strategic Bomber: Ambassador
        AddBuildRestriction(index, categories.uea0305) --UEF T3 Heavy Gunship: Broadsword
        AddBuildRestriction(index, categories.uea0303) --UEF T3 Air-Superiority Fighter: Wasp
    end

    local function enableSeraphimTransportsAndScouts(index)
        AddBuildRestriction(index, categories.xsa0103) --Seraphim T1 Attack Bomber: Sinnve
        AddBuildRestriction(index, categories.xsa0102) --Seraphim T1 Interceptor: Ia-atha
        AddBuildRestriction(index, categories.xsa0202) --Seraphim T2 Fighter/Bomber: Notha
        AddBuildRestriction(index, categories.xsa0203) --Seraphim T2 Gunship: Vulthoo
        AddBuildRestriction(index, categories.xsa0204) --Seraphim T2 Torpedo Bomber: Uosioz
        AddBuildRestriction(index, categories.xsa0303) --Seraphim T3 Air-Superiority Fighter: Iazyne
        AddBuildRestriction(index, categories.xsa0304) --Seraphim T3 Strategic Bomber: Sinntha
        AddBuildRestriction(index, categories.xsa0402) --Seraphim EX Experimental Bomber: Ahwassa
    end

    local function enableCybranTransportsAndScouts(index)
        AddBuildRestriction(index, categories.ura0103) --Cybran T1 Attack Bomber: Zeus
        AddBuildRestriction(index, categories.ura0102) --Cybran T1 Interceptor: Prowler
        AddBuildRestriction(index, categories.xra0105) --Cybran T1 Light Gunship: Jester
        AddBuildRestriction(index, categories.dra0202) --Cybran T2 Fighter/Bomber: Corsair
        AddBuildRestriction(index, categories.ura0203) --Cybran T2 Gunship: Renegade
        AddBuildRestriction(index, categories.ura0204) --Cybran T2 Torpedo Bomber: Cormorant
        AddBuildRestriction(index, categories.ura0303) --Cybran T3 Air Superiority Fighter: Gemini
        AddBuildRestriction(index, categories.xra0305) --Cybran T3 Heavy Gunship: Wailer
        AddBuildRestriction(index, categories.ura0304) --Cybran T3 Strategic Bomber: Revenant
        AddBuildRestriction(index, categories.ura0401) --Cybran EX Experimental Gunship: Soul Ripper
    end

    local function enableAeonTransportsAndScouts(index)
        AddBuildRestriction(index, categories.uaa0103) --Aeon T1 Attack Bomber: Shimmer
        AddBuildRestriction(index, categories.uaa0102) --Aeon T1 Interceptor: Conservator
        AddBuildRestriction(index, categories.xaa0202) --Aeon T2 Combat Fighter: Swift Wind
        AddBuildRestriction(index, categories.daa0206) --Aeon T2 Guided Missile: Mercy
        AddBuildRestriction(index, categories.uaa0203) --Aeon T2 Gunship: Specter
        AddBuildRestriction(index, categories.uaa0204) --Aeon T2 Torpedo Bomber: Skimmer
        AddBuildRestriction(index, categories.xaa0305) --Aeon T3 AA Gunship: Restorer
        AddBuildRestriction(index, categories.uaa0303) --Aeon T3 Air-Superiority Fighter: Corona
        AddBuildRestriction(index, categories.uaa0304) --Aeon T3 Strategic Bomber: Shocker
        AddBuildRestriction(index, categories.xaa0306) --Aeon T3 Torpedo Bomber: Solace
        AddBuildRestriction(index, categories.uaa0310) --Aeon EX Experimental Aircraft Carrier: CZAR
    end

    local function disableAirExceptTransportsAndScouts()
        for armyIndex in playerArmies.getIndexToNameMap() do
            RemoveBuildRestriction(index, categories.AIR)
            enableUefTransportsAndScouts(armyIndex)
            enableSeraphimTransportsAndScouts(armyIndex)
            enableCybranTransportsAndScouts(armyIndex)
            enableAeonTransportsAndScouts(armyIndex)
        end
    end

    local function resetStartingRestrictions()
        if ScenarioInfo.Options.RestrictedCategories ~= nil then
            for _, value in ScenarioInfo.Options.RestrictedCategories do
                for index in  ListArmies() do
                    if value == "PRODSC1" then
                        AddBuildRestriction(index, categories.PRODUCTSC1)
                    elseif value == "PRODFA" then
                        AddBuildRestriction(index, categories.PRODUCTFA)
                    elseif value == "PRODDL" then
                        -- AddBuildRestriction(index, categories.PRODUCTDL)
                    elseif value == "UEF" then
                        AddBuildRestriction(index, categories.UEF)
                    elseif value == "CYBRAN" then
                        AddBuildRestriction(index, categories.CYBRAN)
                    elseif value == "AEON" then
                        AddBuildRestriction(index, categories.AEON)
                    elseif value == "SERAPHIM" then
                        AddBuildRestriction(index, categories.SERAPHIM)
                    elseif value == "T1" then
                        AddBuildRestriction(index, categories.TECH1)
                    elseif value == "T2" then
                        AddBuildRestriction(index, categories.TECH2)
                    elseif value == "T3" then
                        AddBuildRestriction(index, categories.TECH3)
                    elseif value == "EXPERIMENTAL" then
                        AddBuildRestriction(index, categories.EXPERIMENTAL)
                    elseif value == "NAVAL" then
                        AddBuildRestriction(index, categories.NAVAL)
                    elseif value == "LAND" then
                        AddBuildRestriction(index, categories.LAND)
                    elseif value == "AIR" then
                        AddBuildRestriction(index, categories.AIR)
                    elseif value == "NUKE" then
                        AddBuildRestriction(index, categories.NUKE)
                        AddBuildRestriction(index, categories.ues0304) --UEF T3 Strategic Missile Submarine: Ace
                        AddBuildRestriction(index, categories.urs0304) --Cybran T3 Strategic Missile Submarine: Plan B
                        AddBuildRestriction(index, categories.uas0304) --Aeon T3 Strategic Missile Submarine: Silencer
                        AddBuildRestriction(index, categories.xsa0402) --Seraphim EX Experimental Bomber: Ahwassa
                        AddBuildRestriction(index, categories.xsb2401) --Seraphim EX Experimental Missile Launcher: Yolona Oss
                    elseif value == "GAMEENDERS" then
                        AddBuildRestriction(index, categories.uab2305)
                        AddBuildRestriction(index, categories.ueb2305)
                        AddBuildRestriction(index, categories.urb2305)
                        AddBuildRestriction(index, categories.xsb2305)
                        AddBuildRestriction(index, categories.xab2307)
                        AddBuildRestriction(index, categories.ueb2302)
                        AddBuildRestriction(index, categories.uab2302)
                        AddBuildRestriction(index, categories.urb2302)
                        AddBuildRestriction(index, categories.xsb2302)
                        AddBuildRestriction(index, categories.ues0304) --UEF T3 Strategic Missile Submarine: Ace
                        AddBuildRestriction(index, categories.urs0304) --Cybran T3 Strategic Missile Submarine: Plan B
                        AddBuildRestriction(index, categories.uas0304) --Aeon T3 Strategic Missile Submarine: Silencer
                        AddBuildRestriction(index, categories.xsa0402) --Seraphim EX Experimental Bomber: Ahwassa
                        AddBuildRestriction(index, categories.ueb2401) --UEF EX Experimental Artillery: Mavor
                        AddBuildRestriction(index, categories.url0401) --Cybran EX Experimental Mobile Rapid-Fire Artillery: Scathis
                        AddBuildRestriction(index, categories.xsb2401) --Seraphim EX Experimental Missile Launcher: Yolona Oss
                    elseif value == "BUBBLES" then
                        AddBuildRestriction(index, categories.SHIELD)
                    elseif value == "INTEL" then
                        AddBuildRestriction(index, categories.INTELLIGENCE)
                    elseif value == "SUPCOM" then
                        AddBuildRestriction(index, categories.SUBCOMMANDER)
                    elseif value == "FABS" then
                        AddBuildRestriction(index, categories.MASSFABRICATION)
                    elseif value == "xea0002" then
                        -- UEF sattelite
                        LOG('AddBuildRestriction(index, categories.xea0002)')
                        AddBuildRestriction(index, categories.xea0002)
                    end
                end
            end
        end
    end

    local function novaxIsEnabledInOptions()
        for _, value in ScenarioInfo.Options.RestrictedCategories do
            if value == "xea0002" then
                return false
            end
        end

        return true
    end

    return {
        resetToStartingRestrictions = function()
            resetStartingRestrictions()

            if ScenarioInfo.Options.opt_FinalRushAir == 1 then
                disableAirExceptTransportsAndScouts()
            end

            local enableNovax = novaxIsEnabledInOptions()

            for armyIndex in playerArmies.getIndexToNameMap() do
                if (ScenarioInfo.Options.opt_FinalRushAir == 0) then
                    AddBuildRestriction(armyIndex, categories.AIR)
                end

                if enableNovax then
                    RemoveBuildRestriction(armyIndex, categories.xea0002)
                end
            end
        end
    }
end