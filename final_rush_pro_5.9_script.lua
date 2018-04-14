function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	import('/maps/final_rush_pro_5.9.v0001/src/frp/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()

	import('/lua/SimSync.lua')
end
