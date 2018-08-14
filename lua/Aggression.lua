--Max Aggro is 100%
--Aggro Decays over time
--GetFocusArmy()
local Aggro = {
	Current = { 
		Team1 = { Player1 = 0, Player2 = 0,	Player3 = 0, Player4 = 0 },
		Team2 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 }
	},
	Min = {
		Team1 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 },
		Team2 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 }
	}
}

local MinAggroStore = {
	Mex = {
		Team1 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 },
		Team2 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 }
	},
	Arty = {
		Team1 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 },
		Team2 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 }
	},
	Nuke = {
		Team1 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 },
		Team2 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 }
	},
	MassFab = {
		Team1 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 },
		Team2 = { Player1 = 0, Player2 = 0, Player3 = 0, Player4 = 0 }
	}
}

local AggroCreators = {
	FirstTech2 = 20,
	FirstTech3 = 35,
	FirstTechEXP = 55,
	MexCount = 5,
	ArtyCount = 10,
	NukeCount = 20,
	MassFabCount = 5,
	ComminMiddle = 2
}	

local DecayData = {
	Easy = { Speed = 5, Amount = 1 },
	Normal = { Speed = 10, Amount = 1 },
	Hard = { Speed = 20, Amount = 1 },
	Insane = { Speed = 40, Amount = 1 }
}

function Aggression()
	if ScenarioInfo.Options.opt_gamemode > 1 then
		ForkThread(AggressionDecay)
		ForkThread(MinAggressionMonitor)
		--Work out what causes Aggression to increase
		ForkThread(FirstTech2)
		ForkThread(FirstTech3)	
		ForkThread(FirstTechEXP)
		ForkThread(CreateMonitor) -- count types of units and set min aggro.
		ForkThread(CheckCommandersInMiddle) -- commanders in middle will pay.
		--end
		while true do
			Sync.SyncAggro = Aggro	
			WaitSeconds(2)
		end
	end
end


function AggressionDecay()
	local decayspeed
	local decayamount
	if ScenarioInfo.Options.opt_gamemode == 2 or ScenarioInfo.Options.opt_gamemode == 3 then
		decayspeed = DecayData.Easy.Speed
		decayamount = DecayData.Easy.Amount
	elseif ScenarioInfo.Options.opt_gamemode == 4 then
		decayspeed = DecayData.Normal.Speed
		decayamount = DecayData.Normal.Amount
	elseif ScenarioInfo.Options.opt_gamemode == 5 then
		decayspeed = DecayData.Hard.Speed
		decayamount = DecayData.Hard.Amount
	elseif ScenarioInfo.Options.opt_gamemode == 6 then
		decayspeed = DecayData.Insane.Speed
		decayamount = DecayData.Insane.Amount
	end
	
	while true do
		Aggro.Current.Team1.Player1 = Aggro.Current.Team1.Player1 - decayamount
		Aggro.Current.Team1.Player2 = Aggro.Current.Team1.Player2 - decayamount
		Aggro.Current.Team1.Player3 = Aggro.Current.Team1.Player3 - decayamount
		Aggro.Current.Team1.Player4 = Aggro.Current.Team1.Player4 - decayamount
		Aggro.Current.Team2.Player1 = Aggro.Current.Team2.Player1 - decayamount
		Aggro.Current.Team2.Player2 = Aggro.Current.Team2.Player2 - decayamount
		Aggro.Current.Team2.Player3 = Aggro.Current.Team2.Player3 - decayamount
		Aggro.Current.Team2.Player4 = Aggro.Current.Team2.Player4 - decayamount
		
		--LOG(repr(Aggro))
		if Aggro.Current.Team1.Player1 < Aggro.Min.Team1.Player1 then
			Aggro.Current.Team1.Player1 = Aggro.Min.Team1.Player1
		end
		if Aggro.Current.Team1.Player2 < Aggro.Min.Team1.Player2 then
			Aggro.Current.Team1.Player2 = Aggro.Min.Team1.Player2
		end
		if Aggro.Current.Team1.Player3 < Aggro.Min.Team1.Player3 then
			Aggro.Current.Team1.Player3 = Aggro.Min.Team1.Player3
		end
		if Aggro.Current.Team1.Player4 < Aggro.Min.Team1.Player4 then
			Aggro.Current.Team1.Player4 = Aggro.Min.Team1.Player4
		end
		if Aggro.Current.Team2.Player1 < Aggro.Min.Team2.Player1 then
			Aggro.Current.Team2.Player1 = Aggro.Min.Team2.Player1
		end
		if Aggro.Current.Team2.Player2 < Aggro.Min.Team2.Player2 then
			Aggro.Current.Team2.Player2 = Aggro.Min.Team2.Player2
		end
		if Aggro.Current.Team2.Player3 < Aggro.Min.Team2.Player3 then
			Aggro.Current.Team2.Player3 = Aggro.Min.Team2.Player3
		end
		if Aggro.Current.Team2.Player4 < Aggro.Min.Team2.Player4 then
			Aggro.Current.Team2.Player4 = Aggro.Min.Team2.Player4
		end
		WaitSeconds(decayspeed)
	end
end

function MinAggressionMonitor()
	while true do
		Aggro.Min.Team1.Player1 = MinAggroStore.Mex.Team1.Player1 + MinAggroStore.Arty.Team1.Player1 + MinAggroStore.Nuke.Team1.Player1 + MinAggroStore.MassFab.Team1.Player1
		Aggro.Min.Team1.Player2 = MinAggroStore.Mex.Team1.Player2 + MinAggroStore.Arty.Team1.Player2 + MinAggroStore.Nuke.Team1.Player2 + MinAggroStore.MassFab.Team1.Player2
		Aggro.Min.Team1.Player3 = MinAggroStore.Mex.Team1.Player3 + MinAggroStore.Arty.Team1.Player3 + MinAggroStore.Nuke.Team1.Player2 + MinAggroStore.MassFab.Team1.Player3
		Aggro.Min.Team1.Player4 = MinAggroStore.Mex.Team1.Player4 + MinAggroStore.Arty.Team1.Player4 + MinAggroStore.Nuke.Team1.Player4 + MinAggroStore.MassFab.Team1.Player4
		Aggro.Min.Team2.Player1 = MinAggroStore.Mex.Team2.Player1 + MinAggroStore.Arty.Team2.Player1 + MinAggroStore.Nuke.Team2.Player1 + MinAggroStore.MassFab.Team2.Player1
		Aggro.Min.Team2.Player2 = MinAggroStore.Mex.Team2.Player2 + MinAggroStore.Arty.Team2.Player2 + MinAggroStore.Nuke.Team2.Player2 + MinAggroStore.MassFab.Team2.Player2
		Aggro.Min.Team2.Player3 = MinAggroStore.Mex.Team2.Player3 + MinAggroStore.Arty.Team2.Player3 + MinAggroStore.Nuke.Team2.Player3 + MinAggroStore.MassFab.Team2.Player3
		Aggro.Min.Team2.Player4 = MinAggroStore.Mex.Team2.Player4 + MinAggroStore.Arty.Team2.Player4 + MinAggroStore.Nuke.Team2.Player4 + MinAggroStore.MassFab.Team2.Player4
		WaitSeconds(2)
	end
end

function ReturnAggro(team,player) --for map script to get data from mod
	if team == 1 then
		if player == 1 then
			return Aggro.Current.Team1.Player1
		elseif player == 2 then
			return Aggro.Current.Team1.Player2
		elseif player == 3 then
			return Aggro.Current.Team1.Player3
		elseif player == 4 then
			return Aggro.Current.Team1.Player4
		end
	elseif team == 2 then
		if player == 1 then
			return Aggro.Current.Team2.Player1
		elseif player == 2 then
			return Aggro.Current.Team2.Player2
		elseif player == 3 then
			return Aggro.Current.Team2.Player3
		elseif player == 4 then
			return Aggro.Current.Team2.Player4
		end
	end
end

function FirstTech2()
	local owner = false
	while owner == false do
		local units = allUnits()
		units = EntityCategoryFilterDown(categories.TECH2 - categories.xrb0304 - categories.COMMAND, units)
		if units and table.getn(units) > 0 then 
			for index,unit in units do 
				if ListArmies()[unit:GetArmy()] != "BOTTOM_BOT" and ListArmies()[unit:GetArmy()] != "TOP_BOT" and not unit:IsBeingBuilt() then
					owner = ListArmies()[unit:GetArmy()]
				end
			end
		end
		WaitSeconds(3)
	end
	LOG("First to Tech2: ", GetArmyBrain(owner).Nickname)
	AddAggro(owner, AggroCreators.FirstTech2)
end

function FirstTech3()
	local owner = false
	while owner == false do
		local units = allUnits()
		units = EntityCategoryFilterDown(categories.TECH3 - categories.COMMAND, units)
		if units and table.getn(units) > 0 then 
			for index,unit in units do 
				if ListArmies()[unit:GetArmy()] != "BOTTOM_BOT" and ListArmies()[unit:GetArmy()] != "TOP_BOT" and not unit:IsBeingBuilt() then
					owner = ListArmies()[unit:GetArmy()]
				end
			end
		end
		WaitSeconds(3)
	end
	LOG("First to Tech3: ", GetArmyBrain(owner).Nickname)
	AddAggro(owner, AggroCreators.FirstTech3)
end

function FirstTechEXP()
	local owner = false
	while owner == false do
		local units = allUnits()
		units = EntityCategoryFilterDown(categories.EXPERIMENTAL - categories.COMMAND, units)
		if units and table.getn(units) > 0 then 
			for index,unit in units do 
				if ListArmies()[unit:GetArmy()] != "BOTTOM_BOT" and ListArmies()[unit:GetArmy()] != "TOP_BOT" and not unit:IsBeingBuilt() then
					owner = ListArmies()[unit:GetArmy()]
				end
			end
		end
		WaitSeconds(3)
	end
	LOG("First to Exp: ", GetArmyBrain(owner).Nickname)
	AddAggro(owner, AggroCreators.FirstTechEXP)
end

function CheckCommandersInMiddle()
	while true do
		if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_LEFT"] == false and not ArmyIsOutOfGame("ARMY_BOTTOM_LEFT") and CommInMiddle("ARMY_BOTTOM_LEFT") then
			AddAggro("ARMY_BOTTOM_LEFT",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_LMID"] == false and not ArmyIsOutOfGame("ARMY_BOTTOM_LMID") and CommInMiddle("ARMY_BOTTOM_LMID") then
			AddAggro("ARMY_BOTTOM_LMID",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_RMID"] == false and not ArmyIsOutOfGame("ARMY_BOTTOM_RMID") and CommInMiddle("ARMY_BOTTOM_RMID") then
			AddAggro("ARMY_BOTTOM_RMID",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_RIGHT"] == false and not ArmyIsOutOfGame("ARMY_BOTTOM_RIGHT") and CommInMiddle("ARMY_BOTTOM_RIGHT") then
			AddAggro("ARMY_BOTTOM_RIGHT",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_TOP_RIGHT"] == false and not ArmyIsOutOfGame("ARMY_TOP_RIGHT") and CommInMiddle("ARMY_TOP_RIGHT") then
			AddAggro("ARMY_TOP_RIGHT",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_TOP_RMID"] == false and not ArmyIsOutOfGame("ARMY_TOP_RMID") and CommInMiddle("ARMY_TOP_RMID") then
			AddAggro("ARMY_TOP_RMID",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_TOP_LMID"] == false and not ArmyIsOutOfGame("ARMY_TOP_LMID") and CommInMiddle("ARMY_TOP_LMID") then
			AddAggro("ARMY_TOP_LMID",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_TOP_LEFT"] == false and not ArmyIsOutOfGame("ARMY_TOP_LEFT") and CommInMiddle("ARMY_TOP_LEFT") then
			AddAggro("ARMY_TOP_LEFT",AggroCreators.ComminMiddle)
		end
		WaitSeconds(5)
	end
end

allUnits = function() 
     local xmapsize = ScenarioInfo.size[1] 
     local ymapsize = ScenarioInfo.size[2] 
     local mapRect = {x0 = 0, x1 = xmapsize, y0 = 0, y1 = ymapsize} 
     units = GetUnitsInRect(mapRect) 
    return units
end 

function AddAggro(army, amount)
	if army == "ARMY_BOTTOM_LEFT" then
		Aggro.Current.Team1.Player1 = Aggro.Current.Team1.Player1 + amount
	elseif army == "ARMY_BOTTOM_LMID" then
		Aggro.Current.Team1.Player2 = Aggro.Current.Team1.Player2 + amount
	elseif army == "ARMY_BOTTOM_RMID" then
		Aggro.Current.Team1.Player3 = Aggro.Current.Team1.Player3 + amount
	elseif army == "ARMY_BOTTOM_RIGHT" then
		Aggro.Current.Team1.Player4 = Aggro.Current.Team1.Player4 + amount
	elseif army == "ARMY_TOP_RIGHT" then
		Aggro.Current.Team2.Player1 = Aggro.Current.Team2.Player1 + amount
	elseif army == "ARMY_TOP_RMID" then
		Aggro.Current.Team2.Player2 = Aggro.Current.Team2.Player2 + amount
	elseif army == "ARMY_TOP_LMID" then
		Aggro.Current.Team2.Player3 = Aggro.Current.Team2.Player3 + amount
	elseif army == "ARMY_TOP_LEFT" then
		Aggro.Current.Team2.Player4 = Aggro.Current.Team2.Player4 + amount
	end
end

function CreateMonitor()
	if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_LEFT"] == false then
		ForkThread(MexMonitor,"ARMY_BOTTOM_LEFT")
		ForkThread(ArtyMonitor,"ARMY_BOTTOM_LEFT")
		ForkThread(NukeMonitor,"ARMY_BOTTOM_LEFT")
		ForkThread(MassFabMonitor,"ARMY_BOTTOM_LEFT")
	end
	if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_LMID"] == false then
		ForkThread(MexMonitor,"ARMY_BOTTOM_LMID")
		ForkThread(ArtyMonitor,"ARMY_BOTTOM_LMID")
		ForkThread(NukeMonitor,"ARMY_BOTTOM_LMID")
		ForkThread(MassFabMonitor,"ARMY_BOTTOM_LMID")
	end
	if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_RMID"] == false then
		ForkThread(MexMonitor,"ARMY_BOTTOM_RMID")
		ForkThread(ArtyMonitor,"ARMY_BOTTOM_RMID")
		ForkThread(NukeMonitor,"ARMY_BOTTOM_RMID")
		ForkThread(MassFabMonitor,"ARMY_BOTTOM_RMID")
	end
	if not ScenarioInfo.ArmySetup["ARMY_BOTTOM_RIGHT"] == false then
		ForkThread(MexMonitor,"ARMY_BOTTOM_RIGHT")
		ForkThread(ArtyMonitor,"ARMY_BOTTOM_RIGHT")
		ForkThread(NukeMonitor,"ARMY_BOTTOM_RIGHT")
		ForkThread(MassFabMonitor,"ARMY_BOTTOM_RIGHT")
	end
	if not ScenarioInfo.ArmySetup["ARMY_TOP_RIGHT"] == false then
		ForkThread(MexMonitor,"ARMY_TOP_RIGHT")
		ForkThread(ArtyMonitor,"ARMY_TOP_RIGHT")
		ForkThread(NukeMonitor,"ARMY_TOP_RIGHT")
		ForkThread(MassFabMonitor,"ARMY_TOP_RIGHT")
	end
	if not ScenarioInfo.ArmySetup["ARMY_TOP_RMID"] == false then
		ForkThread(MexMonitor,"ARMY_TOP_RMID")
		ForkThread(ArtyMonitor,"ARMY_TOP_RMID")
		ForkThread(NukeMonitor,"ARMY_TOP_RMID")
		ForkThread(MassFabMonitor,"ARMY_TOP_RMID")
	end
	if not ScenarioInfo.ArmySetup["ARMY_TOP_LMID"] == false then
		ForkThread(MexMonitor,"ARMY_TOP_LMID")
		ForkThread(ArtyMonitor,"ARMY_TOP_LMID")
		ForkThread(NukeMonitor,"ARMY_TOP_LMID")
		ForkThread(MassFabMonitor,"ARMY_TOP_LMID")
	end
	if not ScenarioInfo.ArmySetup["ARMY_TOP_LEFT"] == false then
		ForkThread(MexMonitor,"ARMY_TOP_LEFT")
		ForkThread(ArtyMonitor,"ARMY_TOP_LEFT")
		ForkThread(NukeMonitor,"ARMY_TOP_LEFT")
		ForkThread(MassFabMonitor,"ARMY_TOP_LEFT")
	end
end

function MassFabMonitor(army)
	local units
	while not ArmyIsOutOfGame(army) do
		amount = 0
		units = allUnits()
		for k, v in units do
			if(ListArmies()[v:GetArmy()] == army and EntityCategoryContains(categories.MASSFABRICATION, v) and not v:IsBeingBuilt()) then
				amount = amount + 1
			end
		end
		if amount > 2 then 
			amount = AggroCreators.MassFabCount * (amount - 2)
			SetMassFabAggro(army, amount)
		else
			SetMassFabAggro(army,0)	
		end
		WaitSeconds(3)
	end
end

function MexMonitor(army)
	local units
	while not ArmyIsOutOfGame(army) do
		amount = 0
		units = allUnits()
		for k, v in units do
			if(ListArmies()[v:GetArmy()] == army and EntityCategoryContains(categories.MASSEXTRACTION, v) and not v:IsBeingBuilt()) then
				amount = amount + 1
			end
		end
		if amount > 9 then 
			amount = AggroCreators.MexCount * (amount - 9)
			SetMexAggro(army, amount)
		else
			SetMexAggro(army,0)	
		end
		WaitSeconds(3)
	end
end

function ArtyMonitor(army)
	local units
	while not ArmyIsOutOfGame(army) do
		amount = 0
		units = allUnits()
		for k, v in units do
			if(ListArmies()[v:GetArmy()] == army and EntityCategoryContains(categories.ARTILLERY * categories.STRUCTURE - categories.TECH2, v) and not v:IsBeingBuilt()) then
				amount = amount + 1
			end
		end
		if amount > 0 then 
			amount = AggroCreators.ArtyCount * amount
			SetArtyAggro(army, amount)
		else
			SetArtyAggro(army,0)	
		end
		WaitSeconds(3)
	end
end

function NukeMonitor(army)
	local units
	while not ArmyIsOutOfGame(army) do
		amount = 0
		units = allUnits()
		for k, v in units do
			if(ListArmies()[v:GetArmy()] == army and EntityCategoryContains(categories.NUKE, v) and not v:IsBeingBuilt()) then
				amount = amount + 1
			end
		end
		if amount > 0 then 
			amount = AggroCreators.NukeCount * amount
			SetNukeAggro(army, amount)
		else
			SetNukeAggro(army,0)	
		end
		WaitSeconds(3)
	end
end

function CommInMiddle(army)
	local commanderfound = false
	local units = GetUnitsInRect(160,160,350,350)
	if units and table.getn(units) > 0 then
		units = EntityCategoryFilterDown(categories.COMMAND,units)	
		if units and table.getn(units) > 0 then
			for k, v in units do
				if ListArmies()[v:GetArmy()] == army then
					commanderfound = true
				end
			end
		end
	end
	return commanderfound
end

function SetArtyAggro(army,num)
	if army == "ARMY_BOTTOM_LEFT" then
		MinAggroStore.Arty.Team1.Player1 = num
	elseif army == "ARMY_BOTTOM_LMID" then
		MinAggroStore.Arty.Team1.Player2 = num
	elseif army == "ARMY_BOTTOM_RMID" then
		MinAggroStore.Arty.Team1.Player3 = num
	elseif army == "ARMY_BOTTOM_RIGHT" then
		MinAggroStore.Arty.Team1.Player4 = num
	elseif army == "ARMY_TOP_RIGHT" then
		MinAggroStore.Arty.Team2.Player1 = num
	elseif army == "ARMY_TOP_RMID" then
		MinAggroStore.Arty.Team2.Player2 = num
	elseif army == "ARMY_TOP_LMID" then
		MinAggroStore.Arty.Team2.Player3 = num
	elseif army == "ARMY_TOP_LEFT" then
		MinAggroStore.Arty.Team2.Player4 = num
	end 
end

function SetMexAggro(army,num)
	if army == "ARMY_BOTTOM_LEFT" then
		MinAggroStore.Mex.Team1.Player1 = num
	elseif army == "ARMY_BOTTOM_LMID" then
		MinAggroStore.Mex.Team1.Player2 = num
	elseif army == "ARMY_BOTTOM_RMID" then
		MinAggroStore.Mex.Team1.Player3 = num
	elseif army == "ARMY_BOTTOM_RIGHT" then
		MinAggroStore.Mex.Team1.Player4 = num
	elseif army == "ARMY_TOP_RIGHT" then
		MinAggroStore.Mex.Team2.Player1 = num
	elseif army == "ARMY_TOP_RMID" then
		MinAggroStore.Mex.Team2.Player2 = num
	elseif army == "ARMY_TOP_LMID" then
		MinAggroStore.Mex.Team2.Player3 = num
	elseif army == "ARMY_TOP_LEFT" then
		MinAggroStore.Mex.Team2.Player4 = num
	end 
end

function SetNukeAggro(army,num)
	if army == "ARMY_BOTTOM_LEFT" then
		MinAggroStore.Nuke.Team1.Player1 = num
	elseif army == "ARMY_BOTTOM_LMID" then
		MinAggroStore.Nuke.Team1.Player2 = num
	elseif army == "ARMY_BOTTOM_RMID" then
		MinAggroStore.Nuke.Team1.Player3 = num
	elseif army == "ARMY_BOTTOM_RIGHT" then
		MinAggroStore.Nuke.Team1.Player4 = num
	elseif army == "ARMY_TOP_RIGHT" then
		MinAggroStore.Nuke.Team2.Player1 = num
	elseif army == "ARMY_TOP_RMID" then
		MinAggroStore.Nuke.Team2.Player2 = num
	elseif army == "ARMY_TOP_LMID" then
		MinAggroStore.Nuke.Team2.Player3 = num
	elseif army == "ARMY_TOP_LEFT" then
		MinAggroStore.Nuke.Team2.Player4 = num
	end 
end

function SetMassFabAggro(army,num)
	if army == "ARMY_BOTTOM_LEFT" then
		MinAggroStore.MassFab.Team1.Player1 = num
	elseif army == "ARMY_BOTTOM_LMID" then
		MinAggroStore.MassFab.Team1.Player2 = num
	elseif army == "ARMY_BOTTOM_RMID" then
		MinAggroStore.MassFab.Team1.Player3 = num
	elseif army == "ARMY_BOTTOM_RIGHT" then
		MinAggroStore.MassFab.Team1.Player4 = num
	elseif army == "ARMY_TOP_RIGHT" then
		MinAggroStore.MassFab.Team2.Player1 = num
	elseif army == "ARMY_TOP_RMID" then
		MinAggroStore.MassFab.Team2.Player2 = num
	elseif army == "ARMY_TOP_LMID" then
		MinAggroStore.MassFab.Team2.Player3 = num
	elseif army == "ARMY_TOP_LEFT" then
		MinAggroStore.MassFab.Team2.Player4 = num
	end 
end




