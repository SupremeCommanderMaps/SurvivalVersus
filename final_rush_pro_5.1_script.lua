function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()

	local Options = import('/maps/final_rush_pro_5.1.v0003/src/FinalRushOptions.lua')
	ScenarioInfo.Options = Options.applyPresets(Options.defaultOptions(ScenarioInfo.Options))

	import('/maps/final_rush_pro_5.1.v0003/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()
end
