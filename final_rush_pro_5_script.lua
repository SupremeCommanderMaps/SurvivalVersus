function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	import('/maps/final_rush_pro_5.v0017/src/frp/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()
end

--                    local keyset={}
--                    for k in pairs(unit.originalBuilder) do
--                        table.insert(keyset, k)
--                    end
--                    LOG(repr(keyset))