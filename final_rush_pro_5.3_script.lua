function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	import('/maps/final_rush_pro_5.3.v0002/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()

	import('/lua/SimSync.lua')
end
