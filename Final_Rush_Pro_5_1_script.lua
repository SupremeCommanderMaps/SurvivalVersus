function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()

	local Options = import('/maps/final_rush_pro_5_1.v0001/src/FinalRushOptions.lua')
	ScenarioInfo.Options = Options.applyPresets(Options.defaultOptions(ScenarioInfo.Options))

	import('/maps/final_rush_pro_5_1.v0001/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()
end
