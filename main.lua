local ADDON_NAME, NS = ...
NS = NS or {}

-- initialize ACE3
CommFlare = LibStub("AceAddon-3.0"):NewAddon("Community Flare", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

-- localize stuff
local _G                                        = _G
local AcceptGroup                               = _G.AcceptGroup
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNInviteFriend                            = _G.BNInviteFriend
local BNRequestInviteFriend                     = _G.BNRequestInviteFriend
local ChatFrame_AddMessageEventFilter           = _G.ChatFrame_AddMessageEventFilter
local CreateFrame                               = _G.CreateFrame
local DeclineQuest                              = _G.DeclineQuest
local DevTools_Dump                             = _G.DevTools_Dump
local GetAddOnCPUUsage                          = _G.GetAddOnCPUUsage
local GetAddOnMemoryUsage                       = _G.GetAddOnMemoryUsage
local GetAddOnMetadata                          = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetBattlefieldWinner                      = _G.GetBattlefieldWinner
local GetDisplayedInviteType                    = _G.GetDisplayedInviteType
local GetHomePartyInfo                          = _G.GetHomePartyInfo
local GetInviteConfirmationInfo                 = _G.GetInviteConfirmationInfo
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNextPendingInviteConfirmation          = _G.GetNextPendingInviteConfirmation
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local GetQuestID                                = _G.GetQuestID
local GetRealmName                              = _G.GetRealmName
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local RespondToInviteConfirmation               = _G.RespondToInviteConfirmation
local SettingsPanel                             = _G.SettingsPanel
local SocialQueueUtil_GetRelationshipInfo       = _G.SocialQueueUtil_GetRelationshipInfo
local StaticPopup_FindVisible                   = _G.StaticPopup_FindVisible
local StaticPopup_Hide                          = _G.StaticPopup_Hide
local StaticPopup1                              = _G.StaticPopup1
local StaticPopup1Text                          = _G.StaticPopup1Text
local UnitInRaid                                = _G.UnitInRaid
local UnitIsConnected                           = _G.UnitIsConnected
local UnitIsDeadOrGhost                         = _G.UnitIsDeadOrGhost
local UnitName                                  = _G.UnitName
local AreaPoiInfoGetAreaPOIForMap               = _G.C_AreaPoiInfo.GetAreaPOIForMap
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetAccountInfoByGUID             = _G.C_BattleNet.GetAccountInfoByGUID
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PartyInfoGetInviteReferralInfo            = _G.C_PartyInfo.GetInviteReferralInfo
local PartyInfoIsPartyFull                      = _G.C_PartyInfo.IsPartyFull
local PartyInfoInviteUnit                       = _G.C_PartyInfo.InviteUnit
local PartyInfoLeaveParty                       = _G.C_PartyInfo.LeaveParty
local PvPGetActiveMatchState                    = _G.C_PvP.GetActiveMatchState
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local TimerAfter                                = _G.C_Timer.After
local Settings_OpenToCategory                   = _G.Settings.OpenToCategory
local hooksecurefunc                            = _G.hooksecurefunc
local ipairs                                    = _G.ipairs
local next                                      = _G.next
local pairs                                     = _G.pairs
local print                                     = _G.print
local strfind                                   = _G.string.find
local strformat                                 = _G.string.format
local strlen                                    = _G.string.len
local strlower                                  = _G.string.lower
local strmatch                                  = _G.string.match
local time                                      = _G.time
local tonumber                                  = _G.tonumber
local type                                      = _G.type

-- initialize CF
CommFlare.CF = {
	-- strings
	AltsCommName = "Savage Alliance Slayers ALTS",
	MainCommName = "Savage Alliance Slayers",
	MapName = "",

	-- booleans
	AutoInvite = false,
	AutoPromote = false,
	AutoQueue = false,
	AutoQueueable = false,
	EventHandlerLoaded = false,
	HasAura = false,
	Reloaded = false,

	-- numbers
	ClubCount = 0,
	Count = 0,
	CommCount = 0,
	Expiration = 0,
	HideIndex = 0,
	IsHealer = 0,
	IsTank = 0,
	MapID = 0,
	MatchStartTime = 0,
	MatchStatus = 0,
	MercsCount = 0,
	NumScores = 0,
	PlayerRank = 0,
	Position = 0,
	PreviousCount = 0,
	QuestID = 0,
	SavedTime = 0,

	-- misc
	Category = nil,
	Field = nil,
	Header = nil,
	Leader = nil,
	MercList = nil,
	Options = nil,
	PartyGUID = nil,
	PlayerList = nil,
	PopupMessage = nil,
	Winner = nil,

	-- tables
	Clubs = {},
	ClubMembers = {},
	CommNamesList = {},
	CommunityLeaders = {},
	MapInfo = {},
	MemberInfo = {},
	MercNamesList = {},
	POIInfo = {},
	Queues = {},
	ReadyCheck = {},
	RoleChosen = {},
	ScoreInfo = {},
	StatusCheck = {},
	WidgetInfo = {},

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

-- list current POI's
local function CommunityFlare_List_POIs()
	-- get map id
	CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (not CommFlare.CF.MapID) then
		-- not found
		print("Map ID: Not Found")
		return
	end

	-- get map info
	print("MapID: ", CommFlare.CF.MapID)
	CommFlare.CF.MapInfo = MapGetMapInfo(CommFlare.CF.MapID)
	if (not CommFlare.CF.MapInfo) then
		-- not found
		print("Map Info: Not Found")
		return
	end

	-- process any POI's
	print("Map Name: ", CommFlare.CF.MapInfo.name)
	local pois = AreaPoiInfoGetAreaPOIForMap(CommFlare.CF.MapID)
	if (pois and (#pois > 0)) then
		-- display infos
		print("Count: ", #pois)
		for _,v in ipairs(pois) do
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, v)
			if (CommFlare.CF.POIInfo) then
				if ((not CommFlare.CF.POIInfo.description) or (CommFlare.CF.POIInfo.description == "")) then
					print(strformat("%s: ID = %d, textureIndex = %d", CommFlare.CF.POIInfo.name, CommFlare.CF.POIInfo.areaPoiID, CommFlare.CF.POIInfo.textureIndex))
				else
					print(strformat("%s: ID = %d, textureIndex = %d, Description = %s", CommFlare.CF.POIInfo.name, CommFlare.CF.POIInfo.areaPoiID, CommFlare.CF.POIInfo.textureIndex, CommFlare.CF.POIInfo.description))
				end
			end
		end
	else
		-- none found
		print("Count: 0")
	end
end

-- securely hook accept battlefield port
local function CommunityFlare_AcceptBattlefieldPort(index, acceptFlag)
	-- invalid index?
	if (not index or (index < 1) or (index > GetMaxBattlefieldID())) then
		-- finished
		return
	end

	-- is tracked pvp?
	local status, mapName = GetBattlefieldStatus(index)
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- leaving queue?
		if (acceptFlag == false) then
			-- community reporter enabled?
			local text = NS.CommunityFlare_GetGroupCount()
			if (CommFlare.db.profile.communityReporter == true) then
				-- only report drops for group leaders
				if (NS.CommunityFlare_IsGroupLeader() == true) then
					-- is epic battleground?
					local shouldReport = false
					if (isEpicBattleground == true) then
						-- report random epic battlegrounds option enabled?
						if (CommFlare.db.profile.reportQueueRandomEpicBgs == true) then
							shouldReport = true
						end
					-- is random battleground?
					elseif (isRandomBattleground == true) then
						-- report random battlegrounds option enabled?
						if (CommFlare.db.profile.reportQueueRandomBgs == true) then
							shouldReport = true
						end
					-- is brawl?
					elseif (isBrawl == true) then
						-- report brawls option enabled?
						if (CommFlare.db.profile.reportQueueBrawls == true) then
							shouldReport = true
						end
					end

					-- should report?
					if (shouldReport == true) then
						-- leaving popped queue?
						if (GetBattlefieldPortExpiration(index) > 0) then
							-- mercenary?
							if (CommFlare.CF.Queues[index].mercenary == true) then
								text = "Left Mercenary Queue for Popped " .. mapName .. "!"
							else
								text = "Left Queue for Popped " .. mapName .. "!"
							end
						else
							-- mercenary?
							if (CommFlare.CF.Queues[index].mercenary == true) then
								text = text .. " Dropped Mercenary Queue for " .. mapName .. "!"
							else
								text = text .. " Dropped Queue for " .. mapName .. "!"
							end
						end

						-- send to community?
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end
				end
			end

			-- are you in a party?
			if (IsInGroup() and not IsInRaid()) then
				-- leaving popped queue?
				if (GetBattlefieldPortExpiration(index) > 0) then 
					-- mercenary?
					if (CommFlare.CF.Queues[index].mercenary == true) then
						text = "Left Mercenary Queue for Popped " .. mapName .. "!"
					else
						text = "Left Queue for Popped " .. mapName .. "!"
					end

					-- send to party chat
					NS.CommunityFlare_SendMessage(nil, text)
				end
			end
		end
	end

	-- clear queue
	CommFlare.CF.Queues[index] = {}
end

-- securely hook honor frame queue queue button hover
local function CommunityFlare_HonorFrameQueueButton_OnEnter(self)
	-- not in a group?
	if (not IsInGroup()) then
		-- finished
		return
	end

	-- in a raid?
	if (IsInRaid()) then
		-- finished
		return
	end

	-- process all
	for i=1, GetNumGroupMembers() do
		local kickPlayer = false
		local unit = "party" .. i
		local player, realm = UnitName(unit)
		if (player and (player ~= "")) then
			-- realm name was given?
			if (realm and (realm ~= "")) then
				player = player .. "-" .. realm
			end

			-- are they dead/ghost?
			if (UnitIsDeadOrGhost(unit) == true) then
				-- kick them
				kickPlayer = true
			end

			-- are they offline?
			if (UnitIsConnected(unit) ~= true) then
				-- kick them
				kickPlayer = true
			end

			-- should kick?
			if (kickPlayer == true) then
				-- are you leader?
				if (NS.CommunityFlare_IsGroupLeader() == true) then
					-- ask to kick?
					NS.CommunityFlare_PopupBox("CommunityFlare_Kick_Dialog", player)
				end
			end
		end
	end
end

-- securely hook pvp ready dialog hide
local function CommunityFlare_PVPReadyDialog_OnHide(self)
	-- process all queues
	for i,v in ipairs(CommFlare.CF.Queues) do
		-- valid queue?
		if (CommFlare.CF.Queues[i] and (CommFlare.CF.Queues[i].popped ~= nil) and CommFlare.CF.Queues[i].popped > 0) then
			-- check expiration and time waited
			CommFlare.CF.Expiration = GetBattlefieldPortExpiration(i)
			CommFlare.CF.Timer.MilliSeconds = GetBattlefieldTimeWaited(i)
			if ((CommFlare.CF.Expiration == 0) and (CommFlare.CF.Timer.MilliSeconds == 0)) then
				-- mercenary?
				local text = ""
				if (CommFlare.CF.Queues[i].mercenary == true) then
					text = "Missed Mercenary Queue for " .. CommFlare.CF.Queues[i].name .. "!"
				else
					text = "Missed Queue for " .. CommFlare.CF.Queues[i].name .. "!"
				end

				-- clear queue
				CommFlare.CF.Queues[i] = {}

				-- are you in a party?
				if (IsInGroup() and not IsInRaid()) then
					-- send message to party that you've missed the queue
					NS.CommunityFlare_SendMessage(nil, text)
				end

				-- community reporter enabled?
				if (CommFlare.db.profile.communityReporter == true) then
					-- send to community?
					NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
				end
			end
		end
	end
end

-- process character micro button on mouse down
local function CharacterMicroButton_OnMouseDown()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- enabled
			CommFlare.CF.AllowCharacterFrame = true
		else
			-- disabled
			CommFlare.CF.AllowCharacterFrame = false
		end
	end
end

-- process character frame on show
local function CharacterFrame_OnShow()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- blocked?
			if (CommFlare.CF.AllowCharacterFrame ~= true) then
				-- hide
				HideUIPanel(CharacterFrame)
			else
				-- disabled
				CommFlare.CF.AllowCharacterFrame = false
			end
		else
			-- disabled
			CommFlare.CF.AllowCharacterFrame = false
		end
	end
end

-- process character frame on hide
local function CharacterFrame_OnHide()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- disabled
		CommFlare.CF.AllowCharacterFrame = false
	end
end

-- process guild micro button on mouse down
local function GuildMicroButton_OnMouseDown()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- enabled
			CommFlare.CF.AllowCommunitiesFrame = true
		else
			-- disabled
			CommFlare.CF.AllowCommunitiesFrame = false
		end
	end
end

-- process communities frame on show
local function CommunitiesFrame_OnShow()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- blocked?
			if (CommFlare.CF.AllowCommunitiesFrame ~= true) then
				-- hide
				HideUIPanel(CommunitiesFrame)
			else
				-- disabled
				CommFlare.CF.AllowCommunitiesFrame = false
			end
		else
			-- disabled
			CommFlare.CF.AllowCommunitiesFrame = false
		end
	end
end

-- process communities frame on hide
local function CommunitiesFrame_OnHide()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- disabled
		CommFlare.CF.AllowCommunitiesFrame = false
	end
end

-- process collections micro button on mouse down
local function CollectionsMicroButton_OnMouseDown()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- enabled
			CommFlare.CF.AllowCollectionsJournal = true
		else
			-- disabled
			CommFlare.CF.AllowCollectionsJournal = false
		end
	end
end

-- process collections journal on show
local function CollectionsJournal_OnShow()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- blocked?
			if (CommFlare.CF.AllowCollectionsJournal ~= true) then
				-- hide
				HideUIPanel(CollectionsJournal)
			else
				-- disabled
				CommFlare.CF.AllowCollectionsJournal = false
			end
		else
			-- disabled
			CommFlare.CF.AllowCollectionsJournal = false
		end
	end
end

-- process collections journal on hide
local function CollectionsJournal_OnHide()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- disabled
		CommFlare.CF.AllowCollectionsJournal = false
	end
end

-- process main menu micro button on mouse down
local function MainMenuMicroButton_OnMouseDown()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- enabled
			CommFlare.CF.AllowMainMenu = true
		else
			-- disabled
			CommFlare.CF.AllowMainMenu = false
		end
	end
end

-- process game menu on show
local function GameMenuFrame_OnShow()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- blocked?
			if (CommFlare.CF.AllowMainMenu ~= true) then
				-- hide
				HideUIPanel(GameMenuFrame)
			else
				-- disabled
				CommFlare.CF.AllowMainMenu = false
			end
		else
			-- disabled
			CommFlare.CF.AllowMainMenu = false
		end
	end
end

-- process game menu on hide
local function GameMenuFrame_OnHide()
	-- block game menu hot keys enabled?
	if (CommFlare.db.profile.blockGameMenuHotKeys == true) then
		-- disabled
		CommFlare.CF.AllowMainMenu = false
	end
end

-- setup hooks
local function CommunityFlare_SetupHooks()
	-- hook stuff
	hooksecurefunc("AcceptBattlefieldPort", CommunityFlare_AcceptBattlefieldPort)
	PVPReadyDialog:HookScript("OnHide", CommunityFlare_PVPReadyDialog_OnHide)

	-- hooks for blocking character frame hotkeys inside a battleground
	CommFlare.CF.AllowCharacterFrame = false
	CharacterMicroButton:HookScript("OnMouseDown", CharacterMicroButton_OnMouseDown)
	CharacterFrame:HookScript("OnShow", CharacterFrame_OnShow)
	CharacterFrame:HookScript("OnHide", CharacterFrame_OnHide)

	-- hooks for blocking collections menu hotkeys inside a battleground
	CommFlare.CF.AllowCollectionsJournal = false
	CollectionsMicroButton:HookScript("OnMouseDown", CollectionsMicroButton_OnMouseDown)
	CollectionsJournal:HookScript("OnShow", CollectionsJournal_OnShow)
	CollectionsJournal:HookScript("OnHide", CollectionsJournal_OnHide)

	-- hooks for blocking escape key inside a battleground
	CommFlare.CF.AllowMainMenu = false
	MainMenuMicroButton:HookScript("OnMouseDown", MainMenuMicroButton_OnMouseDown)
	GameMenuFrame:HookScript("OnShow", GameMenuFrame_OnShow)
	GameMenuFrame:HookScript("OnHide", GameMenuFrame_OnHide)
end

-- handle chat party message events
local function CommunityFlare_Event_Chat_Message_Party(...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- skip messages from yourself
	text = strlower(text)
	if (NS.CommunityFlare_GetPlayerName("full") ~= sender) then
		if (text == "!cf") then
			-- send community flare version number
			NS.CommunityFlare_SendMessage(nil, strformat("%s: %s", NS.CommunityFlare_Title, NS.CommunityFlare_Version))
		end
	end
end

-- handle chat whisper filtering
local function CommunityFlare_Chat_Whisper_Filter(self, event, msg, author, ...)
	-- found internal message?
	if (msg:find("!CF::")) then
		-- suppress
		return true
	end
end

--------------------------
-- Ace3 Code Below
--------------------------

-- process slash command
function CommFlare:Community_Flare_SlashCommand(input)
	-- force input to lowercase
	input = strlower(input)
	if (input == "inactive") then
		-- check for inactive players
		print("Checking for inactive players")
		NS.CommunityFlare_Check_For_Inactive_Players()
	elseif (input == "leaders") then
		-- rebuild leaders
		NS.CommunityFlare_RebuildCommunityLeaders()

		-- display community leaders
		local count = 0
		print("Listing Community Leaders")
		for _,v in ipairs(CommFlare.CF.CommunityLeaders) do
			-- display
			print(v)

			-- next
			count = count + 1
		end
		print(strformat("%d Community Leaders found.", count))
	elseif (input == "pois") then
		-- list all POI's
		CommunityFlare_List_POIs()
	elseif (input == "refresh") then
		-- process club members
		NS.CommunityFlare_Process_Club_Members()
		print(strformat("Refreshed members databased! %d members found.", NS.CommunityFlare_GetMemberCount()))
	elseif (input == "reset") then
		-- reset members database
		CommFlare.db.global.members = {}
		print("Cleared members database!")
	elseif (input == "usage") then
		-- display usages
		print("CPU Usage: ", GetAddOnCPUUsage("Community_Flare"))
		print("Memory Usage: ", GetAddOnMemoryUsage("Community_Flare"))
	else
		-- display full battleground setup
		NS.CommunityFlare_Battleground_Setup(true)
	end
end

-- process addon loaded
function CommFlare:ADDON_LOADED(msg, ...)
	local addOnName = ...

	-- Blizzard_PVPUI?
	if (addOnName == "Blizzard_PVPUI") then
		-- hook queue button mouse over
		HonorFrameQueueButton:HookScript("OnEnter", CommunityFlare_HonorFrameQueueButton_OnEnter)
	elseif (addOnName == "Blizzard_Communities") then
		-- hooks for blocking communities window inside a battleground
		CommFlare.CF.AllowCommunitiesFrame = false
		GuildMicroButton:HookScript("OnMouseDown", GuildMicroButton_OnMouseDown)
		CommunitiesFrame:HookScript("OnShow", CommunitiesFrame_OnShow)
		CommunitiesFrame:HookScript("OnHide", CommunitiesFrame_OnHide)
	end
end

-- process chat battle net whisper
function CommFlare:CHAT_MSG_BN_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- version check?
	text = strlower(text)
	if (text == "!cf") then
		-- send community flare version number
		NS.CommunityFlare_SendMessage(bnSenderID, strformat("%s: %s", NS.CommunityFlare_Title, NS.CommunityFlare_Version))
	-- status check?
	elseif (text == "!status") then
		-- process status check
		NS.CommunityFlare_Process_Status_Check(bnSenderID)
	-- asking for invite?
	elseif ((text == "inv") or (text == "invite")) then
		-- battle net auto invite enabled?
		if (CommFlare.db.profile.bnetAutoInvite == true) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				NS.CommunityFlare_SendMessage(bnSenderID, "Sorry, currently in a Battleground now.")
			else
				-- get bnet friend index
				local index = BNGetFriendIndex(bnSenderID)
				if (index ~= nil) then
					-- process all bnet accounts logged in
					local numGameAccounts = BattleNetGetFriendNumGameAccounts(index)
					for i=1, numGameAccounts do
						-- check if account has player guid online
						local accountInfo = BattleNetGetFriendGameAccountInfo(index, i)
						if (accountInfo.playerGuid) then
							-- party is full?
							if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
								-- send Battle.Net message
								NS.CommunityFlare_SendMessage(bnSenderID, "Sorry, group is currently full.")
							else
								-- get invite type
								local inviteType = GetDisplayedInviteType(accountInfo.playerGuid)
								if ((inviteType == "INVITE") or (inviteType == "SUGGEST_INVITE")) then
									BNInviteFriend(accountInfo.gameAccountID)
								elseif (inviteType == "REQUEST_INVITE") then
									BNRequestInviteFriend(accountInfo.gameAccountID)
								end
							end
							break
						end
					end
				end
			end
		else
			-- auto invite not enabled
			NS.CommunityFlare_SendMessage(bnSenderID, "Sorry, Battle.Net auto invite not enabled.")
		end
	end
end

-- process chat party message
function CommFlare:CHAT_MSG_PARTY(msg, ...)
	-- process chat message party event
	CommunityFlare_Event_Chat_Message_Party(...)
end

-- process chat party leader message
function CommFlare:CHAT_MSG_PARTY_LEADER(msg, ...)
	-- process chat message party event
	CommunityFlare_Event_Chat_Message_Party(...)
end

-- process system message
function CommFlare:CHAT_MSG_SYSTEM(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- someone has joined the battleground?
	text = strlower(text)
	if (text:find("has joined the instance group")) then
		-- community auto promote leader enabled?
		if (CommFlare.db.profile.communityAutoPromoteLeader == true) then
			-- not community leader?
			local player = NS.CommunityFlare_GetPlayerName("full")
			if (CommunityFlare_IsCommunityLeader(player) == false) then
				-- do you have lead?
				CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
				if (CommFlare.CF.PlayerRank == 2) then
					-- process all community leaders
					for _,v in ipairs(CommFlare.CF.CommunityLeaders) do
						-- promote this leader
						if (NS.CommunityFlare_Battleground_PromoteToLeader(v) == true) then
							-- success
							break
						end
					end
				end
			else
				-- do you have lead?
				CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
				if (CommFlare.CF.PlayerRank == 2) then
					-- process all community leaders
					for _,v in ipairs(CommFlare.CF.CommunityLeaders) do
						-- already leader?
						if (player == v) then
							-- success
							break
						end

						-- promote this leader
						if (NS.CommunityFlare_Battleground_PromoteToLeader(v) == true) then
							-- success
							break
						end
					end
				end
			end
		end
	-- notify system has been enabled?
	elseif (text:find("notify system has been enabled")) then
		-- display battleground setup
		CommFlare.CF.MatchStatus = 2
		CommFlare.CF.MatchStartTime = time()
		NS.CommunityFlare_Battleground_Setup(true)
	end
end

-- process chat whisper message
function CommFlare:CHAT_MSG_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- version check?
	text = strlower(text)
	if (text == "!cf") then
		-- send community flare version number
		NS.CommunityFlare_SendMessage(sender, strformat("%s: %s", NS.CommunityFlare_Title, NS.CommunityFlare_Version))
	-- pass leadership?
	elseif (text == "!pl") then
		-- not community leader?
		local player = NS.CommunityFlare_GetPlayerName("full")
		if (CommunityFlare_IsCommunityLeader(player) == false) then
			-- do you have lead?
			CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
			if (CommFlare.CF.PlayerRank == 2) then
				-- community leader?
				if (CommunityFlare_IsCommunityLeader(sender) == true) then
					NS.CommunityFlare_Battleground_PromoteToLeader(sender)
				end
			end
		end
	-- status check?
	elseif (text == "!status") then
		-- process status check
		NS.CommunityFlare_Process_Status_Check(sender)
	-- asking for invite?
	elseif ((text == "inv") or (text == "invite")) then
		-- community auto invite enabled?
		if (CommFlare.db.profile.communityAutoInvite == true) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				NS.CommunityFlare_SendMessage(sender, "Sorry, currently in a Battleground now.")
			else
				-- is sender a community member?
				CommFlare.CF.AutoInvite = CommunityFlare_IsCommunityMember(sender)
				if (CommFlare.CF.AutoInvite == true) then
					-- group is full?
					if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
						NS.CommunityFlare_SendMessage(sender, "Sorry, group is currently full.")
					else
						PartyInfoInviteUnit(sender)
					end
				end
			end
		else
			-- auto invite not enabled
			NS.CommunityFlare_SendMessage(sender, "Sorry, community auto invite not enabled.")
		end
	end
end

-- process chat monster yell message
function CommFlare:CHAT_MSG_MONSTER_YELL(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- Ashran, jeron killed?
	text = strlower(text)
	if (text:find("jeron emberfall has been slain")) then
		-- jeron emberfall killed
		CommFlare.CF.ASH.Jeron = "Killed"
	-- Ashran, rylai killed?
	elseif (text:find("rylai crestfall has been slain")) then
		-- rylai crestfall killed
		CommFlare.CF.ASH.Rylai = "Killed"
	end
end

-- process club member added
function CommFlare:CLUB_MEMBER_ADDED(msg, ...)
	local clubId, memberId = ...

	-- main community?
	if (CommFlare.db.profile.communityMain == clubId) then
		-- add club member
		NS.CommunityFlare_ClubMemberAdded(clubId, memberId)
	end
end

-- process club member removed
function CommFlare:CLUB_MEMBER_REMOVED(msg, ...)
	local clubId, memberId = ...

	-- main community?
	if (CommFlare.db.profile.communityMain == clubId) then
		-- remove club member
		NS.CommunityFlare_ClubMemberRemoved(clubId, memberId)
	end
end

-- process club member updated
function CommFlare:CLUB_MEMBER_UPDATED(msg, ...)
	local clubId, memberId = ...

	-- update club member
	NS.CommunityFlare_ClubMemberUpdated(clubId, memberId)
end

-- process group invite confirmation
function CommFlare:GROUP_INVITE_CONFIRMATION(msg)
	-- check for auto invites?
	local autoInvite = false
	if (not IsInGroup()) then
		-- yes
		autoInvite = true
	elseif (not IsInRaid() and IsInGroup()) then
		-- yes
		autoInvite = true
	end

	-- check for auto invites?
	if (autoInvite == true) then
		-- read the text
		local text = StaticPopup1Text["text_arg1"]
		if (text and (text ~= "")) then
			-- has requested to join your group?
			text = strlower(text)
			if (strfind(text, "has requested to join your group")) then
				-- get next pending invite
				local invite = GetNextPendingInviteConfirmation()
				if (invite) then
					-- get invite confirmation info
					local confirmationType, name, guid, rolesInvalid, willConvertToRaid, level, spec, itemLevel = GetInviteConfirmationInfo(invite)
					local referredByGuid, referredByName, relationType, isQuickJoin, clubId = PartyInfoGetInviteReferralInfo(invite)
					local _, _, selfRelationship = SocialQueueUtil_GetRelationshipInfo(guid, name, clubId)

					-- will invite cause conversion to raid?
					if (willConvertToRaid or (GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
						-- cancel invite
						RespondToInviteConfirmation(invite, false)

						-- hide popup
						if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
							-- hide
							StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
						end

						-- battle net friend?
						if (selfRelationship == "bnfriend") then
							local accountInfo = BattleNetGetAccountInfoByGUID(guid)
							if (accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.playerGuid) then
								-- send battle net message
								NS.CommunityFlare_SendMessage(accountInfo.bnetAccountID, "Sorry, group is currently full.")
							end
						else
							-- send message
							NS.CommunityFlare_SendMessage(name, "Sorry, group is currently full.")
						end
					else
						-- has proper name?
						local player = ""
						if (name and (name ~= "")) then
							-- force name-realm format
							player = name
							if (not strmatch(player, "-")) then
								-- add realm name
								player = player .. "-" .. GetRealmName()
							end
						end

						-- battle net friend?
						if (selfRelationship == "bnfriend") then
							-- battle net auto invite enabled?
							if (CommFlare.db.profile.bnetAutoInvite == true) then
								-- accept invite
								RespondToInviteConfirmation(invite, true)

								-- hide popup
								if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
									-- hide
									StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
								end
							end
						-- community auto invite enabled?
						elseif (CommFlare.db.profile.communityAutoInvite == true) then
							-- is sender a community member?
							CommFlare.CF.AutoInvite = CommunityFlare_IsCommunityMember(player)
							if (CommFlare.CF.AutoInvite == true) then
								-- accept invite
								RespondToInviteConfirmation(invite, true)

								-- hide popup
								if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
									-- hide
									StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
								end
							end
						end
					end
				end
			-- you will be removed from?
			elseif (strfind(text, "you will be removed from")) then
				-- cancel invite
				RespondToInviteConfirmation(invite, false)

				-- hide popup
				if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
					-- hide
					StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
				end
			end
		end
	end
end

-- process group joined
function CommFlare:GROUP_JOINED(msg, ...)
	local category, partyGUID = ...

	-- save partyGUID
	CommFlare.CF.PartyGUID = partyGUID
end

-- process group left
function CommFlare:GROUP_LEFT(msg, ...)
	local category, partyGUID = ...

	-- delete partyGUID
	CommFlare.CF.PartyGUID = nil
end

-- process group roster update
function CommFlare:GROUP_ROSTER_UPDATE(msg)
	-- not in raid and in group?
	if (not IsInRaid() and IsInGroup()) then
		-- are you group leader?
		if (NS.CommunityFlare_IsGroupLeader() == true) then
			-- community reporter enabled?
			if (CommFlare.db.profile.communityReporter == true) then
				-- check current players in home party
				local count = 1
				local players = GetHomePartyInfo()
				if (players ~= nil) then
					-- has group size changed?
					local text = NS.CommunityFlare_GetGroupCount()
					count = #players + count
					if ((CommFlare.CF.PreviousCount > 0) and (CommFlare.CF.PreviousCount < 5) and (count == 5)) then
						-- send to community?
						text = text .. " Full Now!"
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end
				end

				-- save previous count
				CommFlare.CF.PreviousCount = count
				return
			end
		end
	end

	-- clear previous count
	CommFlare.CF.PreviousCount = 0
end

-- process initial clubs loaded
function CommFlare:INITIAL_CLUBS_LOADED(msg)
	-- should readd community channels?
	if (CommFlare.db.profile.alwaysReaddChannels == true) then
		-- has main community?
		if (CommFlare.db.profile.communityMain > 1) then
			-- readd community chat window
			NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityMain, 1)
		end

		-- has other communities?
		if (next(CommFlare.db.profile.communityList)) then
			-- process all
			local timer = 0.2
			for k,v in pairs(CommFlare.db.profile.communityList) do
				-- only process true
				if (v == true) then
					-- stagger readding
					TimerAfter(timer, function ()
						-- readd community chat window
						NS.CommunityFlare_ReaddCommunityChatWindow(k, 1)
					end)

					-- next
					timer = timer + 0.2
				end
			end
		end
	end

	-- process club members after 5 seconds
	TimerAfter(5, NS.CommunityFlare_Process_Club_Members)
end

-- process lfg role check role chosen
function CommFlare:LFG_ROLE_CHECK_ROLE_CHOSEN(msg, ...)
	local name, isTank, isHealer, isDamage = ...
	local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

	-- build proper name
	local player = name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	end

	-- are you group leader?
	if (NS.CommunityFlare_IsGroupLeader() == true) then
		-- is this your role?
		if (name == UnitName("player")) then
			-- initialize queue session
			NS.CommunityFlare_Initialize_Queue_Session()
		end
	end

	-- is battleground queue?
	if (bgQueue) then
		-- is tracked pvp?
		local mapName = GetLFGRoleUpdateBattlegroundInfo()
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- role chosen
			CommFlare.CF.RoleChosen[player] = true
		end
	end
end

-- process lfg role check show
function CommFlare:LFG_ROLE_CHECK_SHOW(msg, ...)
	local isRequeue = ...
	local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

	-- is battleground queue?
	if (bgQueue) then
		-- is tracked pvp?
		local mapName = GetLFGRoleUpdateBattlegroundInfo()
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- is epic battleground?
			CommFlare.CF.AutoQueueable = false
			if (isEpicBattleground == true) then
				-- auto queue option enabled?
				if (CommFlare.db.profile.autoQueueRandomEpicBgs == true) then
					-- wants to auto queue
					CommFlare.CF.AutoQueueable = true
				end
			-- is random battleground?
			elseif (isRandomBattleground == true) then
				-- auto queue option enabled?
				if (CommFlare.db.profile.autoQueueRandomBgs == true) then
					-- wants to auto queue
					CommFlare.CF.AutoQueueable = true
				end
			-- is brawl?
			elseif (isBrawl == true) then
				-- auto queue option enabled?
				if (CommFlare.db.profile.autoQueueBrawls == true) then
					-- wants to auto queue
					CommFlare.CF.AutoQueable = true
				end
			end

			-- is auto queue allowed?
			if (CommFlare.CF.AutoQueueable == true) then
				-- capable of auto queuing?
				CommFlare.CF.AutoQueueable = false
				if (not IsInRaid()) then
					CommFlare.CF.AutoQueueable = true
				else
					-- larger than rated battleground count?
					if (GetNumGroupMembers() > 10) then
						CommFlare.CF.AutoQueueable = true
					end
				end

				-- auto queueable?
				CommFlare.CF.AutoQueue = false
				if (CommFlare.CF.AutoQueueable == true) then
					-- always auto queue?
					if (CommFlare.db.profile.alwaysAutoQueue == true) then
						CommFlare.CF.AutoQueue = true
					-- community auto queue?
					elseif (CommFlare.db.profile.communityAutoQueue == true) then
						-- is party leader a community member?
						local leader = NS.CommunityFlare_GetPartyLeader()
						CommFlare.CF.AutoQueue = CommunityFlare_IsCommunityMember(leader)
					end
				end

				-- auto queue enabled?
				if (CommFlare.CF.AutoQueue == true) then
					-- check for deserter
					NS.CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
					if (CommFlare.CF.HasAura == false) then
						-- is shown?
						if (LFDRoleCheckPopupAcceptButton:IsShown()) then
							-- click accept button
							LFDRoleCheckPopupAcceptButton:Click()
						end
					else
						-- have deserter / leave party
						NS.CommunityFlare_SendMessage(nil, "Sorry, I currently have Deserter! Leaving party to avoid interrupting the queue!")
						PartyInfoLeaveParty()
					end
				end
			end
		end
	end
end

-- process notify pvp afk result
function CommFlare:NOTIFY_PVP_AFK_RESULT(msg, ...)
	local offender, numBlackMarksOnOffender, numPlayersIHaveReported = ...

	-- hmmm, what is this?
	print(strformat("NOTIFY_PVP_AFK_RESULT: %s = %s, %s", offender, numBlackMarksOnOffender, numPlayersIHaveReported))
end

-- process party invite request
function CommFlare:PARTY_INVITE_REQUEST(msg, ...)
	local sender, _, _, _, _, _, guid, questSessionActive = ...

	-- verify player does not have deserter debuff
	NS.CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
	if (CommFlare.CF.HasAura == false) then
		-- community auto invite enabled?
		if (CommFlare.db.profile.communityAutoInvite == true) then
			-- is sender a community member?
			CommFlare.CF.AutoInvite = CommunityFlare_IsCommunityMember(sender)
			if (CommFlare.CF.AutoInvite == true) then
				-- lfg invite popup shown?
				if (LFGInvitePopup:IsShown()) then
					-- click accept button
					LFGInvitePopupAcceptButton:Click()
				-- static popup shown?
				elseif (StaticPopup_FindVisible("PARTY_INVITE")) then
					-- accept party
					AcceptGroup()

					-- hide
					StaticPopup_Hide("PARTY_INVITE")
				end
			end
		end
	else
		-- send whisper back that you have deserter
		NS.CommunityFlare_SendMessage(sender, "Sorry, I currently have Deserter!")
		if (LFGInvitePopup:IsShown()) then
			-- click decline button
			LFGInvitePopupDeclineButton:Click()
		end
	end
end

-- process party leader changed
function CommFlare:PARTY_LEADER_CHANGED(msg)
	-- notify enabled?
	if (CommFlare.db.profile.partyLeaderNotify > 1) then
		-- in group?
		if (IsInGroup()) then
			-- not in a raid?
			if (not IsInRaid()) then
				-- has more than 1 member?
				if (GetNumSubgroupMembers() > 0) then
					if (NS.CommunityFlare_IsGroupLeader() == true) then
						-- you are the new party leader
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", "YOU ARE CURRENTLY THE NEW GROUP LEADER")
					end
				end
			end
		end
	end
end

-- process player entering world
function CommFlare:PLAYER_ENTERING_WORLD(msg, ...)
	local isInitialLogin, isReloadingUi = ...
	if ((isInitialLogin) or (isReloadingUi)) then
		-- display version
		print(strformat("%s: %s", NS.CommunityFlare_Title, NS.CommunityFlare_Version))

		-- global created?
		if (not CommFlare.db.global) then
			CommFlare.db.global = {}
		end

		-- load / initialize members
		CommFlare.db.global.members = CommFlare.db.global.members or {}

		-- add chat whisper filtering
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CommunityFlare_Chat_Whisper_Filter)

		-- fix setting
		if (CommFlare.db.profile.communityReportID == 0) then
			-- set default report ID
			CommFlare.db.profile.communityReportID = CommFlare.db.profile.communityMain
		end

		-- reloading?
		if (isReloadingUi) then
			-- reloaded
			CommFlare.CF.Reloaded = true

			-- load previous session
			NS.CommunityFlare_LoadSession()

			-- inside battleground?
			CommFlare.CF.MatchStatus = 0
			if (PvPIsBattleground() == true) then
				-- match state is active?
				if (PvPGetActiveMatchState() == Enum.PvPMatchState.Active) then
					-- match is active state?
					CommFlare.CF.MatchStatus = 1
					if (PvPGetActiveMatchDuration() > 0) then
						-- match started
						CommFlare.CF.MatchStatus = 2
					end
				end
			end

			-- setup main community list
			NS.CommunityFlare_Setup_Main_Community_List(nil)

			-- process club members after 5 seconds
			TimerAfter(5, NS.CommunityFlare_Process_Club_Members)
		end
	end
end

-- process player login
function CommFlare:PLAYER_LOGIN(msg)
	-- event hooks not enabled yet?
	if (CommFlare.CF.EventHandlerLoaded == false) then
		-- process queue stuff
		CommunityFlare_SetupHooks()
		CommFlare.CF.EventHandlerLoaded = true
	end
end

-- process player logout
function CommFlare:PLAYER_LOGOUT(msg)
	-- save session variables
	NS.CommunityFlare_SaveSession()
end

-- process pvp match active
function CommFlare:PVP_MATCH_ACTIVE(msg)
	-- ASH exists?
	if (not CommFlare.CF.ASH) then
		-- create base
		CommFlare.CF.ASH = {}
	end

	-- always reset ashran mages
	CommFlare.CF.ASH.Jeron = "Up"
	CommFlare.CF.ASH.Rylai = "Up"

	-- active status
	CommFlare.CF.MatchStatus = 1

	-- process club members
	NS.CommunityFlare_Process_Club_Members()
end

-- process pvp match complete
function CommFlare:PVP_MATCH_COMPLETE(msg, ...)
	local winner, duration = ...

	-- update battleground status
	CommFlare.CF.MatchStatus = 3
	NS.CommunityFlare_Update_Battleground_Status()

	-- report to anyone?
	if (CommFlare.CF.StatusCheck) then
		-- get winner / mercenary status
		CommFlare.CF.Winner = GetBattlefieldWinner()
		NS.CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")

		-- process all
		local timer = 0.0
		for k,v in pairs(CommFlare.CF.StatusCheck) do
			-- send replies staggered
			TimerAfter(timer, function()
				-- is player mercenary?
				local text = "Epic Battleground has completed with a "
				if (CommFlare.CF.HasAura == true) then
					-- battle won?
					if (CommFlare.CF.Winner == 0) then
						-- horde victory / mercenary
						text = text .. "loss!"
					else
						-- alliance victory / mercenary
						text = text .. "victory!"
					end
				-- player is not a mercenary
				else
					-- battle won?
					if (CommFlare.CF.Winner == 0) then
						-- horde victory / not mercenary
						text = text .. "victory!"
					else
						-- alliance victory / not mercenary
						text = text .. "loss!"
					end
				end

				-- send message
				text = text .. " (" .. CommFlare.CF.CommCount .. " Community Members.)"
				NS.CommunityFlare_SendMessage(k, text)
			end)

			-- next
			timer = timer + 0.2
		end
	end

	-- clear
	CommFlare.CF.StatusCheck = {}
end

-- process pvp match inactive
function CommFlare:PVP_MATCH_INACTIVE(msg)
	-- reset battleground status
	CommFlare.CF.MatchStatus = 0
	NS.CommunityFlare_Reset_Battleground_Status()
end

-- process quest detail
function CommFlare:QUEST_DETAIL(msg, ...)
	local questStartItemID = ...

	-- verify quest giver
	local player, realm = UnitName("questnpc")
	if (player and (player ~= "")) then
		-- has realm?
		if (realm and (realm ~= "")) then
			-- add realm
			player = player .. "-" .. realm
		end

		-- unit in raid?
		if (UnitInRaid(player) ~= nil) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- block all shared quests?
				local decline = false
				if (CommFlare.db.profile.blockSharedQuests == 3) then
					-- always decline
					decline = true
				-- block irrelevant quests?
				elseif (CommFlare.db.profile.blockSharedQuests == 2) then
					-- get MapID
					CommFlare.CF.MapID = MapGetBestMapForUnit("player")
					if (CommFlare.CF.MapID and (CommFlare.CF.MapID > 0)) then
						-- initialize
						decline = true
						local epicBG = false
						CommFlare.CF.QuestID = GetQuestID()

						-- alterac valley or korrak's revenge?
						if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
							-- list of allowed quests
							local allowedQuests = {
								[56257] = true, -- The Battle for Alterac (Seasonal)
								[56259] = true, -- Lokholar the Ice Lord (Seasonal)
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[CommFlare.CF.QuestID] and (allowedQuests[CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						-- isle of conquest?
						elseif (CommFlare.CF.MapID == 169) then
							-- epic battleground
							epicBG = true
						-- battle for wintergrasp?
						elseif (CommFlare.CF.MapID == 1334) then
							-- list of allowed quests
							local allowedQuests = {
								[13178] = true, -- Slay them all
								[13183] = true, -- Victory in Wintergrasp
								[13185] = true, -- Stop the Siege
								[13223] = true, -- Defend the Siege
								[13539] = true, -- Toppling the Towers
								[55509] = true, -- Victory in Wintergrasp (Seasonal)
								[55511] = true, -- Slay them all! (Seasonal)
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[CommFlare.CF.QuestID] and (allowedQuests[CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						-- ashran?
						elseif (CommFlare.CF.MapID == 1478) then
							-- list of allowed quests
							local allowedQuests = {
								[56337] = true, -- Uncovering the Artifact Fragments (Seasonal)
								[56339] = true, -- Tremblade Must Die (Seasonal)
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[CommFlare.CF.QuestID] and (allowedQuests[CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						end

						-- epic battleground?
						if (epicBG == true) then
							-- list of allowed quests
							local allowedQuests = {
								[72167] = true,
								[72723] = true,
							}

							-- allowed quest?
							if (allowedQuests[CommFlare.CF.QuestID] and (allowedQuests[CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						end
					end
				end

				-- decline?
				if (decline == true) then
					-- decline quest
					DeclineQuest()
					print("Auto declined quest from ", player)
				end
			end
		end
	end
end

-- process ready check
function CommFlare:READY_CHECK(msg, ...)
	local sender, timeleft = ...

	-- initialize partyX to false if you are leader
	CommFlare.CF.ReadyCheck = {}
	if (NS.CommunityFlare_IsGroupLeader() == true) then
		-- are you grouped?
		if (IsInGroup()) then
			-- are you in a raid?
			if (not IsInRaid()) then
				-- process all group members
				for i=1, GetNumGroupMembers() do
					local unit = "party" .. i
					local name, realm = UnitName(unit)
					if (name and (name ~= "")) then
						-- not ready
						CommFlare.CF.ReadyCheck[unit] = false
					end
				end
			end
		end
	end

	-- does the player have the mercenary buff?
	NS.CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
	if (CommFlare.CF.HasAura == true) then
		NS.CommunityFlare_SendMessage(nil, "I currently have the Mercenary Contract BUFF! (Are we mercing?)")
	end

	-- capable of auto queuing?
	CommFlare.CF.AutoQueueable = false
	if (not IsInRaid()) then
		CommFlare.CF.AutoQueueable = true
	else
		-- larger than rated battleground count?
		if (GetNumGroupMembers() > 10) then
			CommFlare.CF.AutoQueueable = true
		end
	end

	-- auto queueable?
	CommFlare.CF.AutoQueue = false
	if (CommFlare.CF.AutoQueueable == true) then
		-- always auto queue?
		if (CommFlare.db.profile.alwaysAutoQueue == true) then
			CommFlare.CF.AutoQueue = true
		-- community auto queue?
		elseif (CommFlare.db.profile.communityAutoQueue == true) then
			-- is sender a community member?
			CommFlare.CF.AutoQueue = CommunityFlare_IsCommunityMember(sender)
		end
	end

	-- auto queue enabled?
	if (CommFlare.CF.AutoQueue == true) then
		-- verify player does not have deserter debuff
		NS.CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
		if (CommFlare.CF.HasAura == false) then
			if (ReadyCheckFrame:IsShown()) then
				-- click yes button
				ReadyCheckFrameYesButton:Click()
			end

			-- ready
			CommFlare.CF.ReadyCheck["player"] = true
		else
			-- send back to party that you have deserter
			NS.CommunityFlare_SendMessage(nil, "Sorry, I currently have Deserter!")
			if (ReadyCheckFrame:IsShown()) then
				-- click no button
				ReadyCheckFrameNoButton:Click()
			end

			-- not ready
			CommFlare.CF.ReadyCheck["player"] = false
		end
	end
end

-- process ready check confirm
function CommFlare:READY_CHECK_CONFIRM(msg, ...)
	local unit, isReady = ...

	-- auto queueable?
	if (CommFlare.CF.AutoQueueable == true) then
		-- save unit ready check status
		CommFlare.CF.ReadyCheck[unit] = isReady
	end
end

-- process ready check finished
function CommFlare:READY_CHECK_FINISHED(msg, ...)
	local preempted = ...
	if (preempted == true) then
		-- clear ready check
		CommFlare.CF.ReadyCheck = {}
		return
	end

	-- auto queueable?
	if (CommFlare.CF.AutoQueueable == true) then
		-- are you grouped?
		if (IsInGroup()) then
			-- are you not in a raid?
			if (not IsInRaid()) then
				-- process all ready checks
				local isEveryoneReady = true
				for k,v in pairs(CommFlare.CF.ReadyCheck) do
					-- unit not ready?
					if (v ~= true) then
						-- everyone not ready
						isEveryoneReady = false
					end
				end

				-- is everyone ready?
				if (isEveryoneReady == true) then
					-- community reporter enabled?
					if (CommFlare.db.profile.communityReporter == true) then
						-- only report ready checks for group leaders
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- check if group has room for more
							local text = NS.CommunityFlare_GetGroupCount() .. " Ready!"
							if (CommFlare.CF.Count < 5) then
								-- community auto invite enabled
								if (CommFlare.db.profile.communityAutoInvite == true) then
									-- update text
									text = text .. " (For auto invite, whisper me INV)"
								end
							end

							-- send to community?
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				end
			end
		end
	end

	-- clear ready check
	CommFlare.CF.ReadyCheck = {}
end

-- process ui info message
function CommFlare:UI_INFO_MESSAGE(msg, ...)
	local type, text = ...

	-- someone has deserter?
	text = strlower(text)
	if (text:find("deserter")) then
		print("Someone has Deserter debuff!")
	end
end

-- process unit spellcast start
function CommFlare:UNIT_SPELLCAST_START(msg, ...)
	local unitTarget, castGUID, spellID = ...

	-- only check player
	if (unitTarget == "player") then
		-- has warning setting enabled?
		if (CommFlare.db.profile.warningLeavingBG > 1) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- hearthstone?
				if (NS.HearthStoneSpells[spellID]) then
					-- raid warning?
					if (CommFlare.db.profile.warningLeavingBG == 2) then
						-- issue raid warning (with raid warning audio sound)
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", "Are you really sure you want to HEARTHSTONE?")
					end
				-- teleporting?
				elseif (NS.TeleportSpells[spellID]) then
					-- raid warning?
						if (CommFlare.db.profile.warningLeavingBG == 2) then
						-- issue raid warning (with raid warning audio sound)
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", "Are you really sure you want to TELEPORT?")
					end
				end
			end
		end
	end
end

-- process update battlefield status
function CommFlare:UPDATE_BATTLEFIELD_STATUS(msg, ...)
	local index = ...

	-- invalid index?
	if (not index or (index < 1) or (index > GetMaxBattlefieldID())) then
		-- finished
		return
	end

	-- is tracked pvp?
	local status, mapName = GetBattlefieldStatus(index)
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- queued?
		if (status == "queued") then
			-- just entering queue?
			if (not CommFlare.CF.Queues[index] or not CommFlare.CF.Queues[index].name or (CommFlare.CF.Queues[index].name == "")) then
				-- add to queues
				CommFlare.CF.Queues[index] = {
					name = mapName,
					created = time(),
					entered = false,
					joined = true,
					popped = 0,
				}

				-- delay some
				TimerAfter(0.5, function()
					-- community reporter enabled?
					if (CommFlare.db.profile.communityReporter == true) then
						-- only report joined queues for group leaders
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- report joined queue with estimated time
							NS.CommunityFlare_Report_Joined_With_Estimated_Time()
						end
					end
				end)
			end
		-- confirm?
		elseif (status == "confirm") then
			-- queue just popped?
			if (CommFlare.CF.Queues[index] and (CommFlare.CF.Queues[index].popped ~= nil) and (CommFlare.CF.Queues[index].popped == 0)) then
				-- set popped
				CommFlare.CF.Queues[index].popped = time()

				-- port expiration not expired?
				CommFlare.CF.Expiration = GetBattlefieldPortExpiration(index)
				if (CommFlare.CF.Expiration > 0) then
					-- community reporter enabled?
					if (CommFlare.db.profile.communityReporter == true) then
						-- only report pops for group leaders
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- is epic battleground?
							local shouldReport = false
							if (isEpicBattleground == true) then
								-- report random epic battlegrounds option enabled?
								if (CommFlare.db.profile.reportQueueRandomEpicBgs == true) then
									shouldReport = true
								end
							-- is random battleground?
							elseif (isRandomBattleground == true) then
								-- report random battlegrounds option enabled?
								if (CommFlare.db.profile.reportQueueRandomBgs == true) then
									shouldReport = true
								end
							-- is brawl?
							elseif (isBrawl == true) then
								-- report brawls option enabled?
								if (CommFlare.db.profile.reportQueueBrawls == true) then
									shouldReport = true
								end
							end

							-- should report?
							if (shouldReport == true) then
								-- mercenary?
								local text = NS.CommunityFlare_GetGroupCount()
								if (CommFlare.CF.Queues[index].mercenary == true) then
									text = text .. " Mercenary Queue Popped for " .. mapName .. "!"
								else
									text = text .. " Queue Popped for " .. mapName .. "!"
								end

								-- send to community?
								NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
							end
						end
					end
				-- port expired
				else
					-- clear queue
					CommFlare.CF.Queues[index] = {}
				end
			end
		-- none?
		elseif (status == "none") then
			-- clear queue
			CommFlare.CF.Queues[index] = {}
		end
	else
		-- clear queue
		CommFlare.CF.Queues[index] = {}
	end
end

-- enabled
function CommFlare:OnEnable()
	-- register events
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CLUB_MEMBER_ADDED")
	self:RegisterEvent("CLUB_MEMBER_REMOVED")
	self:RegisterEvent("CLUB_MEMBER_UPDATED")
	self:RegisterEvent("GROUP_INVITE_CONFIRMATION")
	self:RegisterEvent("GROUP_JOINED")
	self:RegisterEvent("GROUP_LEFT")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("INITIAL_CLUBS_LOADED")
	self:RegisterEvent("LFG_ROLE_CHECK_ROLE_CHOSEN")
	self:RegisterEvent("LFG_ROLE_CHECK_SHOW")
	self:RegisterEvent("NOTIFY_PVP_AFK_RESULT")
	self:RegisterEvent("PARTY_INVITE_REQUEST")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PVP_MATCH_ACTIVE")
	self:RegisterEvent("PVP_MATCH_COMPLETE")
	self:RegisterEvent("PVP_MATCH_INACTIVE")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("READY_CHECK_CONFIRM")
	self:RegisterEvent("READY_CHECK_FINISHED")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- disabled
function CommFlare:OnDisable()
	-- unregister events
	self:UnregisterEvent("ADDON_LOADED")
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
	self:UnregisterEvent("CHAT_MSG_PARTY")
	self:UnregisterEvent("CHAT_MSG_PARTY_LEADER")
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	self:UnregisterEvent("CLUB_MEMBER_ADDED")
	self:UnregisterEvent("CLUB_MEMBER_REMOVED")
	self:UnregisterEvent("CLUB_MEMBER_UPDATED")
	self:UnregisterEvent("GROUP_INVITE_CONFIRMATION")
	self:UnregisterEVent("GROUP_JOINED")
	self:UnregisterEvent("GROUP_LEFT")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
	self:UnregisterEvent("INITIAL_CLUBS_LOADED")
	self:UnregisterEvent("LFG_ROLE_CHECK_ROLE_CHOSEN")
	self:UnregisterEvent("LFG_ROLE_CHECK_SHOW")
	self:UnregisterEvent("NOTIFY_PVP_AFK_RESULT")
	self:UnregisterEvent("PARTY_INVITE_REQUEST")
	self:UnregisterEvent("PARTY_LEADER_CHANGED")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("PLAYER_LOGIN")
	self:UnregisterEvent("PLAYER_LOGOUT")
	self:UnregisterEvent("PVP_MATCH_ACTIVE")
	self:UnregisterEvent("PVP_MATCH_COMPLETE")
	self:UnregisterEvent("PVP_MATCH_INACTIVE")
	self:UnregisterEvent("QUEST_DETAIL")
	self:UnregisterEvent("READY_CHECK")
	self:UnregisterEvent("READY_CHECK_CONFIRM")
	self:UnregisterEvent("READY_CHECK_FINISHED")
	self:UnregisterEvent("UI_INFO_MESSAGE")
	self:UnregisterEvent("UNIT_SPELLCAST_START")
	self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- refresh config
function CommFlare:RefreshConfig()
	-- setup community lists
	NS.CommunityFlare_Setup_Main_Community_List(nil)
	NS.CommunityFlare_Setup_Other_Community_List(nil)
end

-- initialize
function CommFlare:OnInitialize()
	-- setup options stuff
	self.db = LibStub("AceDB-3.0"):New("CommunityFlareDB", NS.defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	AC:RegisterOptionsTable("CommFlare_Options", NS.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CommFlare_Options", "Community Flare")

	-- setup profile stuff
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AC:RegisterOptionsTable("CommFlare_Profiles", profiles)
	ACD:AddToBlizOptions("CommFlare_Profiles", "Profiles", "Community Flare")

	-- check for old string values?
	if (type(CommFlare.db.profile.blockSharedQuests) == "string") then
		-- convert to number
		CommFlare.db.profile.blockSharedQuests = tonumber(CommFlare.db.profile.blockSharedQuests)
	end
	if (type(CommFlare.db.profile.communityAutoAssist) == "string") then
		-- convert to number
		CommFlare.db.profile.communityAutoAssist = tonumber(CommFlare.db.profile.communityAutoAssist)
	end
	if (type(CommFlare.db.profile.uninvitePlayersAFK) == "string") then
		-- convert to number
		CommFlare.db.profile.uninvitePlayersAFK = tonumber(CommFlare.db.profile.uninvitePlayersAFK)
	end
end

-- addon compartment on click
function CommunityFlare_AddonCompartmentOnClick(addonName, buttonName)
	-- already opened?
	if SettingsPanel:IsShown() then
		-- hide
		SettingsPanel:Hide()
	else
		-- open options to Community Flare
		Settings_OpenToCategory(NS.CommunityFlare_Title)
		Settings_OpenToCategory(NS.CommunityFlare_Title) -- open options again (wow bug workaround)
	end
end

-- register slash command
CommFlare:RegisterChatCommand("comf", "Community_Flare_SlashCommand")
