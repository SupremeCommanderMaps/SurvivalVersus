import('/lua/sim/ScenarioUtilities.lua').CreateResources = function() end

local finalRush

function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	finalRush = import('/maps/final_rush_pro_5.v0022/src/FinalRushPro.lua').newInstance(ScenarioInfo)
	finalRush.setUp()
	Sync.CampaignMode = true
end

function OnShiftF3()
	finalRush.printSettings()
end

-- -- Not a special name, needs to be manually called
--function PlayerWin()
--	if not ScenarioInfo.OpEnded then
--		ScenarioFramework.EndOperationSafety()
--		ScenarioInfo.OpComplete = true
--		ScenarioFramework.Dialogue(OpStrings.PlayerWins, KillGame, true)
--	end
--end

-- -- Not a special name, needs to be manually called
--function KillGame()
--	local bonus = Objectives.IsComplete(ScenarioInfo.M1B1Objective) and Objectives.IsComplete(ScenarioInfo.M1B2Objective) and Objectives.IsComplete(ScenarioInfo.M2B2Objective)
--	local secondary = Objectives.IsComplete(ScenarioInfo.M1S1Objective) and Objectives.IsComplete(ScenarioInfo.M2S1Objective) and Objectives.IsComplete(ScenarioInfo.M3S1Objective)
--	ScenarioFramework.EndOperation(ScenarioInfo.OpComplete, ScenarioInfo.OpComplete, secondary, bonus)
--end

-- ArmyBrains[Rhiza]:GetListOfUnits(categories.SHIELD, false)

