SLASH_COMF1 = "/comf"

-- current stuff
local CommFlareDB = {}
local cfVersion = "v0.12"

-- localize stuff
local _G = _G;
local BNGetFriendIndex                    = _G.BNGetFriendIndex
local BNInviteFriend                      = _G.BNInviteFriend
local BNSendWhisper                       = _G.BNSendWhisper
local CreateFrame                         = _G.CreateFrame
local DevTools_Dump                       = _G.DevTools_Dump
local GetBattlefieldScore                 = _G.GetBattlefieldScore
local GetBattlefieldStatus                = _G.GetBattlefieldStatus
local GetChannelName                      = _G.GetChannelName
local GetMaxBattlefieldID                 = _G.GetMaxBattlefieldID
local GetNumBattlefieldScores             = _G.GetNumBattlefieldScores
local GetNumGroupMembers                  = _G.GetNumGroupMembers
local GetNumSubgroupMembers               = _G.GetNumSubgroupMembers
local GetPlayerInfoByGUID                 = _G.GetPlayerInfoByGUID
local GetRaidRosterInfo                   = _G.GetRaidRosterInfo
local GetRealmName                        = _G.GetRealmName
local InterfaceOptions_AddCategory        = _G.InterfaceOptions_AddCategory
local IsInGroup                           = _G.IsInGroup
local IsInRaid                            = _G.IsInRaid
local PromoteToAssistant                  = _G.PromoteToAssistant
local PromoteToLeader                     = _G.PromoteToLeader
local SlashCmdList                        = _G.SlashCmdList
local SendChatMessage                     = _G.SendChatMessage
local StaticPopupDialogs                  = _G.StaticPopupDialogs
local StaticPopup_Show                    = _G.StaticPopup_Show
local StaticPopup1                        = _G.StaticPopup1
local StaticPopup1Text                    = _G.StaticPopup1Text
local UnitFullName                        = _G.UnitFullName
local UnitGUID                            = _G.UnitGUID
local UnitInRaid                          = _G.UnitInRaid
local UnitIsGroupLeader                   = _G.UnitIsGroupLeader
local UnitName                            = _G.UnitName
local AuraUtilForEachAura                 = _G.AuraUtil.ForEachAura
local BattleNetGetFriendGameAccountInfo   = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts   = _G.C_BattleNet.GetFriendNumGameAccounts
local ChatInfoRegisterAddonMessagePrefix  = _G.C_ChatInfo.RegisterAddonMessagePrefix
local ChatInfoSendAddonMessage            = _G.C_ChatInfo.SendAddonMessage
local ClubGetClubMembers                  = _G.C_Club.GetClubMembers
local ClubGetMemberInfo                   = _G.C_Club.GetMemberInfo
local ClubGetSubscribedClubs              = _G.C_Club.GetSubscribedClubs
local PartyInfoIsPartyFull                = _G.C_PartyInfo.IsPartyFull
local PartyInfoInviteUnit                 = _G.C_PartyInfo.InviteUnit
local PartyInfoLeaveParty                 = _G.C_PartyInfo.LeaveParty
local SocialQueueGetAllGroups             = _G.C_SocialQueue.GetAllGroups
local SocialQueueGetGroupInfo             = _G.C_SocialQueue.GetGroupInfo
local SocialQueueGetGroupMembers          = _G.C_SocialQueue.GetGroupMembers
local SocialQueueGetGroupQueues           = _G.C_SocialQueue.GetGroupQueues
local TimerAfter                          = _G.C_Timer.After
local hooksecurefunc                      = _G.hooksecurefunc
local ipairs                              = _G.ipairs
local pairs                               = _G.pairs
local print                               = _G.print
local strfind, strformat, strlower = string.find, string.format, string.lower

-- default options
local CommFlare_DefaultOptions = {
	["SASID"] = 0,
	["alwaysAutoQueue"] = false,
	["bnetAutoInvite"] = false,
	["communityAutoInvite"] = true,
	["communityAutoPromoteLeader"] = true,
	["communityAutoQueue"] = true,
	["communityReporter"] = true,
}

-- global variables
local count = 0
local isHealer = 0
local isTank = 0
local numHorde = 0
local numHordeHealers = 0
local numHordeTanks = 0
local numAlliance = 0
local numAllianceHealers = 0
local numAllianceTanks = 0
local numScores = 0
local playerList = nil
local variable1 = nil
local variable2 = nil
local cfHasAura = false
local cfGroupInvited = false
local cfQueueJoined = false
local cfQueuePopped = false
local cfEventHandlerLoaded = false
local cfCommunityName = "Savage Alliance Slayers"
local cfGroups = {}

-- create frame
local f = CreateFrame("FRAME")

-- community leaders by priority list
f.sasLeaders = {
	"Cinco-CenarionCircle",
	"Mesostealthy-Dentarg",
	"Lifestooport-Dentarg",
	"Shotdasherif-Dentarg",
	"Angelsong-BlackwaterRaiders",
	"Shanlie-CenarionCircle",
	"Krolak-Proudmoore",
}

-- setup addon options
function f:SetupOptions()
	self.panel = CreateFrame("Frame")
	self.panel.name = "Community Flare"

	local position = -20
	local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, position)
	cb.Text:SetText("Always automatically queue")
	cb.SetValue = function(_, value)
		self.db.alwaysAutoQueue = (value == "1")
	end
	cb:SetChecked(self.db.alwaysAutoQueue)
	position = position - 30

	cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, position)
	cb.Text:SetText("Auto queue (If leader is SAS)")
	cb.SetValue = function(_, value)
		self.db.communityAutoQueue = (value == "1")
	end
	cb:SetChecked(self.db.communityAutoQueue)
	position = position - 30

	cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, position)
	cb.Text:SetText("Auto invite SAS (If you are leader and have room)")
	cb.SetValue = function(_, value)
		self.db.communityAutoInvite = (value == "1")
	end
	cb:SetChecked(self.db.communityAutoInvite)
	position = position - 30

	cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, position)
	cb.Text:SetText("Auto invite BNET (If you are leader and have room)")
	cb.SetValue = function(_, value)
		self.db.bnetAutoInvite = (value == "1")
	end
	cb:SetChecked(self.db.bnetAutoInvite)
	position = position - 30

	cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, position)
	cb.Text:SetText("Auto promote leaders in SAS (If you are raid leader)")
	cb.SetValue = function(_, value)
		self.db.communityAutoPromoteLeader = (value == "1")
	end
	cb:SetChecked(self.db.communityAutoPromoteLeader)
	position = position - 30

	cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, position)
	cb.Text:SetText("Report queues to SAS")
	cb.SetValue = function(_, value)
		self.db.communityReporter = (value == "1")
	end
	cb:SetChecked(self.db.communityReporter)
	position = position - 30

	InterfaceOptions_AddCategory(self.panel)
end

-- register all necessary events
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_BN_WHISPER")
f:RegisterEvent("CHAT_MSG_PARTY")
f:RegisterEvent("CHAT_MSG_PARTY_LEADER")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("GROUP_INVITE_CONFIRMATION")
f:RegisterEvent("PARTY_INVITE_REQUEST")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOGOUT")
f:RegisterEvent("READY_CHECK")
f:RegisterEvent("SOCIAL_QUEUE_UPDATE")
f:RegisterEvent("UI_INFO_MESSAGE")

-- find community id by name
local function CommunityFlare_FindClubIDByName(name)
	-- has SASID already?
	if (CommFlareDB["SASID"] > 0) then
		return CommFlareDB["SASID"]
	end

	-- process all subscribed communities
	local clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(clubs) do
		if (v.name == name) then
			return v.clubId
		end
	end
	return 0
end

-- popoup box setup
StaticPopupDialogs["CommunityFlare_Popup_Dialog"] = {
	text = "Send: %s?",
	button1 = "Send",
	button2 = "No",
	OnAccept = function(self, message)
		if (CommFlareDB["SASID"] > 0) then
			local channelId = "Community:" .. CommFlareDB["SASID"] .. ":1"
			local id, name = GetChannelName(channelId)
			if ((id > 0) and (name ~= nil)) then
				SendChatMessage(message, "CHANNEL", nil, id)
			end
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- popup box to send community message
local function CommunityFlare_PopupBox(message)
	if (CommunityFlare_FindClubIDByName(cfCommunityName) > 0) then
		-- popup box setup
		local popup = StaticPopupDialogs["CommunityFlare_Popup_Dialog"]

		-- show the popup box
		variable1 = message
		local dialog = StaticPopup_Show("CommunityFlare_Popup_Dialog", message)
		if (dialog) then
			dialog.data = variable1
		end

		-- restore popup
		StaticPopupDialogs["CommunityFlare_Popup_Dialog"] = popup
	end
end

-- is sas leader?
local function CommunityFlare_IsSASLeader(name)
	for _,v in ipairs(f.sasLeaders) do
		if (name == v) then
			return true
		end
	end
	return false
end

-- get proper player name by type
local function CommunityFlare_GetPlayerName(type)
	local name,realm = UnitFullName("player")
	if (type == "full") then
		-- no realm name?
		if (not realm or (realm == "")) then
			realm = GetRealmName()
		end
		return strformat("%s-%s", name, realm)
	end
	return name
end

-- is currrently group leader?
local function CommunityFlare_IsGroupLeader()
	if (GetNumSubgroupMembers() == 0) then
		return true
	elseif (UnitIsGroupLeader("player")) then
		return true
	end
	return false
end

-- get total group count
local function CommunityFlare_GetGroupCount()
	local text = "1/5"
	if (IsInGroup()) then
		if (not IsInRaid()) then
			text = strformat("%d/5", GetNumGroupMembers())
		end
	end
	return text
end

-- get group members
local function CommunityFlare_GetGroupMemembers()
	local index = 1
	local players = {}

	-- are you grouped?
	if (IsInGroup()) then
		-- are you in a raid?
		if (not IsInRaid()) then
			for i=1, GetNumGroupMembers() do
				local name,realm = UnitName("party" .. i)

				-- add party member
				players[index] = {}
				players[index].guid = UnitGUID("party" .. i)
				players[index].name = name
				players[index].realm = realm

				-- next
				index = index + 1
			end
		end
	else
		-- add yourself
		players[index] = {}
		players[index].guid = UnitGUID("player")
		players[index].player = CommunityFlare_GetPlayerName("full")
	end
	return players
end

-- find community member by name
local function CommunityFlare_FindClubMemberByName(player)
	if (CommunityFlare_FindClubIDByName(cfCommunityName) > 0) then
		-- use short name for same realm as you
		local name,realm = strsplit("-", player, 2)
		if (realm == GetRealmName()) then
			player = name
		end

		-- search through club members
		local members = ClubGetClubMembers(CommFlareDB["SASID"])
		for _,v in ipairs(members) do
			local mi = ClubGetMemberInfo(CommFlareDB["SASID"], v);
			if (mi ~= nil) then
				if (mi.name == player) then
					return player
				end
			end
		end
	end
	return nil
end

-- find community member by guid
local function CommunityFlare_FindClubMemberByGUID(guid)
	if (CommunityFlare_FindClubIDByName(cfCommunityName) > 0) then
		local _,_,_,_,_,name,realm = GetPlayerInfoByGUID(guid)

		-- use short name for same realm as you
		local player = name
		if (realm) then
			-- already has realm
			player = player .. "-" .. realm
		else
			-- realm matches you
			realm = GetRealmName()
		end
		--print(strformat("guid: %s, player: %s-%s", guid, name, realm))

		-- search through club members
		local members = ClubGetClubMembers(CommFlareDB["SASID"])
		for _,v in ipairs(members) do
			local mi = ClubGetMemberInfo(CommFlareDB["SASID"], v);
			if (mi ~= nil) then
				if (mi.name == player) then
					return name, realm
				end
			end
		end
	end
	return nil, nil
end

-- send community message
local function CommunityFlare_SendCommunityMessage(text)
	if (CommunityFlare_FindClubIDByName(cfCommunityName) > 0) then
		local channelId = "Community:" .. CommFlareDB["SASID"] .. ":1"
		local id, name = GetChannelName(channelId)
		if ((id > 0) and (name ~= nil)) then
			print(text)
			--SendChatMessage(text, "CHANNEL", nil, id) -- needs protected hw click still! doh!
		end
	end
end

-- perform sync count down
local function CommunityFlare_Countdown(seconds)
	local counts = { "5", "4", "3", "2", "1", "Q" }

	-- process all counts
	--CommunityFlare_SendCommunityMessage("Don't mind me, testing something for Cinco! LoL!")
	for i=1, #counts do
		local text = string.format("Count: %s", counts[i])
		TimerAfter(i * seconds, function()
			CommunityFlare_SendCommunityMessage(text)
		end)
	end
end

-- find social queue by type
local function CommunityFlare_FindSocialQueueByType(type, guid, maxcount)
	local queues = SocialQueueGetGroupQueues(guid)
	if (queues) then
		-- has max count?
		if ((maxcount > 0) and (#queues > maxcount)) then
			return nil
		end

		-- process all queues
		for i=1, #queues do
			-- map name matches type?
			if (queues[i].queueData.mapName == type) then
				local queueData = queues[i].queueData
				return queueData
			end
		end
	end
	return nil
end

-- find group members
local function CommunityFlare_FindGroupMembers(guid)
	local players = {}

	-- get group members
	local members = SocialQueueGetGroupMembers(guid)
	if (not members) then
		return players
	end

	-- process all members
	local index = 1
	for i=1, #members do
		-- get player info by guid
		local _,_,_,_,_,name,realm = GetPlayerInfoByGUID(members[i].guid)
		if (not realm) then
			realm = GetRealmName()
		end

		-- save into table
		players[index] = {}
		players[index].guid = members[i].guid
		players[index].name = name
		players[index].realm = realm

		-- next
		index = index + 1
	end
	return players
end

-- find community queues
local function CommunityFlare_FindCommunityQueues(bPrint)
	-- reset list
	cfGroups = {}
	local index = 1

	-- are you in queue?
	if (cfQueueJoined == true) then
		-- are you group leader?
		if (CommunityFlare_IsGroupLeader() == true) then
			-- get name / realm for player
			local name,realm = UnitFullName("player")
			if (not realm) then
				realm = GetRealmName()
			end

			-- add your group
			cfGroups[index] = {}
			cfGroups[index].guid = UnitGUID("player")
			cfGroups[index].name = name
			cfGroups[index].realm = realm
			cfGroups[index].players = CommunityFlare_GetGroupMemembers()

			-- print enabled?
			if (bPrint == true) then
				print(strformat("Leader: %s-%s (%d/5)", cfGroups[index].name, cfGroups[index].realm, #cfGroups[index].players))
			end

			-- next
			index = index + 1
		end
	end

	-- get all groups
	local groups = SocialQueueGetAllGroups()

	-- print enabled
	if (bPrint == true) then
		print("Queues: ", #groups)
	end

	-- process all grouops
	for i=1, #groups do
		local canJoin,numQueues,_,_,_,_,_,leaderGUID = SocialQueueGetGroupInfo(groups[i])
		local name,realm = CommunityFlare_FindClubMemberByGUID(leaderGUID)
		if (name ~= nil) then
			local queueData = CommunityFlare_FindSocialQueueByType("Random Epic Battleground", groups[i], 1)
			if (queueData ~= nil) then
				-- save into table
				cfGroups[index] = {}
				cfGroups[index].guid = leaderGUID
				cfGroups[index].name = name
				cfGroups[index].realm = realm
				cfGroups[index].players = CommunityFlare_FindGroupMembers(groups[i])

				-- print enabled?
				if (bPrint == true) then
					print(strformat("Leader: %s-%s (%d/5)", cfGroups[index].name, cfGroups[index].realm, #cfGroups[index].players))
				end

				-- next
				index = index + 1
			end
		end
	end

	-- empty?
	if (#cfGroups == 0) then
		-- print enabled
		if (bPrint == true) then
			print("List: No one currently in queue!")
		end
		return false
	end
	return true
end

-- report groups
local function CommunityFlare_ReportGroups()
	-- empty?
	if (#cfGroups == 0) then
		-- search for community queues
		if (CommunityFlare_FindCommunityQueues(false) == false) then
			print("Report: No one currently in queue!")
			return false
		end
	end

	-- build groups list
	local text
	local list = ""
	for i=1, #cfGroups do
		-- add to list without realm (shorter)
		text = strformat("%s: %d/5", cfGroups[i].name, #cfGroups[i].players)
		if (list == "") then
			list = text
		else
			list = list .. ", " .. text
		end
	end

	-- has list?
	if (list ~= "") then
		-- community reporter enabled?
		print("Report: ", list)
		if (CommFlareDB["communityReporter"] == true) then
			CommunityFlare_PopupBox(list)
		end
		return true
	end
	print("Report: No one currently in queue!")
	return false
end

-- display joined & popped status
local function CommunityFlare_GetStatus()
	print("cfGroupInvited:" , cfGroupInvited)
	print("cfQueueJoined: ", cfQueueJoined)
	print("cfQueuePopped: ", cfQueuePopped)
end

-- check if a unit has type aura active
local function CommunityFlare_CheckForAura(unit, type, auraName)
	-- save global variable if aura is active
	cfHasAura = false
	AuraUtilForEachAura(unit, type, nil, function(name, icon, ...)
		if (name == auraName) then
			cfHasAura = true
			return true
		end
	end)
end

-- is specialization healer?
local function CommunityFlare_IsHealer(spec)
	if (spec == "Discipline") then
		return true
	elseif (spec == "Holy") then
		return true
	elseif (spec == "Mistweaver") then
		return true
	elseif (spec == "Restoration") then
		return true
	end
	return false
end

-- is specialization tank?
local function CommunityFlare_IsTank(spec)
	if (spec == "Blood") then
		return true
	elseif (spec == "Brewmaster") then
		return true
	elseif (spec == "Guardian") then
		return true
	elseif (spec == "Protection") then
		return true
	elseif (spec == "Vengeance") then
		return true
	end
	return false
end

-- is currently in battleground?
local function CommunityFlare_IsInBattleground()
	-- check if currently in queue
	for i=1, GetMaxBattlefieldID() do
		local status = GetBattlefieldStatus(i)
		if (status == "active") then
			return true
		end
	end
	return false
end

-- get current party leader
local function CommunityFlare_GetPartyLeader()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then 
			local name,realm = UnitName("party" .. i)
			if (realm ~= nil) then
				return strformat("%s-%s", name, realm)
			end
			return name
		end
	end

	-- solo queued atm
	return CommunityFlare_GetPlayerName("full")
end

-- get player raid rank
local function CommunityFlare_GetRaidRank(player)
	-- process all raid members
	for i=1, MAX_RAID_MEMBERS do
		local name, rank = GetRaidRosterInfo(i)
		if (player == name) then
			return rank
		end
	end
	return nil
end

-- promote player to leader
local function CommunityFlare_Battleground_PromoteToLeader(player)
	-- use short name for same realm as you
	local name,realm = strsplit("-", player, 2)
	if (realm == GetRealmName()) then
		player = name
	end

	-- unit is in raid?
	if (UnitInRaid(player) ~= nil) then
		PromoteToLeader(player)
		return true
	end
	return false
end

-- count stuff in battlegrounds and promote to assists
local function CommunityFlare_Battleground_Setup(type)
	-- count some stuff
	numHorde = 0
	numAlliance = 0
	numHordeTanks = 0
	numHordeHealers = 0
	numAllianceTanks = 0
	numAllianceHealers = 0
	numScores = GetNumBattlefieldScores()
	if (numScores == 0) then
		print("SAS: Not in Battleground yet")
		return
	end
	for i=1, numScores do
		local name,_,_,_,_,faction,_,_,_,_,_,_,_,_,_,spec = GetBattlefieldScore(i)
		-- if (name == "Mesostealthy") then
		--	 print("Index: ", i)
		-- end
		if (faction) then
			isTank = CommunityFlare_IsTank(spec)
			isHealer = CommunityFlare_IsHealer(spec)
			if (faction == 0) then
				numHorde = numHorde + 1
				if (isHealer == true) then
					numHordeHealers = numHordeHealers + 1
				elseif (isTank == true) then
					numHordeTanks = numHordeTanks + 1
				end
			else
				numAlliance = numAlliance + 1
				if (isHealer == true) then
					numAllianceHealers = numAllianceHealers + 1
				elseif (isTank == true) then
					numAllianceTanks = numAllianceTanks + 1
				end
			end
		end
	end
	print(strformat("Horde: Healers = %d, Tanks = %d", numHordeHealers, numHordeTanks))
	print(strformat("Alliance: Healers = %d, Tanks = %d", numAllianceHealers, numAllianceTanks))

	-- find SAS members
	count = 0
	playerList = nil
	local player = UnitName("player")
	local rank = CommunityFlare_GetRaidRank(player)
	if (CommunityFlare_FindClubIDByName(cfCommunityName) > 0) then
		local members = ClubGetClubMembers(CommFlareDB["SASID"])
		for _,v in ipairs(members) do
			local mi = ClubGetMemberInfo(CommFlareDB["SASID"], v);
			if (mi ~= nil) then
				if (UnitInRaid(mi.name) ~= nil) then
					-- processing player list too?
					if (type == "full") then
						-- list still empty? start it!
						if (playerList == nil) then
							playerList = mi.name
						else
							playerList = playerList .. ", " .. mi.name
						end
					end

					-- player has raid leader?
					if (rank == 2) then
						PromoteToAssistant(mi.name)
					end

					-- next
					count = count + 1
				end
			end
		end
	end
	if (playerList ~= nil) then
		print("SAS: ", playerList)
	end
	print("Found: ", count)
end

-- setup stuff to automatically accept queues
local function CommunityFlare_AutoAcceptQueues()
	LFDRoleCheckPopupAcceptButton:SetScript("OnShow", function()
		-- check if should auto queue
		local autoQueue = false
		if (not IsInRaid()) then
			if (CommFlareDB["alwaysAutoQueue"] == true) then
				autoQueue = true
			elseif (CommFlareDB["communityAutoQueue"] == true) then
				local player = CommunityFlare_FindClubMemberByName(CommunityFlare_GetPartyLeader())
				if (player ~= nil) then
					autoQueue = true
				end
			end
		end

		-- auto queue enabled?
		if (autoQueue == true) then
			CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
			if (cfHasAura == false) then
				cfQueueJoined = true
				cfQueuePopped = false
				LFDRoleCheckPopupAcceptButton:Click()
			else
				SendChatMessage("Sorry, I currently have Deserter! Leaving party to avoid interrupting the queue!", "PARTY")
				PartyInfoLeaveParty()
			end
		end
	end)
end

-- setup stuff to process queue pops
local function CommunityFlare_ProcessQueuePops()
	hooksecurefunc("PVPReadyDialog_Display", function(self, index, displayName, isRated, queueType, gameType, role)
		-- process random epic battlegrounds only
		if (displayName == "Random Epic Battleground") then
			if (GetBattlefieldPortExpiration(index) > 0) then
				-- community reporter enabled?
				if (CommFlareDB["communityReporter"] == true) then
					if (CommunityFlare_IsGroupLeader() == true) then
						CommunityFlare_PopupBox(strformat("%s Queue Popped!", CommunityFlare_GetGroupCount()))
					end
				end
				cfQueueJoined = false
				cfQueuePopped = true
			end
		else
			cfQueueJoined = false
			cfQueuePopped = false
		end
	end)
	PVPReadyDialogEnterBattleButton:HookScript("OnClick", function()
		cfQueueJoined = false
		cfQueuePopped = false
	end)
	PVPReadyDialog:HookScript("OnHide", function(self)
		for i=1, GetMaxBattlefieldID() do
			local status = GetBattlefieldStatus(i)
			if (status == "active") then
				cfQueuePopped = false
			end
		end
		TimerAfter(1.5, function()
			-- has queue popped?
			if (cfQueuePopped == true) then
				-- community reporter enabled?
				if (CommFlareDB["communityReporter"] == true) then
					CommunityFlare_PopupBox(strformat("%s Missed Queue!", CommunityFlare_GetPlayerName("short")))
				end
				cfQueuePopped = false
			end
		end)
	end)

	-- check if currently in queue
	for i=1, GetMaxBattlefieldID() do
		local status, mapName = GetBattlefieldStatus(i)
		if (mapName == "Random Epic Battleground") then
			local mseconds = GetBattlefieldTimeWaited(i)
			if (mseconds > 0) then
				cfQueueJoined = true
			end
		end
	end
end

-- process addon messages
local function CommunityFlare_ProcessAddonMessage(sender, text)
	-- get queue time?
	if (text == "GetQueueTime") then
		-- get current time in queue
		local mseconds = 0
		for i=1, GetMaxBattlefieldID() do
			local status,mapName = GetBattlefieldStatus(i)
			if (mapName == "Random Epic Battleground") then
				mseconds = GetBattlefieldTimeWaited(i)
				if (mseconds > 0) then
					break
				end
			end
		end

		-- send current time in queue
		local leader = CommunityFlare_GetPartyLeader()
		ChatInfoSendAddonMessage("CommFlare", strformat("CurQueueTime:%s:%s", mseconds, leader), "WHISPER", sender)
		return true
	-- get version?
	elseif (text == "GetVersion") then
		-- send current version
		ChatInfoSendAddonMessage("CommFlare", strformat("CurVersion:%s", cfVersion), "WHISPER", sender)
		return true
	-- read response from current queue time
	elseif (strfind(text, "CurQueueTime:")) then
		-- setup arguments
		local command,mseconds,leader = strsplit(":", text, 3)
		if (not leader) then
			leader = sender
		end

		-- check milliseconds
		if (mseconds == "0") then
			-- not currently in queue
			print(strformat("%s is not currently in queue.", leader))
		else
			-- calculate minutes / seconds
			local seconds = math.floor(mseconds / 1000)
			local minutes = math.floor(seconds / 60)
			print(strformat("%s has been queued for %d minutes and %d seconds.", leader, minutes, seconds))
		end
		return true
	-- read response from current version
	elseif (strfind(text, "CurVersion:")) then
		-- display sender version
		local command,version = strsplit(":", text, 2)
		print(strformat("%s has version %s.", sender, version))
		return true
	end
	return false
end

-- process all hooked events
local function CommunityFlare_EventHandler(self, event, ...)
	if (event == "ADDON_LOADED") then
		local addOnName = ...
		if (addOnName == "Community_Flare") then
			CommFlareDB = _G.CommFlareDB or {}
			if (CommFlareDB) then
				for opt,val in pairs(CommFlare_DefaultOptions) do
					if (CommFlareDB[opt] == nil) then
						CommFlareDB[opt] = val
					end
				end
			else
				CommFlareDB = CommFlare_DefaultOptions
			end
			self.db = CommFlareDB
			self:SetupOptions()
		end
	elseif (event == "CHAT_MSG_BN_WHISPER") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		text = strlower(text)
		if (text == "!cf") then
			-- send community flare version number
			BNSendWhisper(bnSenderID, strformat("Community Flare: %s", cfVersion))
		elseif ((text == "inv") or (text == "invite")) then
			-- battle net auto invite enabled?
			if (CommFlareDB["bnetAutoInvite"] == true) then
				if (CommunityFlare_IsInBattleground() == true) then
					BNSendWhisper(bnSenderID, "Sorry, currently in Battleground now.")
				else
					-- get bnet friend index
					local index = BNGetFriendIndex(bnSenderID)
					if (index ~= nil) then
						-- process all bnet accounts logged in
						local numGameAccounts = BattleNetGetFriendNumGameAccounts(index);
						for i=1, numGameAccounts do
							-- check if account has player guid online
							local gameAccountInfo = BattleNetGetFriendGameAccountInfo(index, i);
							if (gameAccountInfo.playerGuid) then
								if (CommunityFlare_IsGroupLeader() == true) then
									if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
										BNSendWhisper(bnSenderID, "Sorry, group is currently full.")
									else
										BNInviteFriend(gameAccountInfo.gameAccountID)
									end
								end
								break
							end
						end
					end
				end
			end
		end
	elseif ((event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER")) then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		-- skip messages from yourself
		if (CommunityFlare_GetPlayerName("full") ~= sender) then
			text = strlower(text)
			if (text == "!cf") then
				-- send community flare version number
				SendChatMessage(strformat("Community Flare: %s", cfVersion), "PARTY")
			end
		end
	elseif (event == "CHAT_MSG_SYSTEM") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		text = strlower(text)
		if (text:find("everyone is ready")) then
			-- community reporter enabled?
			if (CommFlareDB["communityReporter"] == true) then
				-- currently out of queue?
				if (cfQueueJoined == false) then
					if (CommunityFlare_IsGroupLeader() == true) then
						CommunityFlare_PopupBox(strformat("%s Ready!", CommunityFlare_GetGroupCount()))
					end
				end
			end
		elseif (text:find("has invited you to join a group")) then
			-- invited to group
			cfGroupInvited = true
			TimerAfter(2, function()
				-- resets if not in queue
				cfGroupInvited = false
			end)
		elseif (text:find("has joined the instance group")) then
			-- community auto promote leader enabled?
			if (CommFlareDB["communityAutoPromoteLeader"] == true) then
				-- not sas leader?
				local player = CommunityFlare_GetPlayerName("full")
				if (not CommunityFlare_IsSASLeader(player)) then
					-- do you have lead?
					local rank = CommunityFlare_GetRaidRank(UnitName("player"))
					if (rank == 2) then
						-- process all sas leaders
						for _,v in ipairs(f.sasLeaders) do
							if (player == v) then
								break
							end
							if (CommunityFlare_Battleground_PromoteToLeader(v) == true) then
								break
							end
						end
					end
				end
			end
		elseif (text:find("joined the queue for random epic battleground")) then
			-- being invited to a group already in queue
			if (cfGroupInvited == true) then
				-- no invite pending
				cfGroupInvited = false
			else
				-- community reporter enabled?
				if (CommFlareDB["communityReporter"] == true) then
					-- currently out of queue?
					if (cfQueueJoined == false) then
						if (CommunityFlare_IsGroupLeader() == true) then
							CommunityFlare_PopupBox(strformat("%s Joined Queue!", CommunityFlare_GetGroupCount()))
						end
					end
				end
			end

			-- joined, not popped
			cfQueueJoined = true
			cfQueuePopped = false
		elseif (text:find("notify system has been enabled")) then
			-- use full list for meso
			local type = "short"
			local player = CommunityFlare_GetPlayerName(type)
			if ((player == "Mesostealthy") or (player == "Lifestooport") or (player == "Shotdasherif")) then
				type = "full"
			end

			-- display battleground setup
			CommunityFlare_Battleground_Setup(type)
		elseif (text:find("you are no longer queued")) then
			-- community reporter enabled?
			if (CommFlareDB["communityReporter"] == true) then
				-- currently in queue?
				if (cfQueueJoined == true) then
					if (CommunityFlare_IsGroupLeader() == true) then
						CommunityFlare_PopupBox(strformat("%s Dropped Queue!", CommunityFlare_GetGroupCount()))
					end
				end
			end

			-- not joined, nor popped
			cfQueueJoined = false
			cfQueuePopped = false
		elseif (text:find("you leave the group") or text:find("your team has left the queue")) then
			-- not joined, nor popped
			cfQueueJoined = false
			cfQueuePopped = false
		end
	elseif (event == "CHAT_MSG_WHISPER") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		text = strlower(text)
		if (text == "!cf") then
			-- send community flare version number
			SendChatMessage(strformat("Community Flare: %s", cfVersion), "WHISPER", nil, sender)
		elseif (text == "!pl") then
			-- not sas leader?
			local player = CommunityFlare_GetPlayerName("full")
			if (not CommunityFlare_IsSASLeader(player)) then
				-- do you have lead?
				local rank = CommunityFlare_GetRaidRank(UnitName("player"))
				if (rank == 2) then
					-- sas leader?
					if (CommunityFlare_IsSASLeader(sender)) then
						CommunityFlare_Battleground_PromoteToLeader(sender)
					end
				end
			end
		elseif ((text == "inv") or (text == "invite")) then
			-- community auto invite enabled?
			if (CommFlareDB["communityAutoInvite"] == true) then
				-- already deployed in a battleground?
				if (CommunityFlare_IsInBattleground() == true) then
					SendChatMessage("Sorry, currently in Battleground now.", "WHISPER", nil, sender)
				else
					-- sender is from the community?
					if (CommunityFlare_FindClubMemberByName(sender) ~= nil) then
						if (CommunityFlare_IsGroupLeader() == true) then
							if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
								SendChatMessage("Sorry, group is currently full.", "WHISPER", nil, sender)
							else
								PartyInfoInviteUnit(sender)
							end
						end
					end
				end
			end
		end
	elseif (event == "GROUP_INVITE_CONFIRMATION") then
		local text = StaticPopup1Text["text_arg1"]
		text = strlower(text)
		if (strfind(text, "you will be removed from") and strfind(text, "random epic battleground")) then
			if (StaticPopup1:IsShown()) then
				StaticPopup1Button2:Click()
			end
		end
	elseif (event == "PARTY_INVITE_REQUEST") then
		local sender,_,_,_,_,_,guid,questSessionActive = ...
		-- verify player does not have deserter debuff
		CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
		if (cfHasAura == false) then
			-- community auto invite enabled?
			if (CommFlareDB["communityAutoInvite"] == true) then
				if (CommunityFlare_FindClubMemberByName(sender) ~= nil) then
					if (LFGInvitePopup:IsShown()) then
						LFGInvitePopupAcceptButton:Click()
					end
				end
			end
		else
			-- send whisper back that you have deserter
			SendChatMessage("Sorry, I currently have Deserter!", "WHISPER", nil, sender)
			if (LFGInvitePopup:IsShown()) then
				LFGInvitePopupDeclineButton:Click()
			end
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isInitialLogin, isReloadingUi = ...
		if ((isInitialLogin) or (isReloadingUi)) then
			print("Community Flare: ", cfVersion)
			TimerAfter(2, function()
				-- get proper sas community id
				CommFlareDB["SASID"] = CommunityFlare_FindClubIDByName(cfCommunityName)
			end)
		end
	elseif (event == "PLAYER_LOGIN") then
		-- event hooks not enabled yet?
		if (cfEventHandlerLoaded == false) then
			-- add extra event handlers
			CommunityFlare_AutoAcceptQueues()
			CommunityFlare_ProcessQueuePops()
			cfEventHandlerLoaded = true
		end
	elseif (event == "PLAYER_LOGOUT") then
		_G.CommFlareDB = CommFlareDB
	elseif (event == "READY_CHECK") then
		local sender, timeleft = ...

		-- does the player have the mercenary buff?
		CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
		if (cfHasAura == true) then
			SendChatMessage("I currently have the Mercenary Contract BUFF! (Are we mercing?)", "PARTY")
		end

		-- check if should auto queue
		local autoQueue = false
		if (not IsInRaid()) then
			if (CommFlareDB["alwaysAutoQueue"] == true) then
				autoQueue = true
			elseif (CommFlareDB["communityAutoQueue"] == true) then
				if (CommunityFlare_FindClubMemberByName(sender) ~= nil) then
					autoQueue = true
				end
			end
		end

		-- auto queue enabled?
		if (autoQueue == true) then
			-- verify player does not have deserter debuff
			CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
			if (cfHasAura == false) then
				if (ReadyCheckFrame:IsShown()) then
					ReadyCheckFrameYesButton:Click()
				end
			else
				-- send back to party that you have deserter
				SendChatMessage("Sorry, I currently have Deserter!", "PARTY")
				if (ReadyCheckFrame:IsShown()) then
					ReadyCheckFrameNoButton:Click()
				end
			end
		end
	elseif (event == "SOCIAL_QUEUE_UPDATE") then
		-- TODO: find when queues get sync'd / joined / added
		local guid,numAdded = ...
		local canJoin,numQueues,_,_,_,_,_,leaderGUID = SocialQueueGetGroupInfo(guid)
		local queues = SocialQueueGetGroupQueues(guid)
		local members = SocialQueueGetGroupMembers(guid)
		--print(strformat("GroupInfo: %d, %d, %s", canJoin, numQueues, leaderGUID))
		--DevTools_Dump(queues)
		--DevTools_Dump(members)
	elseif (event == "UI_INFO_MESSAGE") then
		local number, text = ...
		text = strlower(text)
		if (text:find("deserter")) then
			print("Someone has Deserter debuff!")
		end
	end
end
f:SetScript("OnEvent", CommunityFlare_EventHandler)

-- process comf slash command
SlashCmdList["COMF"] = function(cmd)
	cmd = strlower(cmd)
	if (cmd == "gpn") then
		print("Full Name: ", CommunityFlare_GetPlayerName("full"))
		print("Short Name: ", CommunityFlare_GetPlayerName("short"))
	elseif (cmd == "gpl") then
		print("Leader: ", CommunityFlare_GetPartyLeader())
	elseif (cmd == "ggc") then
		print("isLeader: ", CommunityFlare_IsGroupLeader())
		print("Player: ", CommunityFlare_GetPlayerName("full"))
		print("Count: ", CommunityFlare_GetGroupCount())
	elseif (cmd == "list") then
		CommunityFlare_FindCommunityQueues(true)
	elseif (cmd == "options") then
		DevTools_Dump(CommFlareDB)
	elseif (cmd == "phd") then
		CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
		print("Deserter: ", cfHasAura)
	elseif (cmd == "report") then
		local player = CommunityFlare_GetPlayerName("short")
		if ((player == "Mesostealthy") or (player == "Lifestooport") or (player == "Shotdasherif")) then
			CommunityFlare_ReportGroups()
		else
			print("Report: Not quite ready for the masses.")
		end
	elseif (cmd == "reset all") then
		CommFlareDB = CommFlare_DefaultOptions
	elseif (cmd == "sasid") then
		-- get proper sas community id
		CommFlareDB["SASID"] = CommunityFlare_FindClubIDByName(cfCommunityName)
		print("SASID: ", CommFlareDB["SASID"])
	elseif (cmd == "status") then
		CommunityFlare_GetStatus()
	elseif (cmd == "usage") then
		print("CPU Usage: ", GetAddOnCPUUsage("Community_Flare"))
		print("Memory Usage: ", GetAddOnMemoryUsage("Community_Flare"))
	else
		-- display full battleground setup
		CommunityFlare_Battleground_Setup("full")
	end
end
