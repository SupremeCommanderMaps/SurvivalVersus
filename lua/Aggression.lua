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
		if not ScenarioInfo.ArmySetup["ARMY_1"] == false and not ArmyIsOutOfGame("ARMY_1") and CommInMiddle("ARMY_1") then
			AddAggro("ARMY_1",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_2"] == false and not ArmyIsOutOfGame("ARMY_2") and CommInMiddle("ARMY_2") then
			AddAggro("ARMY_2",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_3"] == false and not ArmyIsOutOfGame("ARMY_3") and CommInMiddle("ARMY_3") then
			AddAggro("ARMY_3",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_4"] == false and not ArmyIsOutOfGame("ARMY_4") and CommInMiddle("ARMY_4") then
			AddAggro("ARMY_4",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_5"] == false and not ArmyIsOutOfGame("ARMY_5") and CommInMiddle("ARMY_5") then
			AddAggro("ARMY_5",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_6"] == false and not ArmyIsOutOfGame("ARMY_6") and CommInMiddle("ARMY_6") then
			AddAggro("ARMY_6",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_7"] == false and not ArmyIsOutOfGame("ARMY_7") and CommInMiddle("ARMY_7") then
			AddAggro("ARMY_7",AggroCreators.ComminMiddle)
		end
		if not ScenarioInfo.ArmySetup["ARMY_8"] == false and not ArmyIsOutOfGame("ARMY_8") and CommInMiddle("ARMY_8") then
			AddAggro("ARMY_8",AggroCreators.ComminMiddle)
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
	if army == "ARMY_1" then
		Aggro.Current.Team1.Player1 = Aggro.Current.Team1.Player1 + amount
	elseif army == "ARMY_2" then
		Aggro.Current.Team1.Player2 = Aggro.Current.Team1.Player2 + amount
	elseif army == "ARMY_3" then
		Aggro.Current.Team1.Player3 = Aggro.Current.Team1.Player3 + amount
	elseif army == "ARMY_4" then
		Aggro.Current.Team1.Player4 = Aggro.Current.Team1.Player4 + amount
	elseif army == "ARMY_5" then
		Aggro.Current.Team2.Player1 = Aggro.Current.Team2.Player1 + amount
	elseif army == "ARMY_6" then
		Aggro.Current.Team2.Player2 = Aggro.Current.Team2.Player2 + amount
	elseif army == "ARMY_7" then
		Aggro.Current.Team2.Player3 = Aggro.Current.Team2.Player3 + amount
	elseif army == "ARMY_8" then
		Aggro.Current.Team2.Player4 = Aggro.Current.Team2.Player4 + amount
	end
end

function CreateMonitor()
	if not ScenarioInfo.ArmySetup["ARMY_1"] == false then
		ForkThread(MexMonitor,"ARMY_1")
		ForkThread(ArtyMonitor,"ARMY_1")
		ForkThread(NukeMonitor,"ARMY_1")
		ForkThread(MassFabMonitor,"ARMY_1")
	end
	if not ScenarioInfo.ArmySetup["ARMY_2"] == false then
		ForkThread(MexMonitor,"ARMY_2")
		ForkThread(ArtyMonitor,"ARMY_2")
		ForkThread(NukeMonitor,"ARMY_2")
		ForkThread(MassFabMonitor,"ARMY_2")
	end
	if not ScenarioInfo.ArmySetup["ARMY_3"] == false then
		ForkThread(MexMonitor,"ARMY_3")
		ForkThread(ArtyMonitor,"ARMY_3")
		ForkThread(NukeMonitor,"ARMY_3")
		ForkThread(MassFabMonitor,"ARMY_3")
	end
	if not ScenarioInfo.ArmySetup["ARMY_4"] == false then
		ForkThread(MexMonitor,"ARMY_4")
		ForkThread(ArtyMonitor,"ARMY_4")
		ForkThread(NukeMonitor,"ARMY_4")
		ForkThread(MassFabMonitor,"ARMY_4")
	end
	if not ScenarioInfo.ArmySetup["ARMY_5"] == false then
		ForkThread(MexMonitor,"ARMY_5")
		ForkThread(ArtyMonitor,"ARMY_5")
		ForkThread(NukeMonitor,"ARMY_5")
		ForkThread(MassFabMonitor,"ARMY_5")
	end
	if not ScenarioInfo.ArmySetup["ARMY_6"] == false then
		ForkThread(MexMonitor,"ARMY_6")
		ForkThread(ArtyMonitor,"ARMY_6")
		ForkThread(NukeMonitor,"ARMY_6")
		ForkThread(MassFabMonitor,"ARMY_6")
	end
	if not ScenarioInfo.ArmySetup["ARMY_7"] == false then
		ForkThread(MexMonitor,"ARMY_7")
		ForkThread(ArtyMonitor,"ARMY_7")
		ForkThread(NukeMonitor,"ARMY_7")
		ForkThread(MassFabMonitor,"ARMY_7")
	end
	if not ScenarioInfo.ArmySetup["ARMY_8"] == false then
		ForkThread(MexMonitor,"ARMY_8")
		ForkThread(ArtyMonitor,"ARMY_8")
		ForkThread(NukeMonitor,"ARMY_8")
		ForkThread(MassFabMonitor,"ARMY_8")
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
	if army == "ARMY_1" then
		MinAggroStore.Arty.Team1.Player1 = num
	elseif army == "ARMY_2" then
		MinAggroStore.Arty.Team1.Player2 = num
	elseif army == "ARMY_3" then
		MinAggroStore.Arty.Team1.Player3 = num
	elseif army == "ARMY_4" then
		MinAggroStore.Arty.Team1.Player4 = num
	elseif army == "ARMY_5" then
		MinAggroStore.Arty.Team2.Player1 = num
	elseif army == "ARMY_6" then
		MinAggroStore.Arty.Team2.Player2 = num
	elseif army == "ARMY_7" then
		MinAggroStore.Arty.Team2.Player3 = num
	elseif army == "ARMY_8" then
		MinAggroStore.Arty.Team2.Player4 = num
	end 
end

function SetMexAggro(army,num)
	if army == "ARMY_1" then
		MinAggroStore.Mex.Team1.Player1 = num
	elseif army == "ARMY_2" then
		MinAggroStore.Mex.Team1.Player2 = num
	elseif army == "ARMY_3" then
		MinAggroStore.Mex.Team1.Player3 = num
	elseif army == "ARMY_4" then
		MinAggroStore.Mex.Team1.Player4 = num
	elseif army == "ARMY_5" then
		MinAggroStore.Mex.Team2.Player1 = num
	elseif army == "ARMY_6" then
		MinAggroStore.Mex.Team2.Player2 = num
	elseif army == "ARMY_7" then
		MinAggroStore.Mex.Team2.Player3 = num
	elseif army == "ARMY_8" then
		MinAggroStore.Mex.Team2.Player4 = num
	end 
end

function SetNukeAggro(army,num)
	if army == "ARMY_1" then
		MinAggroStore.Nuke.Team1.Player1 = num
	elseif army == "ARMY_2" then
		MinAggroStore.Nuke.Team1.Player2 = num
	elseif army == "ARMY_3" then
		MinAggroStore.Nuke.Team1.Player3 = num
	elseif army == "ARMY_4" then
		MinAggroStore.Nuke.Team1.Player4 = num
	elseif army == "ARMY_5" then
		MinAggroStore.Nuke.Team2.Player1 = num
	elseif army == "ARMY_6" then
		MinAggroStore.Nuke.Team2.Player2 = num
	elseif army == "ARMY_7" then
		MinAggroStore.Nuke.Team2.Player3 = num
	elseif army == "ARMY_8" then
		MinAggroStore.Nuke.Team2.Player4 = num
	end 
end

function SetMassFabAggro(army,num)
	if army == "ARMY_1" then
		MinAggroStore.MassFab.Team1.Player1 = num
	elseif army == "ARMY_2" then
		MinAggroStore.MassFab.Team1.Player2 = num
	elseif army == "ARMY_3" then
		MinAggroStore.MassFab.Team1.Player3 = num
	elseif army == "ARMY_4" then
		MinAggroStore.MassFab.Team1.Player4 = num
	elseif army == "ARMY_5" then
		MinAggroStore.MassFab.Team2.Player1 = num
	elseif army == "ARMY_6" then
		MinAggroStore.MassFab.Team2.Player2 = num
	elseif army == "ARMY_7" then
		MinAggroStore.MassFab.Team2.Player3 = num
	elseif army == "ARMY_8" then
		MinAggroStore.MassFab.Team2.Player4 = num
	end 
end




