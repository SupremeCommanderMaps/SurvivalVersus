function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	import('/maps/final_rush_pro_5.v0017/src/frp/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()
end

import('/lua/sim/ScenarioUtilities.lua').CreateResources = function() end