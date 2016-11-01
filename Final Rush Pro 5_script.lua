local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua');

local function defaultGameOptions()
	if (ScenarioInfo.Options.opt_gamemode == nil) then
		ScenarioInfo.Options.opt_gamemode = 2;
	end
	if (ScenarioInfo.Options.opt_tents == nil) then
		ScenarioInfo.Options.opt_tents = 9;
	end
	if (ScenarioInfo.Options.opt_AutoReclaim == nil) then
		ScenarioInfo.Options.opt_AutoReclaim = 50;
	end
	if (ScenarioInfo.Options.opt_FinalRushSpawnDelay == nil) then
		ScenarioInfo.Options.opt_FinalRushSpawnDelay = 0;
	end
	if (ScenarioInfo.Options.opt_FinalRushAggression == nil) then
		ScenarioInfo.Options.opt_FinalRushAggression = 1;
	end
	if (ScenarioInfo.Options.opt_FinalRushRandomEvents == nil) then
		ScenarioInfo.Options.opt_FinalRushRandomEvents = 1;
	end
	if (ScenarioInfo.Options.opt_FinalRushHunters == nil) then
		ScenarioInfo.Options.opt_FinalRushHunters = 1;
	end
	if (ScenarioInfo.Options.opt_FinalRushAir == nil) then
		ScenarioInfo.Options.opt_FinalRushAir = 0;
	end
	if (ScenarioInfo.Options.opt_timeunlocked == nil) then
		ScenarioInfo.Options.opt_timeunlocked = 0;
	end
	if (ScenarioInfo.Options.opt_t2tml == nil) then
		ScenarioInfo.Options.opt_t2tml = 0;
	end
	if (ScenarioInfo.Options.opt_t3arty == nil) then
		ScenarioInfo.Options.opt_t3arty = 0;
	end
	if (ScenarioInfo.Options.opt_snipers == nil) then
		ScenarioInfo.Options.opt_snipers = 0;
	end
end

function OnPopulate()
	ScenarioUtils.InitializeArmies()
	defaultGameOptions()

	import('/maps/Final Rush Pro 5/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()
end

function OnStart(self)
end