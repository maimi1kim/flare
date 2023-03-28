_G.CommFlareDB = _G.CommFlareDB or {}
local CfEventHandlerLoaded = false
local CfEvt = CreateFrame("FRAME")
CfEvt:RegisterEvent("PLAYER_LOGIN")
CfEvt:RegisterEvent("PLAYER_LOGOUT")

function comf_split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function comf_get_rank(playerName)
	for i = 1, MAX_RAID_MEMBERS do
		local name, rank = GetRaidRosterInfo(i)
		if name == playerName then
			return rank
		end
	end
	return nil
end

function comf_is_healer(spec)
	if (spec == "Discipline") then
		return 1
	elseif (spec == "Holy") then
		return 1
	elseif (spec == "Mistweaver") then
		return 1
	elseif (spec == "Restoration") then
		return 1
	else
		return 0
	end
end

function comf_is_tank(spec)
	if (spec == "Blood") then
		return 1
	elseif (spec == "Brewmaster") then
		return 1
	elseif (spec == "Guardian") then
		return 1
	elseif (spec == "Protection") then
		return 1
	else
		return 0
	end
end

function comf_find_clubid(communityName)
	local clubs = C_Club.GetSubscribedClubs()
	for i,v in ipairs(clubs) do
		if (v.name == communityName) then
			return v.clubId
		end
	end
	return 372791201 -- SAS ID
end

function comf_find_member_by_name(playerName, realmName)
	local fullName
	local clubId = comf_find_clubid("Savage Alliance Slayers")
	local c = C_Club.GetClubMembers(clubId)
	if realmName == GetRealmName() then
		fullName = playerName
	else
		fullName = playerName .. "-" .. realmName
	end
	for i,v in ipairs(c) do
		local memberInfo = C_Club.GetMemberInfo(clubId, v);
		if memberInfo ~= nil then
			if fullName == memberInfo.name then
				return memberInfo.name
			end
		end
	end
	return nil
end

SLASH_COMF1 = "/comf"
SlashCmdList["COMF"] = function(msg, editBox)
	-- count some stuff
	local numScores = GetNumBattlefieldScores()
	local numHorde, numHordeHealers, numHordeTanks = 0
	local numAlliance, numAllianceHealers, numAllianceTanks = 0
	if numScores ~= 0 then
		for i = 1, numScores do
			local name,_,_,_,_,faction,race,_,class,_,_,_,_,_,_,spec = GetBattlefieldScore(i)
			-- if (name == "Mesostealthy") then
			--	 print("Index: ", i)
			-- end
			if (faction) then
				local isHealer = comf_is_healer(spec)
				local isTank = comf_is_tank(spec)
				if (faction == 0) then
					numHorde = numHorde + 1
					if (isHealer == 1) then
						numHordeHealers = numHordeHealers + 1
					end
					if (isTank == 1) then
						numHordeTanks = numHordeTanks + 1
					end
				else
					numAlliance = numAlliance + 1
					if (isHealer == 1) then
						numAllianceHealers = numAllianceHealers + 1
					end
					if (isTank == 1) then
						numAllianceTanks = numAllianceTanks + 1
					end
					end
			end
		end
		print(string.format("Horde: Healers = %d, Tanks = %d", numHordeHealers, numHordeTanks))
		print(string.format("Alliance: Healers = %d, Tanks = %d", numAllianceHealers, numAllianceTanks))

		-- find SAS members
		local playerList = nil
		local count, clubId = 0
		local playerName = UnitName("player")
		local rank = comf_get_rank(playerName)
		local clubId = comf_find_clubid("Savage Alliance Slayers")
		local c = C_Club.GetClubMembers(clubId)
		for i,v in ipairs(c) do
			local memberInfo = C_Club.GetMemberInfo(clubId, v);
			if memberInfo ~= nil then
				local n = UnitInRaid(memberInfo.name)
				if n ~= nil then
					count = count + 1
					if playerList == nil then
						playerList = memberInfo.name
					else
						playerList = playerList .. ", " .. memberInfo.name
					end
					if rank == 2 then
						PromoteToAssistant(memberInfo.name)
					end
				end
			end
		end
		print("SAS: ", playerList)
		print("Found: ", count)
	else
		print("SAS: Not in Battleground yet")
	end
end

function CommunityFlare_AutoAcceptQueues()
	LFDRoleCheckPopupAcceptButton:SetScript("OnShow", function()
		local leader, realm
		local playerName = UnitName("player")
		local isInRaid = IsInRaid(playerName)
		if isInRaid == true then
			for i = 1, MAX_RAID_MEMBERS do
				local name, rank = GetRaidRosterInfo(i)
				if rank == 2 then
					local split_string = comf_split(name, "-")
					leader = split_string[1]
					realm = split_string[2]
					break
				end
			end
		else
			for i = 1, GetNumSubgroupMembers() do 
				if UnitIsGroupLeader("party" .. i) then 
					leader, realm = UnitName("party" .. i)
					break
				end
			end
		end
		if not realm then
			realm = GetRealmName()
		end
		local fullName = comf_find_member_by_name(leader, realm)
		if fullName ~= nil then
			LFDRoleCheckPopupAcceptButton:Click()
		end
	end)
end

local function eventHandler(self, event, arg1, arg2, ...)
	if event == "PLAYER_LOGIN" then
		if CfEventHandlerLoaded == false then
			CommunityFlare_AutoAcceptQueues()
			CfEventHandlerLoaded = true
		end
	end
	if event == "PLAYER_LOGOUT" then
		CommFlareDB["SASID"] = comf_find_clubid("Savage Alliance Slayers")
	end
end
CfEvt:SetScript("OnEvent", eventHandler)
