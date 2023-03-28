-- initialize
SLASH_COMF1 = "/comf"
local addonName, mod = ...
local CommFlareDB = _G.CommFlareDB or {}

-- initialize CF
local CF = {
	-- strings
	CommName = "Savage Alliance Slayers",
	Version = "v0.16",

	-- booleans
	AutoPromote = false,
	AutoQueue = false,
	AutoQueueable = false,
	EventHandlerLoaded = false,
	GroupInvited = false,
	HasAura = false,
	QueueJoined = false,
	QueuePopped = false,
	Reloaded = false,

	-- numbers
	Count = 0,
	IsHealer = 0,
	IsTank = 0,
	MapID = 0,
	MatchStatus = 0,
	NumScores = 0,
	PlayerRank = 0,
	Position = 0,
	SavedTime = 0,

	-- misc
	Category = nil,
	Header = nil,
	Leader = nil,
	PlayerList = nil,
	PopupMessage = nil,

	-- tables
	CheckBox = {},
	CheckBoxes = {},
	Clubs = {},
	ClubMembers = {},
	Dropdown = {},
	Groups = {},
	MapInfo = {},
	POIInfo = {},
	ScoreInfo = {},
	SettingsInfo = {},
	SocialGroups = {},
	SocialMembers = {},
	SocialQueues = {},

	-- misc stuff
	Alliance = { Count = 0, Healers = 0, Tanks = 0 },
	Horde = { Count = 0, Healers = 0, Tanks = 0 },
	Timer = { Minutes = 0, MilliSeconds = 0, Seconds = 0 },

	-- battleground specific data
	ASH = {},
	AV = {},
	IOC = {},
	WG = {}
}

-- initialize leaders
local sasLeaders = {
	"Cinco-CenarionCircle",
	"Mesostealthy-Dentarg",
	"Lifestooport-Dentarg",
	"Shotdasherif-Dentarg",
	"Angelsong-BlackwaterRaiders",
	"Faeryna-BlackwaterRaiders",
	"Shanlie-CenarionCircle",
	"Kroog-CenarionCircle",
	"Leyoterk-CenarionCircle",
	"Krolak-Proudmoore",
	"Greenbeans-CenarionCircle"
}

-- initialize defaults
local defaultOptions = {
	SASID = 0,
	alwaysAutoQueue = false,
	bnetAutoInvite = false,
	communityAutoAssist = 1,
	communityAutoInvite = true,
	communityAutoPromoteLeader = true,
	communityAutoQueue = true,
	communityReporter = true
}

-- initialize assist options
local autoAssistOptions = {
	{ text = "None", value = 0 },
	{ text = "Leaders Only", value = 1 },
	{ text = "All SAS Members", value = 2 }
}

-- localize stuff
local _G                                        = _G
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNInviteFriend                            = _G.BNInviteFriend
local BNSendWhisper                             = _G.BNSendWhisper
local CreateFrame                               = _G.CreateFrame
local DevTools_Dump                             = _G.DevTools_Dump
local GetAddOnCPUUsage                          = _G.GetAddOnCPUUsage
local GetAddOnMemoryUsage                       = _G.GetAddOnMemoryUsage
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetChannelName                            = _G.GetChannelName
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumBattlefieldScores                   = _G.GetNumBattlefieldScores
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local GetPlayerInfoByGUID                       = _G.GetPlayerInfoByGUID
local GetRaidRosterInfo                         = _G.GetRaidRosterInfo
local GetRealmName                              = _G.GetRealmName
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToAssistant                        = _G.PromoteToAssistant
local PromoteToLeader                           = _G.PromoteToLeader
local SlashCmdList                              = _G.SlashCmdList
local SendChatMessage                           = _G.SendChatMessage
local StaticPopupDialogs                        = _G.StaticPopupDialogs
local StaticPopup_Show                          = _G.StaticPopup_Show
local StaticPopup1                              = _G.StaticPopup1
local StaticPopup1Text                          = _G.StaticPopup1Text
local UIDropDownMenu_AddButton                  = _G.UIDropDownMenu_AddButton
local UIDropDownMenu_CreateInfo                 = _G.UIDropDownMenu_CreateInfo
local UIDropDownMenu_Initialize                 = _G.UIDropDownMenu_Initialize
local UIDropDownMenu_SetText                    = _G.UIDropDownMenu_SetText
local UIDropDownMenu_SetWidth                   = _G.UIDropDownMenu_SetWidth
local UnitFullName                              = _G.UnitFullName
local UnitGUID                                  = _G.UnitGUID
local UnitInRaid                                = _G.UnitInRaid
local UnitIsGroupLeader                         = _G.UnitIsGroupLeader
local UnitName                                  = _G.UnitName
local AuraUtilForEachAura                       = _G.AuraUtil.ForEachAura
local AreaPoiInfo_GetAreaPOIForMap              = _G.C_AreaPoiInfo.GetAreaPOIForMap
local AreaPoiInfo_GetAreaPOIInfo                = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local ChatInfoRegisterAddonMessagePrefix        = _G.C_ChatInfo.RegisterAddonMessagePrefix
local ChatInfoSendAddonMessage                  = _G.C_ChatInfo.SendAddonMessage
local ClubGetClubMembers                        = _G.C_Club.GetClubMembers
local ClubGetMemberInfo                         = _G.C_Club.GetMemberInfo
local ClubGetSubscribedClubs                    = _G.C_Club.GetSubscribedClubs
local Map_GetBestMapForUnit                     = _G.C_Map.GetBestMapForUnit
local Map_GetMapInfo                            = _G.C_Map.GetMapInfo
local PartyInfoIsPartyFull                      = _G.C_PartyInfo.IsPartyFull
local PartyInfoInviteUnit                       = _G.C_PartyInfo.InviteUnit
local PartyInfoLeaveParty                       = _G.C_PartyInfo.LeaveParty
local PvP_GetActiveMatchState                   = _G.C_PvP.GetActiveMatchState
local PvP_GetActiveMatchDuration                = _G.C_PvP.GetActiveMatchDuration
local PvP_GetScoreInfo                          = _G.C_PvP.GetScoreInfo
local PvP_IsBattleground                        = _G.C_PvP.IsBattleground
local Settings_RegisterCanvasLayoutCategory     = _G.Settings.RegisterCanvasLayoutCategory
local SocialQueueGetAllGroups                   = _G.C_SocialQueue.GetAllGroups
local SocialQueueGetGroupInfo                   = _G.C_SocialQueue.GetGroupInfo
local SocialQueueGetGroupMembers                = _G.C_SocialQueue.GetGroupMembers
local SocialQueueGetGroupQueues                 = _G.C_SocialQueue.GetGroupQueues
local TimerAfter                                = _G.C_Timer.After
local GetDoubleStatusBarWidgetVisualizationInfo = _G.C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo
local GetIconAndTextWidgetVisualizationInfo     = _G.C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo
local hooksecurefunc                            = _G.hooksecurefunc
local ipairs                                    = _G.ipairs
local pairs                                     = _G.pairs
local print                                     = _G.print
local time                                      = _G.time
local type                                      = _G.type
local strfind                                   = _G.string.find
local strformat                                 = _G.string.format
local strlower                                  = _G.string.lower

-- create frames
local f = CreateFrame("FRAME")
local options = CreateFrame("FRAME")

-- refresh settings
local function Community_Flare_Settings_Refresh()
	-- setup all checkboxes
	for k,v in pairs(CF.CheckBoxes) do
		if (CommFlareDB[k] == true) then
			CF.CheckBoxes[k]:SetChecked(true)
		else
			CF.CheckBoxes[k]:SetChecked(false)
		end
	end

	-- setup dropdowns
	for i=1, #autoAssistOptions do
		if (CommFlareDB.communityAutoAssist == autoAssistOptions[i].value) then
			UIDropDownMenu_SetText(CF.Dropdown, autoAssistOptions[i].text)
		end
	end
end

-- create checkbox setting
CF.Position = -20
local function CommunityFlare_Settings_CreateCheckBox(parent, field, text)
	-- create the box
	CF.CheckBox = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
	CF.CheckBox:SetPoint("TOPLEFT", 20, CF.Position)
	CF.CheckBox.Text:SetText(text)
	CF.Position = CF.Position - 30

	-- handle OnClick
	CF.CheckBox:SetScript("OnClick", function()
		if (CommFlareDB[field] == true) then
			CommFlareDB[field] = false
		else
			CommFlareDB[field] = true
		end
	end)
	CF.CheckBoxes[field] = CF.CheckBox
end

-- set value for auto assist option
local function CommunityFlare_DropDown_OnClick(self, field, index)
	-- communityAutoAssist?
	if (field == "communityAutoAssist") then
		-- update setting
		CommFlareDB[field] = autoAssistOptions[index].value
	end

	-- refresh settings
	Community_Flare_Settings_Refresh()
end

-- initialize auto assist drop down
local function CommunityFlare_DropDown_Initialize(dropDown, level, ...)
	-- create the drop down
	CF.SettingsInfo = UIDropDownMenu_CreateInfo()
	CF.SettingsInfo.owner = dropDown
	CF.SettingsInfo.func = CommunityFlare_DropDown_OnClick

	-- AutoAssistDropDown?
	local field = nil
	local options = {}
	local name = dropDown:GetName()
	if (name == "AutoAssistDropDown") then
		-- initialize stuff
		field = "communityAutoAssist"
		options = autoAssistOptions
	end

	-- has field and options?
	if (field and options and (#options > 0)) then
		-- create buttons
		for i=1, #options do
			CF.SettingsInfo.text = options[i].text
			CF.SettingsInfo.arg1 = field
			CF.SettingsInfo.arg2 = i
			CF.SettingsInfo.checked = nil
			CF.SettingsInfo.value = options[i].value
			if (CommFlareDB[field] == options[i].value) then
				CF.SettingsInfo.checked = 1
				UIDropDownMenu_SetText(dropDown, options[i].text)
				dropDown.value = options[i].value
			end
			UIDropDownMenu_AddButton(CF.SettingsInfo)
		end
	end
end

-- create down setting
local function CommunityFlare_Settings_CreateDropDown(parent, name, menuList)
	-- create the dropdown
	CF.Dropdown = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
	CF.Dropdown:SetPoint("TOPLEFT", 20, CF.Position)
	CF.Position = CF.Position - 30
	CF.Dropdown.menuList = menuList
	UIDropDownMenu_SetWidth(CF.Dropdown, 150)
	UIDropDownMenu_Initialize(CF.Dropdown, CommunityFlare_DropDown_Initialize)
	UIDropDownMenu_SetText(CF.Dropdown, "Choose One")
end

-- header
CF.Header = options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
CF.Header:SetPoint("TOPLEFT", 20, CF.Position)
CF.Header:SetText("General")
CF.Position = CF.Position - 25

-- create checkboxes
CommunityFlare_Settings_CreateCheckBox(options, "alwaysAutoQueue", "Always automatically queue")
CommunityFlare_Settings_CreateCheckBox(options, "communityAutoQueue", "Auto queue (If leader is SAS)")
CommunityFlare_Settings_CreateCheckBox(options, "communityAutoInvite", "Auto invite SAS (If you are leader and have room)")
CommunityFlare_Settings_CreateCheckBox(options, "bnetAutoInvite", "Auto invite BNET (If you are leader and have room)")
CommunityFlare_Settings_CreateCheckBox(options, "communityAutoPromoteLeader", "Auto promote leaders in SAS (If you are raid leader)")
CommunityFlare_Settings_CreateCheckBox(options, "communityReporter", "Report queues to SAS")
CF.Position = CF.Position - 20

-- battleground settings
CF.Header = options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
CF.Header:SetPoint("TOPLEFT", 20, CF.Position)
CF.Header:SetText("Battleground Settings")
CF.Position = CF.Position - 25

-- auto assist
CF.Header = options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
CF.Header:SetPoint("TOPLEFT", 20, CF.Position)
CF.Header:SetTextColor(1.0, 1.0, 1.0, 1.0)
CF.Header:SetText("Auto assist inside battlegrounds (If you are raid leader)")
CF.Position = CF.Position - 20
CommunityFlare_Settings_CreateDropDown(options, "AutoAssistDropDown", "autoAssistOptions")

-- register addon category in settings panel
options:SetScript("OnShow", Community_Flare_Settings_Refresh)
CF.Category = Settings_RegisterCanvasLayoutCategory(options, "Community Flare")
Settings.RegisterAddOnCategory(CF.Category)

-- register all necessary events
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_BN_WHISPER")
f:RegisterEvent("CHAT_MSG_PARTY")
f:RegisterEvent("CHAT_MSG_PARTY_LEADER")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("CHAT_MSG_MONSTER_YELL")
f:RegisterEvent("GROUP_INVITE_CONFIRMATION")
f:RegisterEvent("NOTIFY_PVP_AFK_RESULT")
f:RegisterEvent("PARTY_INVITE_REQUEST")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOGOUT")
f:RegisterEvent("PVP_MATCH_ACTIVE")
f:RegisterEvent("PVP_MATCH_COMPLETE")
f:RegisterEvent("PVP_MATCH_INACTIVE")
f:RegisterEvent("READY_CHECK")
f:RegisterEvent("SOCIAL_QUEUE_UPDATE")
f:RegisterEvent("UI_INFO_MESSAGE")

-- load session variables
local function CommunityFlare_LoadSession()
	-- misc stuff
	CF.MatchStatus = CommFlareDB.MatchStatus

	-- battleground specific data
	CF.ASH = CommFlareDB.ASH
	CF.AV = CommFlareDB.AV
	CF.IOC = CommFlareDB.IOC
	CF.WG = CommFlareDB.WG
end

-- save session variables
local function CommunityFlare_SaveSession()
	-- misc stuff
	CommFlareDB.SavedTime = time()
	CommFlareDB.MatchStatus = CF.MatchStatus

	-- currently in battleground?
	if (PvP_IsBattleground() == true) then
		-- save any settings
		CommFlareDB.ASH = CF.ASH
		CommFlareDB.AV = CF.AV
		CommFlareDB.IOC = CF.IOC
		CommFlareDB.WG = CF.WG
	else
		-- reset settings
		CommFlareDB.ASH = {}
		CommFlareDB.AV = {}
		CommFlareDB.IOC = {}
		CommFlareDB.WG = {}
	end
end

-- send to party, whisper, or bnet message
local function CommunityFlare_SendMessage(sender, msg)
	-- party?
	if (not sender) then
		SendChatMessage(msg, "PARTY")
	-- string?
	elseif (type(sender) == "string") then
		SendChatMessage(msg, "WHISPER", nil, sender)
	elseif (type(sender) == "number") then
		BNSendWhisper(sender, msg)
	end
end

-- find community id by name
local function CommunityFlare_FindClubIDByName(name)
	-- has SASID already?
	if (CommFlareDB.SASID > 0) then
		return CommFlareDB.SASID
	end

	-- process all subscribed communities
	CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(CF.Clubs) do
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
		if (CommFlareDB.SASID > 0) then
			local channelId = "Community:" .. CommFlareDB.SASID .. ":1"
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
	-- found sas id?
	if (CommunityFlare_FindClubIDByName(CF.CommName) > 0) then
		-- popup box setup
		local popup = StaticPopupDialogs["CommunityFlare_Popup_Dialog"]

		-- show the popup box
		CF.PopupMessage = message
		local dialog = StaticPopup_Show("CommunityFlare_Popup_Dialog", message)
		if (dialog) then
			dialog.data = CF.PopupMessage
		end

		-- restore popup
		StaticPopupDialogs["CommunityFlare_Popup_Dialog"] = popup
	end
end

-- is sas leader?
local function CommunityFlare_IsSASLeader(name)
	-- process all leaders
	for _,v in ipairs(sasLeaders) do
		if (name == v) then
			return true
		end
	end
	return false
end

-- get proper player name by type
local function CommunityFlare_GetPlayerName(type)
	local name, realm = UnitFullName("player")
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
	-- has sub group members?
	if (GetNumSubgroupMembers() == 0) then
		return true
	-- is group leader?
	elseif (UnitIsGroupLeader("player")) then
		return true
	end
	return false
end

-- get total group count
local function CommunityFlare_GetGroupCount()
	-- get proper count
	CF.Count = 1
	if (IsInGroup()) then
		if (not IsInRaid()) then
			-- update count
			CF.Count = GetNumGroupMembers()
		end
	end

	-- return x/5 count
	return strformat("%d/5", CF.Count)
end

-- get group members
local function CommunityFlare_GetGroupMemembers()
	-- are you grouped?
	local players = {}
	if (IsInGroup()) then
		-- are you in a raid?
		if (not IsInRaid()) then
			for i=1, GetNumGroupMembers() do
				local name, realm = UnitName("party" .. i)

				-- add party member
				players[i] = {}
				players[i].guid = UnitGUID("party" .. i)
				players[i].name = name
				players[i].realm = realm
			end
		end
	else
		-- add yourself
		players[1] = {}
		players[1].guid = UnitGUID("player")
		players[1].player = CommunityFlare_GetPlayerName("full")
	end
	return players
end

-- find community member by name
local function CommunityFlare_FindClubMemberByName(player)
	-- found sas id?
	if (CommunityFlare_FindClubIDByName(CF.CommName) > 0) then
		-- use short name for same realm as you
		local name, realm = strsplit("-", player, 2)
		if (realm == GetRealmName()) then
			player = name
		end

		-- search through club members
		CF.ClubMembers = ClubGetClubMembers(CommFlareDB.SASID)
		for _,v in ipairs(CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlareDB.SASID, v);
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
	-- found sas id?
	if (CommunityFlare_FindClubIDByName(CF.CommName) > 0) then
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
		CF.ClubMembers = ClubGetClubMembers(CommFlareDB.SASID)
		for _,v in ipairs(CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlareDB.SASID, v);
			if (mi ~= nil) then
				if (mi.name == player) then
					return name, realm
				end
			end
		end
	end
	return nil, nil
end

-- find social queue by type
local function CommunityFlare_FindSocialQueueByType(type, guid, maxcount)
	-- get group queues
	CF.SocialQueues = SocialQueueGetGroupQueues(guid)
	if (CF.SocialQueues and (#CF.SocialQueues > 0)) then
		-- has max count?
		if ((maxcount > 0) and (#CF.SocialQueues > maxcount)) then
			return nil
		end

		-- process all queues
		for i=1, #CF.SocialQueues do
			-- map name matches type?
			if (CF.SocialQueues[i].queueData.mapName == type) then
				local queueData = CF.SocialQueues[i].queueData
				return queueData
			end
		end
	end
	return nil
end

-- find group members
local function CommunityFlare_FindGroupMembers(guid)
	-- get group members
	local players = {}
	CF.SocialMembers = SocialQueueGetGroupMembers(guid)
	if (CF.SocialMembers and (#CF.SocialMembers > 0)) then
		-- process all members
		for i=1, #CF.SocialMembers do
			-- get player info by guid
			local _,_,_,_,_,name,realm = GetPlayerInfoByGUID(CF.SocialMembers[i].guid)
			if (not realm) then
				realm = GetRealmName()
			end

			-- save into table
			players[i] = {}
			players[i].guid = CF.SocialMembers[i].guid
			players[i].name = name
			players[i].realm = realm
		end
	end
	return players
end

-- find social queues
local function CommunityFlare_Find_Social_Queues(bPrint)
	-- reset list
	CF.Groups = {}
	local index = 1

	-- are you in queue?
	if (CF.QueueJoined == true) then
		-- are you group leader?
		if (CommunityFlare_IsGroupLeader() == true) then
			-- get name / realm for player
			local name, realm = UnitFullName("player")
			if (not realm) then
				realm = GetRealmName()
			end

			-- not in a raid?
			if (not IsInRaid()) then
				-- does  your group have room?
				if (GetNumGroupMembers() < 5) then
					-- add your group
					CF.Groups[index] = {}
					CF.Groups[index].guid = UnitGUID("player")
					CF.Groups[index].name = name
					CF.Groups[index].realm = realm
					CF.Groups[index].players = CommunityFlare_GetGroupMemembers()

					-- print enabled?
					if (bPrint == true) then
						print(strformat("Leader: %s-%s (%d/5)", CF.Groups[index].name, CF.Groups[index].realm, #CF.Groups[index].players))
					end

					-- next
					index = index + 1
				end
			end
		end
	end

	-- get all groups
	CF.SocialGroups = SocialQueueGetAllGroups()

	-- print enabled
	if (bPrint == true) then
		print("Queues: ", #CF.SocialGroups)
	end

	-- found any groups?
	if (CF.SocialGroups and (#CF.SocialGroups > 0)) then
		-- process all grouops
		for i=1, #CF.SocialGroups do
			local canJoin,numQueues,_,_,_,_,_,leaderGUID = SocialQueueGetGroupInfo(CF.SocialGroups[i])
			local name, realm = CommunityFlare_FindClubMemberByGUID(leaderGUID)
			if (name ~= nil) then
				local queueData = CommunityFlare_FindSocialQueueByType("Random Epic Battleground", CF.SocialGroups[i], 1)
				if (queueData ~= nil) then
					-- save into table
					CF.Groups[index] = {}
					CF.Groups[index].guid = leaderGUID
					CF.Groups[index].name = name
					CF.Groups[index].realm = realm
					CF.Groups[index].players = CommunityFlare_FindGroupMembers(CF.SocialGroups[i])

					-- print enabled?
					if (bPrint == true) then
						print(strformat("Leader: %s-%s (%d/5)", CF.Groups[index].name, CF.Groups[index].realm, #CF.Groups[index].players))
					end

					-- next
					index = index + 1
				end
			end
		end
	end

	-- empty?
	if (#CF.Groups == 0) then
		-- print enabled
		if (bPrint == true) then
			print("List: No one currently in queue!")
		end
		return false
	end
	return true
end

-- report groups status
local function CommunityFlare_Report_Groups_Status()
	-- empty?
	if (#CF.Groups == 0) then
		-- find social queues
		if (CommunityFlare_Find_Social_Queues(false) == false) then
			print("Report: No one currently in queue!")
			return false
		end
	end

	-- build groups list
	local text
	local list = ""
	for i=1, #CF.Groups do
		-- add to list without realm (shorter)
		text = strformat("%s: %d/5", CF.Groups[i].name, #CF.Groups[i].players)
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
		if (CommFlareDB.communityReporter == true) then
			CommunityFlare_PopupBox(list)
		end
		return true
	end
	print("Report: No one currently in queue!")
	return false
end

-- check if a unit has type aura active
local function CommunityFlare_CheckForAura(unit, type, auraName)
	-- save global variable if aura is active
	CF.HasAura = false
	AuraUtilForEachAura(unit, type, nil, function(name, icon, ...)
		if (name == auraName) then
			CF.HasAura = true
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
	elseif (spec == "Preservation") then
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

-- list current POI's
local function CommunityFlare_List_POIs()
	-- get map id
	CF.MapID = Map_GetBestMapForUnit("player")
	if (not CF.MapID) then
		-- not found
		print("Map ID: Not Found")
		return
	end

	-- get map info
	print("MapID: ", CF.MapID)
	CF.MapInfo = Map_GetMapInfo(CF.MapID)
	if (not CF.MapInfo) then
		-- not found
		print("Map Info: Not Found")
		return
	end

	-- process any POI's
	print("Map Name: ", CF.MapInfo.name)
	local pois = AreaPoiInfo_GetAreaPOIForMap(CF.MapID)
	if (pois and (#pois > 0)) then
		-- display infos
		print("Count: ", #pois)
		for _,v in ipairs(pois) do
			CF.POIInfo = AreaPoiInfo_GetAreaPOIInfo(CF.MapID, v)
			if (CF.POIInfo) then
				if ((not CF.POIInfo.description) or (CF.POIInfo.description == "")) then
					print(strformat("%s: ID = %d, textureIndex = %d", CF.POIInfo.name, CF.POIInfo.areaPoiID, CF.POIInfo.textureIndex))
				else
					print(strformat("%s: ID = %d, textureIndex = %d, Description = %s", CF.POIInfo.name, CF.POIInfo.areaPoiID, CF.POIInfo.textureIndex, CF.POIInfo.description))
				end
			end
		end
	else
		-- none found
		print("Count: 0")
	end
end

-- get current party leader
local function CommunityFlare_GetPartyLeader()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then 
			local name, realm = UnitName("party" .. i)
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
	local name, realm = strsplit("-", player, 2)
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
	-- initialize stuff
	CF.Horde.Count = 0
	CF.Alliance.Count = 0
	CF.Horde.Tanks = 0
	CF.Horde.Healers = 0
	CF.Alliance.Tanks = 0
	CF.Alliance.Healers = 0

	-- any battlefield scores?
	CF.NumScores = GetNumBattlefieldScores()
	if (CF.NumScores == 0) then
		print("SAS: Not in Battleground yet")
		return
	end

	-- process all scores
	for i=1, CF.NumScores do
		CF.ScoreInfo = PvP_GetScoreInfo(i)
		if (CF.ScoreInfo and CF.ScoreInfo.faction and CF.ScoreInfo.talentSpec) then
			CF.IsTank = CommunityFlare_IsTank(CF.ScoreInfo.talentSpec)
			CF.IsHealer = CommunityFlare_IsHealer(CF.ScoreInfo.talentSpec)
			if (CF.ScoreInfo.faction == 0) then
				CF.Horde.Count = CF.Horde.Count + 1
				if (CF.IsHealer == true) then
					CF.Horde.Healers = CF.Horde.Healers + 1
				elseif (CF.IsTank == true) then
					CF.Horde.Tanks = CF.Horde.Tanks + 1
				end
			else
				CF.Alliance.Count = CF.Alliance.Count + 1
				if (CF.IsHealer == true) then
					CF.Alliance.Healers = CF.Alliance.Healers + 1
				elseif (CF.IsTank == true) then
					CF.Alliance.Tanks = CF.Alliance.Tanks + 1
				end
			end
		end
	end

	-- display faction results
	print(strformat("Horde: Healers = %d, Tanks = %d", CF.Horde.Healers, CF.Horde.Tanks))
	print(strformat("Alliance: Healers = %d, Tanks = %d", CF.Alliance.Healers, CF.Alliance.Tanks))

	-- find SAS members
	CF.Count = 0
	CF.PlayerList = nil
	CF.PlayerRank = CommunityFlare_GetRaidRank(UnitName("player"))
	if (CommunityFlare_FindClubIDByName(CF.CommName) > 0) then
		CF.ClubMembers = ClubGetClubMembers(CommFlareDB.SASID)
		for _,v in ipairs(CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlareDB.SASID, v);
			if (mi ~= nil) then
				if (UnitInRaid(mi.name) ~= nil) then
					-- processing player list too?
					if (type == "full") then
						-- list still empty? start it!
						if (CF.PlayerList == nil) then
							CF.PlayerList = mi.name
						else
							CF.PlayerList = CF.PlayerList .. ", " .. mi.name
						end
					end

					-- player has raid leader?
					if (CF.PlayerRank == 2) then
						CF.AutoPromote = false
						if (CommFlareDB.communityAutoAssist == 1) then
							if (CommunityFlare_IsSASLeader(mi.name) == true) then
								CF.AutoPromote = true
							end
						elseif (CommFlareDB.communityAutoAssist == 2) then
							CF.AutoPromote = true
						end
						if (CF.AutoPromote == true) then
							PromoteToAssistant(mi.name)
						end
					end

					-- next
					CF.Count = CF.Count + 1
				end
			end
		end
	end

	-- display community results
	if (CF.PlayerList ~= nil) then
		print("SAS: ", CF.PlayerList)
	end
	print("Found: ", CF.Count)
end

-- setup stuff to automatically accept queues
local function CommunityFlare_AutoAcceptQueues_OnShow()
	-- capable of auto queuing?
	CF.AutoQueueable = false
	if (not IsInRaid()) then
		CF.AutoQueueable = true
	else
		-- larger than rated battleground count?
		if (GetNumGroupMembers() > 10) then
			CF.AutoQueueable = true
		end
	end

	-- auto queueable?
	CF.AutoQueue = false
	if (CF.AutoQueueable == true) then
		-- always auto queue?
		if (CommFlareDB.alwaysAutoQueue == true) then
			CF.AutoQueue = true
		-- community auto queue?
		elseif (CommFlareDB.communityAutoQueue == true) then
			local player = CommunityFlare_FindClubMemberByName(CommunityFlare_GetPartyLeader())
			if (player ~= nil) then
				CF.AutoQueue = true
			end
		end
	end

	-- auto queue enabled?
	if (CF.AutoQueue == true) then
		CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
		if (CF.HasAura == false) then
			-- auto queue up
			CF.QueueJoined = true
			CF.QueuePopped = false
			LFDRoleCheckPopupAcceptButton:Click()
		else
			-- have deserter / leave party
			CommunityFlare_SendMessage(nil, "Sorry, I currently have Deserter! Leaving party to avoid interrupting the queue!")
			PartyInfoLeaveParty()
		end
	end
end

-- securely hook pvp ready dialog display
local function CommunityFlare_PVPReadyDialog_Display(self, index, displayName, isRated, queueType, gameType, role)
	-- process random epic battlegrounds only
	if (displayName == "Random Epic Battleground") then
		if (GetBattlefieldPortExpiration(index) > 0) then
			-- community reporter enabled?
			if (CommFlareDB.communityReporter == true) then
				if (CommunityFlare_IsGroupLeader() == true) then
					CommunityFlare_PopupBox(strformat("%s Queue Popped!", CommunityFlare_GetGroupCount()))
				end
			end

			-- queue popped / not joined
			CF.QueueJoined = false
			CF.QueuePopped = true
		end
	else
		-- reset settings
		CF.QueueJoined = false
		CF.QueuePopped = false
	end
end

-- hook pvp ready dialog enter clicked
local function CommunityFlare_PVPReadyDialogEnterBattleButton_OnClick()
	-- reset settings
	CF.QueueJoined = false
	CF.QueuePopped = false
end

-- securely hook pvp ready dialog hide
local function CommunityFlare_PVPReadyDialog_OnHide(self)
	-- find active battlefield
	for i=1, GetMaxBattlefieldID() do
		local status = GetBattlefieldStatus(i)
		if (status == "active") then
			-- reset queue popped
			CF.QueuePopped = false
		end
	end
	TimerAfter(1.5, function()
		-- has queue popped?
		if (CF.QueuePopped == true) then
			-- community reporter enabled?
			if (CommFlareDB.communityReporter == true) then
				CommunityFlare_PopupBox(strformat("%s Missed Queue!", CommunityFlare_GetPlayerName("short")))
			end

			-- reset popped
			CF.QueuePopped = false
		end
	end)
end

-- process queue stuff
local function CommunityFlare_ProcessQueues()
	-- hook stuff
	LFDRoleCheckPopupAcceptButton:SetScript("OnShow", CommunityFlare_AutoAcceptQueues_OnShow)
	hooksecurefunc("PVPReadyDialog_Display", CommunityFlare_PVPReadyDialog_Display)
	PVPReadyDialogEnterBattleButton:HookScript("OnClick", CommunityFlare_PVPReadyDialogEnterBattleButton_OnClick)
	PVPReadyDialog:HookScript("OnHide", CommunityFlare_PVPReadyDialog_OnHide)

	-- check if currently in queue
	for i=1, GetMaxBattlefieldID() do
		local status, mapName = GetBattlefieldStatus(i)
		if (mapName == "Random Epic Battleground") then
			CF.Timer.MilliSeconds = GetBattlefieldTimeWaited(i)
			if (CF.Timer.MilliSeconds > 0) then
				-- queue joined
				CF.QueueJoined = true
			end
		end
	end
end

-- reset battleground status
local function CommunityFlare_Reset_Battleground_Status()
	-- reset settings
	CF.QueueJoined = false
	CF.QueuePopped = false

	-- reset maps
	CF.MapID = 0
	CF.ASH = {}
	CF.AV = {}
	CF.IOC = {}
	CF.WG = {}
	CF.MapInfo = {}
	CF.Reloaded = false
end

-- update battleground status
local function CommunityFlare_Update_Battleground_Status()
	-- get MapID
	CF.MapID = Map_GetBestMapForUnit("player")
	if (not CF.MapID) then
		-- failed
		return false
	end

	-- get map info
	CF.MapInfo = Map_GetMapInfo(CF.MapID)
	if (not CF.MapInfo) then
		-- failed
		return false
	end

	-- alterac valley or korrak's revenge?
	if ((CF.MapID == 91) or (CF.MapID == 1537)) then
		-- initialize
		CF.AV = {}
		CF.AV.Counts = { Bunkers = 4, Towers = 4 }
		CF.AV.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- alterac valley?
		if (CF.MapID == 91) then
			-- initialize bunkers
			CF.AV.Bunkers = {
				[1] = { id = 1380, name = "IWB", status = "Up" },
				[2] = { id = 1352, name = "North", status = "Up" },
				[3] = { id = 1389, name = "SHB", status = "Up" },
				[4] = { id = 1355, name = "South", status = "Up" }
			}

			-- initialize towers
			CF.AV.Towers = {
				[1] = { id = 1362, name = "East", status = "Up" },
				[2] = { id = 1377, name = "IBT", status = "Up" },
				[3] = { id = 1405, name = "TP", status = "Up" },
				[4] = { id = 1528, name = "West", status = "Up" }
			}
		else
			-- initialize bunkers
			CF.AV.Bunkers = {
				[1] = { id = 6445, name = "IWB", status = "Up" },
				[2] = { id = 6422, name = "North", status = "Up" },
				[3] = { id = 6453, name = "SHB", status = "Up" },
				[4] = { id = 6425, name = "South", status = "Up" }
			}

			-- initialize towers
			CF.AV.Towers = {
				[1] = { id = 6430, name = "East", status = "Up" },
				[2] = { id = 6442, name = "IBT", status = "Up" },
				[3] = { id = 6465, name = "TP", status = "Up" },
				[4] = { id = 6469, name = "West", status = "Up" }
			}
		end

		-- process bunkers
		for i,v in ipairs(CF.AV.Bunkers) do
			CF.AV.Bunkers[i].status = "Up"
			CF.POIInfo = AreaPoiInfo_GetAreaPOIInfo(CF.MapID, CF.AV.Bunkers[i].id)
			if (CF.POIInfo) then
				CF.AV.Bunkers[i].status = "Destroyed"
				CF.AV.Counts.Bunkers = CF.AV.Counts.Bunkers - 1
			end
		end

		-- process towers
		for i,v in ipairs(CF.AV.Towers) do
			CF.AV.Towers[i].status = "Up"
			CF.POIInfo = AreaPoiInfo_GetAreaPOIInfo(CF.MapID, CF.AV.Towers[i].id)
			if (CF.POIInfo) then
				CF.AV.Towers[i].status = "Destroyed"
				CF.AV.Counts.Towers = CF.AV.Counts.Towers - 1
			end
		end

		-- 1684 = widgetID for Score Remaining
		CF.ScoreInfo = GetDoubleStatusBarWidgetVisualizationInfo(1684)
		if (CF.ScoreInfo) then
			-- set proper scores
			CF.AV.Scores = { Alliance = CF.ScoreInfo.leftBarValue, Horde = CF.ScoreInfo.rightBarValue }
		end

		-- success
		return true
	-- isle of conquest?
	elseif (CF.MapID == 169) then
		-- initialize settings
		CF.IOC = {}
		CF.IOC.Counts = { Alliance = 3, Horde = 3 }
		CF.IOC.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- initialize alliance gates
		CF.IOC.AllianceGates = {
			[1] = { id = 2378, name = "East", status = "Up" },
			[2] = { id = 2379, name = "Front", status = "Up" },
			[3] = { id = 2381, name = "West", status = "Up" }
		}

		-- initialize horde gates
		CF.IOC.HordeGates = {
			[1] = { id = 2374, name = "East", status = "Up" },
			[2] = { id = 2372, name = "Front", status = "Up" },
			[3] = { id = 2376, name = "West", status = "Up" }
		}

		-- process alliance gates
		for i,v in ipairs(CF.IOC.AllianceGates) do
			CF.IOC.AllianceGates[i].status = "Up"
			CF.POIInfo = AreaPoiInfo_GetAreaPOIInfo(CF.MapID, CF.IOC.AllianceGates[i].id)
			if (CF.POIInfo) then
				CF.IOC.AllianceGates[i].status = "Destroyed"
				CF.IOC.Counts.Alliance = CF.IOC.Counts.Alliance - 1
			end
		end

		-- process horde gates
		for i,v in ipairs(CF.IOC.HordeGates) do
			CF.IOC.HordeGates[i].status = "Up"
			CF.POIInfo = AreaPoiInfo_GetAreaPOIInfo(CF.MapID, CF.IOC.HordeGates[i].id)
			if (CF.POIInfo) then
				CF.IOC.HordeGates[i].status = "Destroyed"
				CF.IOC.Counts.Horde = CF.IOC.Counts.Horde - 1
			end
		end

		-- 1685 = widgetID for Score Remaining
		CF.ScoreInfo = GetDoubleStatusBarWidgetVisualizationInfo(1685)
		if (CF.ScoreInfo) then
			-- set proper scores
			CF.IOC.Scores = { Alliance = CF.ScoreInfo.leftBarValue, Horde = CF.ScoreInfo.rightBarValue }
		end

		-- success
		return true
	-- battle for wintergrasp?
	elseif (CF.MapID == 1334) then
		-- initialize
		CF.WG = {}
		CF.WG.Counts = { Towers = 0 }
		CF.WG.TimeRemaining = "Just entered match. Gates not opened yet!"

		-- initialize towers
		CF.WG.Towers = {
			[1] = { id = 6066, name = "East", status = "Up" },
			[2] = { id = 6065, name = "South", status = "Up" },
			[3] = { id = 6067, name = "West", status = "Up" }
		}

		-- process towers
		for i,v in ipairs(CF.WG.Towers) do
			CF.WG.Towers[i].status = "Up"
			CF.POIInfo = AreaPoiInfo_GetAreaPOIInfo(CF.MapID, CF.WG.Towers[i].id)
			if (CF.POIInfo and (CF.POIInfo.textureIndex == 51)) then
				CF.WG.Towers[i].status = "Destroyed"
				CF.WG.Counts.Towers = CF.WG.Counts.Towers + 1
			end
		end

		-- match not started yet?
		if (CF.MatchStatus ~= 1) then
			-- 1612 = widgetID for Time Remaining
			CF.ScoreInfo = GetIconAndTextWidgetVisualizationInfo(1612)
			if (CF.ScoreInfo) then
				-- set proper time
				CF.WG.TimeRemaining = CF.ScoreInfo.text
			end
		end

		-- success
		return true
	-- ashran?
	elseif (CF.MapID == 1478) then
		-- initialize
		if (not CF.ASH) then
			CF.ASH = { Jeron = "Up", Rylal = "Up" }
		end
		CF.ASH.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- reloaded?
		if (CF.Reloaded == true) then
			-- match maybe reloaded, use saved session
			CF.ASH.Jeron = CommFlareDB.ASH.Jeron
			CF.ASH.Rylai = CommFlareDB.ASH.Rylai
		end

		-- 1997 = widgetID for Score Remaining
		CF.ScoreInfo = GetDoubleStatusBarWidgetVisualizationInfo(1997)
		if (CF.ScoreInfo) then
			-- set proper scores
			CF.ASH.Scores = { Alliance = CF.ScoreInfo.leftBarValue, Horde = CF.ScoreInfo.rightBarValue }
		end

		-- success
		return true
	end

	-- not epic battleground
	return false
end

-- get current status
local function CommunityFlare_Get_Current_Status()
	-- display variables
	print("GroupInvited:", CF.GroupInvited)
	print("QueueJoined: ", CF.QueueJoined)
	print("QueuePopped: ", CF.QueuePopped)

	-- update battleground status
	if (CommunityFlare_Update_Battleground_Status() == false) then
		-- do nothing
		return
	end

	-- check for epic battleground
	if (CF.MapID) then
		-- get map info
		print("MapID: ", CF.MapID)
		CF.MapInfo = Map_GetMapInfo(CF.MapID)
		if (CF.MapInfo and CF.MapInfo.name) then
			-- alterac valley or korrak's revenge?
			if ((CF.MapID == 91) or (CF.MapID == 1537)) then
				-- display alterac valley status
				print(strformat("%s: Alliance = %s; Horde = %s; Bunkers Left = %d/4; Towers Left = %d/4", CF.MapInfo.name, CF.AV.Scores.Alliance, CF.AV.Scores.Horde, CF.AV.Counts.Bunkers, CF.AV.Counts.Towers))
			-- isle of conquest?
			elseif (CF.MapID == 169) then
				-- display isle of conquest status
				print(strformat("%s: Alliance = %s; Gates Destroyed: %d/3; Horde = %s; Gates Destroyed: %d/3", CF.MapInfo.name, CF.IOC.Scores.Alliance, CF.IOC.Counts.Alliance, CF.IOC.Scores.Horde, CF.IOC.Counts.Horde))
			-- battle for wintergrasp?
			elseif (CF.MapID == 1334) then
				-- display wintergrasp status
				print(strformat("%s: %s; Towers Destroyed: %d/3", CF.MapInfo.name, CF.WG.TimeRemaining, CF.WG.Counts.Towers))
			-- ashran?
			elseif (CF.MapID == 1478) then
				-- display ashran status
				print(strformat("%s: Alliance = %s; Horde = %s; Jeron = %s; Rylai = %s", CF.MapInfo.name, CF.ASH.Scores.Alliance, CF.ASH.Scores.Horde, CF.ASH.Jeron, CF.ASH.Rylai))
			end
		end
	end
end


-- process status check
local function CommunityFlare_Process_Status_Check(sender)
	-- currently in battleground?
	if (PvP_IsBattleground() == true) then
		-- update battleground status
		if (CommunityFlare_Update_Battleground_Status() == true) then
			-- has match started yet?
			if (PvP_GetActiveMatchDuration() > 0) then
				-- alterac valley or korrak's revenge?
				if ((CF.MapID == 91) or (CF.MapID == 1537)) then
					-- reply to sender with alterac valley status
					CommunityFlare_SendMessage(sender, strformat("%s: Alliance = %s; Horde = %s; Bunkers Left = %d/4; Towers Left = %d/4", CF.MapInfo.name, CF.AV.Scores.Alliance, CF.AV.Scores.Horde, CF.AV.Counts.Bunkers, CF.AV.Counts.Towers))
				-- isle of conquest?
				elseif (CF.MapID == 169) then
					-- reply to sender with isle of conquest status
					CommunityFlare_SendMessage(sender, strformat("%s: Alliance = %s; Gates Destroyed: %d/3; Horde = %s; Gates Destroyed: %d/3", CF.MapInfo.name, CF.IOC.Scores.Alliance, CF.IOC.Counts.Alliance, CF.IOC.Scores.Horde, CF.IOC.Counts.Horde))
				-- battle for wintergrasp?
				elseif (CF.MapID == 1334) then
					-- reply to sender with wintergrasp status
					CommunityFlare_SendMessage(sender, strformat("%s: %s; Towers Destroyed: %d/3", CF.MapInfo.name, CF.WG.TimeRemaining, CF.WG.Counts.Towers))
				-- ashran?
				elseif (CF.MapID == 1478) then
					-- reply to sender with ashran status
					CommunityFlare_SendMessage(sender, strformat("%s: Alliance = %s; Horde = %s; Jeron = %s; Rylai = %s", CF.MapInfo.name, CF.ASH.Scores.Alliance, CF.ASH.Scores.Horde, CF.ASH.Jeron, CF.ASH.Rylai))
				end
			else
				-- reply to sender with map name, gates not opened yet
				CommunityFlare_SendMessage(sender, strformat("%s: Just entered match. Gates not opened yet!", CF.MapInfo.name))
			end
		else
			-- reply to sender, not epic battleground
			CommunityFlare_SendMessage(sender, strformat("%s: Not an Epic Battleground to track.", CF.MapInfo.name))
		end
	else
		-- check for queued battleground
		CF.Leader = CommunityFlare_GetPartyLeader()
		for i=1, GetMaxBattlefieldID() do
			local status, mapName = GetBattlefieldStatus(i)
			if (status == "queued") then
				-- Random Epic Battleground
				if (mapName == "Random Epic Battleground") then
					-- report Time been in queue
					CF.Timer.MilliSeconds = GetBattlefieldTimeWaited(i)
					CF.Timer.Seconds = math.floor(CF.Timer.MilliSeconds / 1000)
					CF.Timer.Minutes = math.floor(CF.Timer.Seconds / 60)
					CF.Timer.Seconds = CF.Timer.Seconds - (CF.Timer.Minutes * 60)
					CommunityFlare_SendMessage(sender, strformat("%s has been queued for %d minutes and %d seconds.", CF.Leader, CF.Timer.Minutes, CF.Timer.Seconds))

					-- finished
					return
				end
			end
		end

		-- not reported
		CommunityFlare_SendMessage(sender, "Not currently in an Epic Battleground or queue!")
	end
end

-- process group invite confirmation
local function CommunityFlare_Event_Group_Invite_Confirmation(text)
	-- has text?
	if (not text and (text ~= "")) then
		-- you will be removed from random epic battleground?
		text = strlower(text)
		if (strfind(text, "you will be removed from") and strfind(text, "random epic battleground")) then
			if (StaticPopup1:IsShown()) then
				StaticPopup1Button2:Click()
			end
		end
	end
end

-- process battle net whisper
local function CommunityFlare_Event_BattleNet_Whisper(sender, text)
	-- version check?
	if (text == "!cf") then
		-- send community flare version number
		CommunityFlare_SendMessage(sender, strformat("Community Flare: %s", CF.Version))
	-- status check?
	elseif (text == "!status") then
		-- process status check
		CommunityFlare_Process_Status_Check(sender)
	-- asking for invite?
	elseif ((text == "inv") or (text == "invite")) then
		-- battle net auto invite enabled?
		if (CommFlareDB.bnetAutoInvite == true) then
			if (CommunityFlare_IsInBattleground() == true) then
				CommunityFlare_SendMessage(sender, "Sorry, currently in Battleground now.")
			else
				-- get bnet friend index
				local index = BNGetFriendIndex(sender)
				if (index ~= nil) then
					-- process all bnet accounts logged in
					local numGameAccounts = BattleNetGetFriendNumGameAccounts(index);
					for i=1, numGameAccounts do
						-- check if account has player guid online
						local gameAccountInfo = BattleNetGetFriendGameAccountInfo(index, i);
						if (gameAccountInfo.playerGuid) then
							if (CommunityFlare_IsGroupLeader() == true) then
								if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
									CommunityFlare_SendMessage(sender, "Sorry, group is currently full.")
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
end

-- process monster yell message
local function CommunityFlare_Event_Message_Monster_Yell(sender, text)
	-- Ashran, jeron killed?
	if (text:find("jeron emberfall has been slain")) then
		-- jeron emberfall killed
		CF.ASH.Jeron = "Killed"
	-- Ashran, rylai killed?
	elseif (text:find("rylai crestfall has been slain")) then
		-- rylai crestfall killed
		CF.ASH.Rylai = "Killed"
	end
end

-- process notify pvp afk result
local function CommunityFlare_Event_Notify_PVP_AFK_Result(offender, numBlackMarksOnOffender, numPlayersIHaveReported)
	-- hmmm, what is this?
	print(strformat("NOTIFY_PVP_AFK_RESULT: %s = %s, %s", offender, numBlackMarksOnOffender, numPlayersIHaveReported))
end

-- process party invite request
local function CommunityFlare_Event_PartyInvite_Request(sender)
	-- verify player does not have deserter debuff
	CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
	if (CF.HasAura == false) then
		-- community auto invite enabled?
		if (CommFlareDB.communityAutoInvite == true) then
			if (CommunityFlare_FindClubMemberByName(sender) ~= nil) then
				if (LFGInvitePopup:IsShown()) then
					LFGInvitePopupAcceptButton:Click()
				end
			end
		end
	else
		-- send whisper back that you have deserter
		CommunityFlare_SendMessage(sender, "Sorry, I currently have Deserter!")
		if (LFGInvitePopup:IsShown()) then
			LFGInvitePopupDeclineButton:Click()
		end
	end
end

-- process party message
local function CommunityFlare_Event_Message_Party(sender, text)
	-- skip messages from yourself
	if (CommunityFlare_GetPlayerName("full") ~= sender) then
		if (text == "!cf") then
			-- send community flare version number
			CommunityFlare_SendMessage(nil, strformat("Community Flare: %s", CF.Version))
		end
	end
end

-- process system message
local function CommunityFlare_Event_Message_System(sender, text)
	-- everyone is ready?
	if (text:find("everyone is ready")) then
		-- community reporter enabled?
		if (CommFlareDB.communityReporter == true) then
			-- currently out of queue?
			if (CF.QueueJoined == false) then
				if (CommunityFlare_IsGroupLeader() == true) then
					CommunityFlare_PopupBox(strformat("%s Ready!", CommunityFlare_GetGroupCount()))
				end
			end
		end
	-- someone invited you to a group?
	elseif (text:find("has invited you to join a group")) then
		-- invited to group
		CF.GroupInvited = true
		TimerAfter(2, function()
			-- resets if not in queue
			CF.GroupInvited = false
		end)
	-- someone has joined the battleground?
	elseif (text:find("has joined the instance group")) then
		-- community auto promote leader enabled?
		if (CommFlareDB.communityAutoPromoteLeader == true) then
			-- not sas leader?
			local player = CommunityFlare_GetPlayerName("full")
			if (CommunityFlare_IsSASLeader(player) == false) then
				-- do you have lead?
				CF.PlayerRank = CommunityFlare_GetRaidRank(UnitName("player"))
				if (CF.PlayerRank == 2) then
					-- process all sas leaders
					for _,v in ipairs(sasLeaders) do
						-- promote this leader
						if (CommunityFlare_Battleground_PromoteToLeader(v) == true) then
							break
						end
					end
				end
			end
		end
	-- joined the queue for random epic battleground?
	elseif (text:find("joined the queue for random epic battleground")) then
		-- being invited to a group already in queue
		if (CF.GroupInvited == true) then
			-- no invite pending
			CF.GroupInvited = false
		else
			-- community reporter enabled?
			if (CommFlareDB.communityReporter == true) then
				-- currently out of queue?
				if (CF.QueueJoined == false) then
					if (CommunityFlare_IsGroupLeader() == true) then
						CommunityFlare_PopupBox(strformat("%s Joined Queue!", CommunityFlare_GetGroupCount()))
					end
				end
			end
		end

		-- joined, not popped
		CF.QueueJoined = true
		CF.QueuePopped = false
	-- notify system has been enabled?
	elseif (text:find("notify system has been enabled")) then
		-- use full list for meso
		local type = "short"
		local player = CommunityFlare_GetPlayerName(type)
		if ((player == "Mesostealthy") or (player == "Lifestooport") or (player == "Shotdasherif")) then
			type = "full"
		end

		-- display battleground setup
		CF.MatchStatus = 2
		CommunityFlare_Battleground_Setup(type)
	-- you are no longer queued?
	elseif (text:find("you are no longer queued")) then
		-- community reporter enabled?
		if (CommFlareDB.communityReporter == true) then
			-- currently in queue?
			if (CF.QueueJoined == true) then
				if (CommunityFlare_IsGroupLeader() == true) then
					CommunityFlare_PopupBox(strformat("%s Dropped Queue!", CommunityFlare_GetGroupCount()))
				end
			end
		end

		-- reset settings
		CF.QueueJoined = false
		CF.QueuePopped = false
	-- queue has been dropped?
	elseif (text:find("you leave the group") or text:find("your team has left the queue")) then
		-- reset settings
		CF.QueueJoined = false
		CF.QueuePopped = false
	-- group has been disbanded?
	elseif (text:find("you have been removed from the group") or text:find("group has been disbanded")) then
		-- reset battleground status
		CommunityFlare_Reset_Battleground_Status()
	end
end

-- process whisper message
local function CommunityFlare_Event_Message_Whisper(sender, text)
	-- version check?
	if (text == "!cf") then
		-- send community flare version number
		CommunityFlare_SendMessage(sender, strformat("Community Flare: %s", CF.Version))
	-- pass leadership?
	elseif (text == "!pl") then
		-- not sas leader?
		local player = CommunityFlare_GetPlayerName("full")
		if (CommunityFlare_IsSASLeader(player) == false) then
			-- do you have lead?
			CF.PlayerRank = CommunityFlare_GetRaidRank(UnitName("player"))
			if (CF.PlayerRank == 2) then
				-- sas leader?
				if (CommunityFlare_IsSASLeader(sender) == true) then
					CommunityFlare_Battleground_PromoteToLeader(sender)
				end
			end
		end
	-- status check?
	elseif (text == "!status") then
		-- process status check
		CommunityFlare_Process_Status_Check(sender)
	-- asking for invite?
	elseif ((text == "inv") or (text == "invite")) then
		-- community auto invite enabled?
		if (CommFlareDB.communityAutoInvite == true) then
			-- already deployed in a battleground?
			if (CommunityFlare_IsInBattleground() == true) then
				CommunityFlare_SendMessage(sender, "Sorry, currently in Battleground now.")
			else
				-- sender is from the community?
				if (CommunityFlare_FindClubMemberByName(sender) ~= nil) then
					if (CommunityFlare_IsGroupLeader() == true) then
						if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
							CommunityFlare_SendMessage(sender, "Sorry, group is currently full.")
						else
							PartyInfoInviteUnit(sender)
						end
					end
				end
			end
		end
	end
end

-- process pvp match active
local function CommunityFlare_Event_PVP_Match_Active()
	-- always reset ashran mages
	CF.ASH.Jeron = "Up"
	CF.ASH.Rylai = "Up"

	-- active status
	CF.MatchStatus = 1
end

-- process pvp match complete
local function CommunityFlare_Event_PVP_Match_Complete(winner, duration)
	-- update battleground status
	CF.MatchStatus = 3
	CommunityFlare_Update_Battleground_Status()
end

-- process pvp match inactive
local function CommunityFlare_Event_PVP_Match_Inactive()
	-- reset battleground status
	CF.MatchStatus = 0
	CommunityFlare_Reset_Battleground_Status()
end

-- process ready check
local function CommunityFlare_Event_Ready_Check(sender)
	-- does the player have the mercenary buff?
	CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
	if (CF.HasAura == true) then
		CommunityFlare_SendMessage(nil, "I currently have the Mercenary Contract BUFF! (Are we mercing?)")
	end

	-- capable of auto queuing?
	CF.AutoQueueable = false
	if (not IsInRaid()) then
		CF.AutoQueueable = true
	else
		-- larger than rated battleground count?
		if (GetNumGroupMembers() > 10) then
			CF.AutoQueueable = true
		end
	end

	-- auto queueable?
	CF.AutoQueue = false
	if (CF.AutoQueueable == true) then
		-- always auto queue?
		if (CommFlareDB.alwaysAutoQueue == true) then
			CF.AutoQueue = true
		-- community auto queue?
		elseif (CommFlareDB.communityAutoQueue == true) then
			if (CommunityFlare_FindClubMemberByName(sender) ~= nil) then
				CF.AutoQueue = true
			end
		end
	end

	-- auto queue enabled?
	if (CF.AutoQueue == true) then
		-- verify player does not have deserter debuff
		CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
		if (CF.HasAura == false) then
			if (ReadyCheckFrame:IsShown()) then
				ReadyCheckFrameYesButton:Click()
			end
		else
			-- send back to party that you have deserter
			CommunityFlare_SendMessage(nil, "Sorry, I currently have Deserter!")
			if (ReadyCheckFrame:IsShown()) then
				ReadyCheckFrameNoButton:Click()
			end
		end
	end
end

-- process social queue update
local function CommunityFlare_Event_Social_Queue_Update(guid, numAdded)
	-- get social queue datas
	local canJoin,numQueues,_,_,_,_,_,leaderGUID = SocialQueueGetGroupInfo(guid)
	--print(strformat("GroupInfo: %d, %d, %s", canJoin, numQueues, leaderGUID))
	CF.SocialQueues = SocialQueueGetGroupQueues(guid)
	--DevTools_Dump(CF.SocialQueues)
	CF.SocialMembers = SocialQueueGetGroupMembers(guid)
	--DevTools_Dump(CF.SocialMembers)
end

-- process ui info message
local function CommunityFlare_Event_UI_Info_Message(type, text)
	-- someone has deserter?
	if (text:find("deserter")) then
		print("Someone has Deserter debuff!")
	end
end

-- process all hooked events
local function CommunityFlare_EventHandler(self, event, ...)
	if (event == "ADDON_LOADED") then
		local addon = ...
		if (addon == addonName) then
			-- copy initial variables or create empty
			CommFlareDB = _G.CommFlareDB or {}
			if (not CommFlareDB) then
				CommFlareDB = defaultOptions
			end

			-- initialize any settings not set
			for k,v in pairs(defaultOptions) do
				if (not CommFlareDB[k]) then
					CommFlareDB[k] = v
				end
			end
		end
	elseif (event == "CHAT_MSG_BN_WHISPER") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		CommunityFlare_Event_BattleNet_Whisper(bnSenderID, strlower(text))
	elseif ((event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER")) then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		CommunityFlare_Event_Message_Party(sender, strlower(text))
	elseif (event == "CHAT_MSG_SYSTEM") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		CommunityFlare_Event_Message_System(sender, strlower(text))
	elseif (event == "CHAT_MSG_WHISPER") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		CommunityFlare_Event_Message_Whisper(sender, strlower(text))
	elseif (event == "CHAT_MSG_MONSTER_YELL") then
		local text,sender,_,_,_,_,_,_,_,_,_,guid,bnSenderID = ...
		CommunityFlare_Event_Message_Monster_Yell(sender, strlower(text))
	elseif (event == "GROUP_INVITE_CONFIRMATION") then
		local text = StaticPopup1Text["text_arg1"]
		CommunityFlare_Event_Group_Invite_Confirmation(text)
	elseif (event == "NOTIFY_PVP_AFK_RESULT") then
		local offender, numBlackMarksOnOffender, numPlayersIHaveReported = ...
		CommunityFlare_Event_Notify_PVP_AFK_Result(offender, numBlackMarksOnOffender, numPlayersIHaveReported)
	elseif (event == "PARTY_INVITE_REQUEST") then
		local sender,_,_,_,_,_,guid,questSessionActive = ...
		CommunityFlare_Event_PartyInvite_Request(sender)
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isInitialLogin, isReloadingUi = ...
		if ((isInitialLogin) or (isReloadingUi)) then
			-- display version
			print("Community Flare: ", CF.Version)
			TimerAfter(2, function()
				-- get proper sas community id
				CommFlareDB.SASID = CommunityFlare_FindClubIDByName(CF.CommName)
			end)

			-- reloading?
			if (isReloadingUi) then
				-- reloaded
				CF.Reloaded = true

				-- load previous session
				CommunityFlare_LoadSession()

				-- inside battleground?
				CF.MatchStatus = 0
				if (PvP_IsBattleground() == true) then
					-- reset joined / popped
					CF.QueueJoined = false
					CF.QueuePopped = false

					-- match state is active?
					if (PvP_GetActiveMatchState() == Enum.PvPMatchState.Active) then
						-- match is active state?
						CF.MatchStatus = 1
						if (PvP_GetActiveMatchDuration() > 0) then
							-- match started
							CF.MatchStatus = 2
						end
					end
				end
			end
		end
	elseif (event == "PLAYER_LOGIN") then
		-- event hooks not enabled yet?
		if (CF.EventHandlerLoaded == false) then
			-- process queue stuff
			CommunityFlare_ProcessQueues()
			CF.EventHandlerLoaded = true
		end
	elseif (event == "PLAYER_LOGOUT") then
		-- save session variables
		CommunityFlare_SaveSession()

		-- update global settings
		_G.CommFlareDB = CommFlareDB
	elseif (event == "PVP_MATCH_ACTIVE") then
		-- has no arguments?
		CommunityFlare_Event_PVP_Match_Active()
	elseif (event == "PVP_MATCH_COMPLETE") then
		local winner,duration = ...
		CommunityFlare_Event_PVP_Match_Complete(winner, duration)
	elseif (event == "PVP_MATCH_INACTIVE") then
		-- has no arguments?
		CommunityFlare_Event_PVP_Match_Inactive()
	elseif (event == "READY_CHECK") then
		local sender, timeleft = ...
		CommunityFlare_Event_Ready_Check(sender)
	elseif (event == "SOCIAL_QUEUE_UPDATE") then
		local guid,numAdded = ...
		CommunityFlare_Event_Social_Queue_Update(guid, numAdded)
	elseif (event == "UI_INFO_MESSAGE") then
		local type,text = ...
		CommunityFlare_Event_UI_Info_Message(type, strlower(text))
	else
		-- unhandled message?
		print(strformat("Community Flare: Unhandled Event = %s", event))
	end
end
f:SetScript("OnEvent", CommunityFlare_EventHandler)

-- process comf slash command
SlashCmdList["COMF"] = function(cmd)
	cmd = strlower(cmd)
	if (cmd == "list") then
		-- find social queues
		CommunityFlare_Find_Social_Queues(true)
	elseif (cmd == "options") then
		-- dump settings
		DevTools_Dump(CommFlareDB)
	elseif (cmd == "pois") then
		-- list all POI's
		CommunityFlare_List_POIs()
	elseif (cmd == "report") then
		-- report groups status (only enabled for MESO for now!)
		local player = CommunityFlare_GetPlayerName("short")
		if ((player == "Mesostealthy") or (player == "Lifestooport") or (player == "Shotdasherif")) then
			CommunityFlare_Report_Groups_Status()
		else
			print("Report: Not quite ready for the masses.")
		end
	elseif (cmd == "reset all") then
		-- reset settings to default
		CommFlareDB = defaultOptions
	elseif (cmd == "sasid") then
		-- get proper sas community id
		CommFlareDB.SASID = CommunityFlare_FindClubIDByName(CF.CommName)
		print("SASID: ", CommFlareDB.SASID)
	elseif (cmd == "status") then
		-- get current status
		CommunityFlare_Get_Current_Status()
	elseif (cmd == "test") then
		DevTools_Dump(CF.ASH)
		DevTools_Dump(CF.AV)
		DevTools_Dump(CF.IOC)
		DevTools_Dump(CF.WG)
	elseif (cmd == "usage") then
		-- display usages
		print("CPU Usage: ", GetAddOnCPUUsage("Community_Flare"))
		print("Memory Usage: ", GetAddOnMemoryUsage("Community_Flare"))
	else
		-- display full battleground setup
		CommunityFlare_Battleground_Setup("full")
	end
end
