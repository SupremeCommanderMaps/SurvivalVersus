
function CollectDataSync()
	while true do
		SyncData = {
			EnemyTop = 0, 
			EnemyBottom = 0,
			KillData = {	
						ARMY_1 = "",
						ARMY_2 = "",
						ARMY_3 = "",
						ARMY_4 = "",
						ARMY_5 = "",
						ARMY_6 = "",
						ARMY_7 = "",
						ARMY_8 = ""						
			},
			PlayerNames = {	
						ARMY_1 = "",
						ARMY_2 = "",
						ARMY_3 = "",
						ARMY_4 = "",
						ARMY_5 = "",
						ARMY_6 = "",
						ARMY_7 = "",
						ARMY_8 = ""						
			}
		}
		
		
		for index, brain in ArmyBrains do
			if brain.Name == "ARMY_9" then
				SyncData.EnemyBottom = brain:GetArmyStat("UnitCap_Current", 0.0).Value -3
			end
			if brain.Name == "NEUTRAL_CIVILIAN" then
				SyncData.EnemyTop = brain:GetArmyStat("UnitCap_Current", 0.0).Value -3
			end
			
			if brain.Name == "ARMY_1" then
				SyncData.PlayerNames.ARMY_1 = brain.Nickname
				SyncData.KillData.ARMY_1 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_2" then
				SyncData.PlayerNames.ARMY_2 = brain.Nickname
				SyncData.KillData.ARMY_2 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_3" then
				SyncData.PlayerNames.ARMY_3 = brain.Nickname
				SyncData.KillData.ARMY_3 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_4" then
				SyncData.PlayerNames.ARMY_4 = brain.Nickname
				SyncData.KillData.ARMY_4 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_5" then
				SyncData.PlayerNames.ARMY_5 = brain.Nickname
				SyncData.KillData.ARMY_5 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_6" then
				SyncData.PlayerNames.ARMY_6 = brain.Nickname
				SyncData.KillData.ARMY_6 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_7" then
				SyncData.PlayerNames.ARMY_7 = brain.Nickname
				SyncData.KillData.ARMY_7 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			elseif brain.Name == "ARMY_8" then
				SyncData.PlayerNames.ARMY_8 = brain.Nickname
				SyncData.KillData.ARMY_8 = brain:GetArmyStat("Enemies_Killed", 0.0).Value
			end
			
        end

		Sync.SyncData = SyncData
		WaitSeconds(2)
	end
end
