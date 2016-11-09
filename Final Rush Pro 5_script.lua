function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()

	local Options = import('/maps/Final Rush Pro 5/src/FinalRushOptions.lua')
	ScenarioInfo.Options = Options.applyPresets(Options.defaultOptions(ScenarioInfo.Options))

	import('/maps/Final Rush Pro 5/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()
end

function OnStart(self)
end
