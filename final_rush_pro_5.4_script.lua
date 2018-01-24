function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	import('/maps/final_rush_pro_5.4.v0001/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()

	import('/lua/SimSync.lua')

--	ForkThread(function()
--		WaitSeconds(2)
--		local beetle = CreateUnitHPR(
--			"xrl0302",
--			"ARMY_9",
--			255,
--			25.9844,
--			255,
--			0, 0, 0
--		)
--
--		LOG(repr(beetle))
--
--		beetle:SetMaxHealth(beetle:GetMaxHealth() * 10)
--		beetle:SetHealth(beetle, beetle:GetMaxHealth())
--		beetle:SetSpeedMult(0.42)
--
--		beetle.OnKilled = function()
--			CreateUnitHPR(
--				"xrl0302",
--				"ARMY_9",
--				255,
--				25.9844,
--				255,
--				0, 0, 0
--			)
--		end
--	end)
end
