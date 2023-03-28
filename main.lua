-- initialize ACE3
CommFlare = LibStub("AceAddon-3.0"):NewAddon("Community Flare", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

-- localize stuff
local _G                                        = _G
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNInviteFriend                            = _G.BNInviteFriend
local BNSendWhisper                             = _G.BNSendWhisper
local CreateFrame                               = _G.CreateFrame
local DevTools_Dump                             = _G.DevTools_Dump
local GetAddOnCPUUsage                          = _G.GetAddOnCPUUsage
local GetAddOnMemoryUsage                       = _G.GetAddOnMemoryUsage
local GetAddOnMetadata                          = _G.GetAddOnMetadata
local GetBattlefieldEstimatedWaitTime           = _G.GetBattlefieldEstimatedWaitTime
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetChannelName                            = _G.GetChannelName
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
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
local SendChatMessage                           = _G.SendChatMessage
local StaticPopupDialogs                        = _G.StaticPopupDialogs
local StaticPopup_Show                          = _G.StaticPopup_Show
local StaticPopup1                              = _G.StaticPopup1
local StaticPopup1Text                          = _G.StaticPopup1Text
local UnitFullName                              = _G.UnitFullName
local UnitGUID                                  = _G.UnitGUID
local UnitInRaid                                = _G.UnitInRaid
local UnitIsGroupLeader                         = _G.UnitIsGroupLeader
local UnitName                                  = _G.UnitName
local AuraUtilForEachAura                       = _G.AuraUtil.ForEachAura
local AreaPoiInfoGetAreaPOIForMap               = _G.C_AreaPoiInfo.GetAreaPOIForMap
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local ChatInfoRegisterAddonMessagePrefix        = _G.C_ChatInfo.RegisterAddonMessagePrefix
local ChatInfoSendAddonMessage                  = _G.C_ChatInfo.SendAddonMessage
local ClubGetClubMembers                        = _G.C_Club.GetClubMembers
local ClubGetMemberInfo                         = _G.C_Club.GetMemberInfo
local ClubGetSubscribedClubs                    = _G.C_Club.GetSubscribedClubs
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PartyInfoIsPartyFull                      = _G.C_PartyInfo.IsPartyFull
local PartyInfoInviteUnit                       = _G.C_PartyInfo.InviteUnit
local PartyInfoLeaveParty                       = _G.C_PartyInfo.LeaveParty
local PvPGetActiveMatchState                    = _G.C_PvP.GetActiveMatchState
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPGetScoreInfo                           = _G.C_PvP.GetScoreInfo
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
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
local strlen                                    = _G.string.len
local strlower                                  = _G.string.lower
local strmatch                                  = _G.string.match

-- get current version
local CommunityFlare_Version = GetAddOnMetadata("Community_Flare", "Version") or "unspecified"

-- defaults
local defaults = {
	profile = {
		-- variables
		SASID = 0,
		MatchStatus = 0,
		SavedTime = 0,

		-- profile only options
		alwaysAutoQueue = false,
		autoQueueRandomBgs = false,
		autoQueueRandomEpicBgs = true,
		bnetAutoInvite = false,
		communityAutoAssist = "2",
		communityAutoInvite = true,
		communityAutoPromoteLeader = true,
		communityAutoQueue = true,
		communityReporter = true,

		-- tables
		ASH = {},
		AV = {},
		IOC = {},
		WG = {},
	},
}

-- options
local options = {
	name = "Community Flare " .. CommunityFlare_Version,
	handler = CommFlare,
	type = "group",
	args = {
		queue = {
			type = "group",
			order = 1,
			name = "Queue Options",
			inline = true,
			args = {
				alwaysAutoQueue = {
					type = "toggle",
					order = 1,
					name = "Always automatically queue?",
					desc = "This will always automatically accept all queues for you.",
					width = "full",
					get = function(info) return CommFlare.db.profile.alwaysAutoQueue end,
					set = function(info, value) CommFlare.db.profile.alwaysAutoQueue = value end,
				},
				communityAutoQueue = {
					type = "toggle",
					order = 2,
					name = "Automatically queue only if leader is SAS?",
					desc = "This will only automatically queue if your group leader is in SAS.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityAutoQueue end,
					set = function(info, value) CommFlare.db.profile.communityAutoQueue = value end,
				},
				autoqueue = {
					type = "group",
					order = 3,
					name = "Auto Queue Options",
					inline = true,
					args = {
						autoQueueRandomEpicBgs = {
							type = "toggle",
							order = 1,
							name = "Random Epic Battlegrounds?",
							desc = "This allows automatic queues for Random Epic Battlegrounds.",
							width = "full",
							get = function(info) return CommFlare.db.profile.autoQueueRandomEpicBgs end,
							set = function(info, value) CommFlare.db.profile.autoQueueRandomEpicBgs = value end,
						},
						autoQueueRandomBgs = {
							type = "toggle",
							order = 2,
							name = "Random Battlegrounds?",
							desc = "This allows automatic queues for Random Battlegrounds.",
							width = "full",
							get = function(info) return CommFlare.db.profile.autoQueueRandomBgs end,
							set = function(info, value) CommFlare.db.profile.autoQueueRandomBgs = value end,
						},
					},
				},
				communityReporter = {
					type = "toggle",
					order = 4,
					name = "Report queues to SAS? (Requires SAS channel to have /# assigned.)",
					desc = "This will provide a quick popup message for you to send your queue status to SAS community chat.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityReporter end,
					set = function(info, value) CommFlare.db.profile.communityReporter = value end,
				},
			},
		},
		invite = {
			type = "group",
			order = 2,
			name = "Invite Options",
			inline = true,
			args = {
				communityAutoInvite = {
					type = "toggle",
					order = 1,
					name = "Automatically accept invites from SAS members?",
					desc = "This will automatically accept group/party invites from SAS members.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityAutoInvite end,
					set = function(info, value) CommFlare.db.profile.communityAutoInvite = value end,
				},
				bnetAutoInvite = {
					type = "toggle",
					order = 2,
					name = "Automatically accept invites from Battle.NET members?",
					desc = "This will automatically accept group/party invites from Battle.NET members.",
					width = "full",
					get = function(info) return CommFlare.db.profile.bnetAutoInvite end,
					set = function(info, value) CommFlare.db.profile.bnetAutoInvite = value end,
				},
			}
		},
		battleground = {
			type = "group",
			order = 3,
			name = "Battleground Options",
			inline = true,
			args = {
				communityAutoPromoteLeader = {
					type = "toggle",
					order = 1,
					name = "Auto promote leaders in SAS? (Requires Raid Leader status.)",
					desc = "This will automatically pass leadership from you to a recognized SAS community leader.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityAutoPromoteLeader end,
					set = function(info, value) CommFlare.db.profile.communityAutoPromoteLeader = value end,
				},
				communityAutoAssist = {
					type = "select",
					order = 2,
					name = "Auto assist community members?",
					desc = "Automatically promotes community members to Raid Assist in matches.",
					values = {
						["1"] = "None",
						["2"] = "Leaders Only",
						["3"] = "All SAS Members",
					},
					get = function(info) return CommFlare.db.profile.communityAutoAssist end,
					set = function(info, value) CommFlare.db.profile.communityAutoAssist = value end,
				},
			},
		},
	},
}

-- initialize CF
local CF = {
	-- strings
	CommName = "Savage Alliance Slayers",
	PlayerServerName = "",

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
	MatchStartTime = 0,
	MatchStatus = 0,
	NumScores = 0,
	PlayerRank = 0,
	Position = 0,
	SavedTime = 0,

	-- misc
	Category = nil,
	Field = nil,
	Header = nil,
	Leader = nil,
	Options = nil,
	PlayerList = nil,
	PopupMessage = nil,

	-- tables
	Clubs = {},
	ClubMembers = {},
	MapInfo = {},
	MemberInfo = {},
	POIInfo = {},
	ScoreInfo = {},
	StatusCheck = {},

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
	"Cincõ-BlackwaterRaiders",
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

-- global function (check if dragon riding available)
function IsDragonFlyable()
	local m = MapGetBestMapForUnit("player")
	if ((m >= 2022) and (m <= 2025) or (m == 2085) or (m == 2112)) then
		-- dragon flyable
		return true
	else
		-- not available
		return false
	end
end

-- load session variables
local function CommunityFlare_LoadSession()
	-- misc stuff
	CF.MatchStatus = CommFlare.db.profile.MatchStatus

	-- battleground specific data
	CF.ASH = CommFlare.db.profile.ASH or {}
	CF.AV = CommFlare.db.profile.AV or {}
	CF.IOC = CommFlare.db.profile.IOC or {}
	CF.WG = CommFlare.db.profile.WG or {}
end

-- save session variables
local function CommunityFlare_SaveSession()
	-- misc stuff
	CommFlare.db.profile.MatchStatus = CF.MatchStatus
	CommFlare.db.profile.SavedTime = time()

	-- currently in battleground?
	if (PvPIsBattleground() == true) then
		-- save any settings
		CommFlare.db.profile.ASH = CF.ASH or {}
		CommFlare.db.profile.AV = CF.AV or {}
		CommFlare.db.profile.IOC = CF.IOC or {}
		CommFlare.db.profile.WG = CF.WG or {}
	else
		-- reset settings
		CommFlare.db.profile.ASH = {}
		CommFlare.db.profile.AV = {}
		CommFlare.db.profile.IOC = {}
		CommFlare.db.profile.WG = {}
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
	if (CommFlare.db.profile.SASID and (CommFlare.db.profile.SASID > 0)) then
		return CommFlare.db.profile.SASID
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
		if (CommFlare.db.profile.SASID > 0) then
			local channelId = "Community:" .. CommFlare.db.profile.SASID .. ":1"
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
		CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SASID)
		for _,v in ipairs(CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SASID, v);
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

		-- search through club members
		CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SASID)
		for _,v in ipairs(CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SASID, v);
			if (mi ~= nil) then
				if (mi.name == player) then
					return name, realm
				end
			end
		end
	end
	return nil, nil
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
	CF.MapID = MapGetBestMapForUnit("player")
	if (not CF.MapID) then
		-- not found
		print("Map ID: Not Found")
		return
	end

	-- get map info
	print("MapID: ", CF.MapID)
	CF.MapInfo = MapGetMapInfo(CF.MapID)
	if (not CF.MapInfo) then
		-- not found
		print("Map Info: Not Found")
		return
	end

	-- process any POI's
	print("Map Name: ", CF.MapInfo.name)
	local pois = AreaPoiInfoGetAreaPOIForMap(CF.MapID)
	if (pois and (#pois > 0)) then
		-- display infos
		print("Count: ", #pois)
		for _,v in ipairs(pois) do
			CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CF.MapID, v)
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

	-- solo atm
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
	-- is player full name in raid?
	if (UnitInRaid(player) ~= nil) then
		PromoteToLeader(player)
		return true
	end

	-- try using short name
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
		CF.ScoreInfo = PvPGetScoreInfo(i)
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
		CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SASID)
		for _,v in ipairs(CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SASID, v);
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
						if (CommFlare.db.profile.communityAutoAssist == "2") then
							if (CommunityFlare_IsSASLeader(mi.name) == true) then
								CF.AutoPromote = true
							end
						elseif (CommFlare.db.profile.communityAutoAssist == "3") then
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
			if (CommFlare.db.profile.communityReporter == true) then
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
	hooksecurefunc("PVPReadyDialog_OnHide", CommunityFlare_PVPReadyDialog_OnHide)
	PVPReadyDialogEnterBattleButton:HookScript("OnClick", CommunityFlare_PVPReadyDialogEnterBattleButton_OnClick)

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
	CF.MatchStartTime = 0

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
	CF.MapID = MapGetBestMapForUnit("player")
	if (not CF.MapID) then
		-- failed
		return false
	end

	-- get map info
	CF.MapInfo = MapGetMapInfo(CF.MapID)
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
			CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CF.MapID, CF.AV.Bunkers[i].id)
			if (CF.POIInfo) then
				CF.AV.Bunkers[i].status = "Destroyed"
				CF.AV.Counts.Bunkers = CF.AV.Counts.Bunkers - 1
			end
		end

		-- process towers
		for i,v in ipairs(CF.AV.Towers) do
			CF.AV.Towers[i].status = "Up"
			CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CF.MapID, CF.AV.Towers[i].id)
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
		CF.IOC.Counts = { Alliance = 0, Horde = 0 }
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
			CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CF.MapID, CF.IOC.AllianceGates[i].id)
			if (CF.POIInfo) then
				CF.IOC.AllianceGates[i].status = "Destroyed"
				CF.IOC.Counts.Alliance = CF.IOC.Counts.Alliance + 1
			end
		end

		-- process horde gates
		for i,v in ipairs(CF.IOC.HordeGates) do
			CF.IOC.HordeGates[i].status = "Up"
			CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CF.MapID, CF.IOC.HordeGates[i].id)
			if (CF.POIInfo) then
				CF.IOC.HordeGates[i].status = "Destroyed"
				CF.IOC.Counts.Horde = CF.IOC.Counts.Horde + 1
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
			CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CF.MapID, CF.WG.Towers[i].id)
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
			CF.ASH.Jeron = CommFlare.db.profile.ASH.Jeron
			CF.ASH.Rylai = CommFlare.db.profile.ASH.Rylai
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
		CF.MapInfo = MapGetMapInfo(CF.MapID)
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
	if (PvPIsBattleground() == true) then
		-- update battleground status
		if (CommunityFlare_Update_Battleground_Status() == true) then
			-- has match started yet?
			if (PvPGetActiveMatchDuration() > 0) then
				-- calculate time elapsed
				CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
				CF.Timer.Seconds = math.floor(CF.Timer.MilliSeconds / 1000)
				CF.Timer.Minutes = math.floor(CF.Timer.Seconds / 60)
				CF.Timer.Seconds = CF.Timer.Seconds - (CF.Timer.Minutes * 60)

				-- alterac valley or korrak's revenge?
				if ((CF.MapID == 91) or (CF.MapID == 1537)) then
					-- reply to sender with alterac valley status
					CommunityFlare_SendMessage(sender, strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Horde = %s; Bunkers Left = %d/4; Towers Left = %d/4", CF.MapInfo.name, CF.Timer.Minutes, CF.Timer.Seconds, CF.AV.Scores.Alliance, CF.AV.Scores.Horde, CF.AV.Counts.Bunkers, CF.AV.Counts.Towers))
				-- isle of conquest?
				elseif (CF.MapID == 169) then
					-- reply to sender with isle of conquest status
					CommunityFlare_SendMessage(sender, strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Gates Destroyed: %d/3; Horde = %s; Gates Destroyed: %d/3", CF.MapInfo.name, CF.Timer.Minutes, CF.Timer.Seconds, CF.IOC.Scores.Alliance, CF.IOC.Counts.Alliance, CF.IOC.Scores.Horde, CF.IOC.Counts.Horde))
				-- battle for wintergrasp?
				elseif (CF.MapID == 1334) then
					-- reply to sender with wintergrasp status
					CommunityFlare_SendMessage(sender, strformat("%s: %s; Time Elapsed = %d minutes, %d seconds; Towers Destroyed: %d/3", CF.MapInfo.name, CF.WG.TimeRemaining, CF.Timer.Minutes, CF.Timer.Seconds, CF.WG.Counts.Towers))
				-- ashran?
				elseif (CF.MapID == 1478) then
					-- reply to sender with ashran status
					CommunityFlare_SendMessage(sender, strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Horde = %s; Jeron = %s; Rylai = %s", CF.MapInfo.name, CF.Timer.Minutes, CF.Timer.Seconds, CF.ASH.Scores.Alliance, CF.ASH.Scores.Horde, CF.ASH.Jeron, CF.ASH.Rylai))
				end
			else
				-- reply to sender with map name, gates not opened yet
				CommunityFlare_SendMessage(sender, strformat("%s: Just entered match. Gates not opened yet!", CF.MapInfo.name))
			end
		else
			-- reply to sender, not epic battleground
			CommunityFlare_SendMessage(sender, strformat("%s: Not an Epic Battleground to track.", CF.MapInfo.name))
		end

		-- add to table for later
		CF.StatusCheck[sender] = time()
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
					return
				end
			end
		end

		-- not reported
		CommunityFlare_SendMessage(sender, "Not currently in an Epic Battleground or queue!")
	end
end

-- report joined with estimated time
local function CommunityFlare_Report_Joined_With_Estimated_Time()
	-- check if currently in queue
	for i=1, GetMaxBattlefieldID() do
		local status, mapName = GetBattlefieldStatus(i)
		if (mapName == "Random Epic Battleground") then
			-- get estimated time
			CF.Timer.MilliSeconds = GetBattlefieldEstimatedWaitTime(i)
			if (CF.Timer.MilliSeconds > 0) then
				-- calculate minutes / seconds
				CF.Timer.Seconds = math.floor(CF.Timer.MilliSeconds / 1000)
				CF.Timer.Minutes = math.floor(CF.Timer.Seconds / 60)
				CF.Timer.Seconds = CF.Timer.Seconds - (CF.Timer.Minutes * 60)

				-- does the player have the mercenary buff?
				local text = ""
				CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
				if (CF.HasAura == true) then
					-- build text for mercenary queue
					text = CommunityFlare_GetGroupCount() .. " Joined Mercenary Queue! Estimated Wait: " .. CF.Timer.Minutes .. " minutes, " .. CF.Timer.Seconds .. " seconds!"
				else
					-- build text for normal epic battleground queue
					text = CommunityFlare_GetGroupCount() .. " Joined Queue! Estimated Wait: " .. CF.Timer.Minutes .. " minutes, " .. CF.Timer.Seconds .. " seconds!"
				end

				-- check if group has room for more
				if (CF.Count < 5) then
					-- community auto invite enabled?
					if (CommFlare.db.profile.communityAutoInvite == true) then
						-- update text
						text = text .. " (For auto invite, whisper me INV)"
					end
				end

				-- send?
				CommunityFlare_PopupBox(text)
			else
				-- try again
				TimerAfter(0.2, CommunityFlare_Report_Joined_With_Estimated_Time)
			end
		end
	end
end

-- handle chat party message events
local function CommunityFlare_Event_Chat_Message_Party(...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- skip messages from yourself
	text = strlower(text)
	if (CommunityFlare_GetPlayerName("full") ~= sender) then
		if (text == "!cf") then
			-- send community flare version number
			CommunityFlare_SendMessage(nil, strformat("Community Flare: %s", CommunityFlare_Version))
		end
	end
end

--------------------------
-- Ace3 Code Below
--------------------------

-- process slash command
function CommFlare:Community_Flare_SlashCommand(input)
	-- force input to lowercase
	input = strlower(input)
	if (input == "pois") then
		-- list all POI's
		CommunityFlare_List_POIs()
	elseif (input == "sasid") then
		-- get proper sas community id
		CommFlare.db.profile.SASID = CommunityFlare_FindClubIDByName(CF.CommName)
		print("SASID: ", CommFlare.db.profile.SASID)
	elseif (input == "status") then
		-- get current status
		CommunityFlare_Get_Current_Status()
	elseif (input == "usage") then
		-- display usages
		print("CPU Usage: ", GetAddOnCPUUsage("Community_Flare"))
		print("Memory Usage: ", GetAddOnMemoryUsage("Community_Flare"))
	else
		-- display full battleground setup
		CommunityFlare_Battleground_Setup("full")
	end
end

-- process chat battle net whisper
function CommFlare:CHAT_MSG_BN_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- version check?
	text = strlower(text)
	if (text == "!cf") then
		-- send community flare version number
		CommunityFlare_SendMessage(bnSenderID, strformat("Community Flare: %s", CommunityFlare_Version))
	-- status check?
	elseif (text == "!status") then
		-- process status check
		CommunityFlare_Process_Status_Check(bnSenderID)
	-- asking for invite?
	elseif ((text == "inv") or (text == "invite")) then
		-- battle net auto invite enabled?
		if (CommFlare.db.profile.bnetAutoInvite == true) then
			if (CommunityFlare_IsInBattleground() == true) then
				CommunityFlare_SendMessage(bnSenderID, "Sorry, currently in Battleground now.")
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
									CommunityFlare_SendMessage(bnSenderID, "Sorry, group is currently full.")
								else
									BNInviteFriend(gameAccountInfo.gameAccountID)
								end
							end
							break
						end
					end
				end
			end
		else
			-- auto invite not enabled
			CommunityFlare_SendMessage(bnSenderID, "Sorry, Battle.Net auto invite not enabled.")
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

	-- everyone is ready?
	text = strlower(text)
	if (text:find("everyone is ready")) then
		-- community reporter enabled?
		if (CommFlare.db.profile.communityReporter == true) then
			-- currently out of queue?
			if (CF.QueueJoined == false) then
				if (CommunityFlare_IsGroupLeader() == true) then
					-- check if group has room for more
					text = CommunityFlare_GetGroupCount() .. " Ready!"
					if (CF.Count < 5) then
						-- community auto invite enabled?
						if (CommFlare.db.profile.communityAutoInvite == true) then
							-- update text
							text = text .. " (For auto invite, whisper me INV)"
						end
					end

					-- send?
					CommunityFlare_PopupBox(text)
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
		if (CommFlare.db.profile.communityAutoPromoteLeader == true) then
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
			if (CommFlare.db.profile.communityReporter == true) then
				-- currently out of queue?
				if (CF.QueueJoined == false) then
					if (CommunityFlare_IsGroupLeader() == true) then
						-- report joined queue with estimated time
						CommunityFlare_Report_Joined_With_Estimated_Time()
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
		CF.MatchStartTime = time()
		CommunityFlare_Battleground_Setup(type)
	-- you are no longer queued?
	elseif (text:find("you are no longer queued")) then
		-- community reporter enabled?
		if (CommFlare.db.profile.communityReporter == true) then
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

-- process chat whisper message
function CommFlare:CHAT_MSG_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- version check?
	text = strlower(text)
	if (text == "!cf") then
		-- send community flare version number
		CommunityFlare_SendMessage(sender, strformat("Community Flare: %s", CommunityFlare_Version))
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
		if (CommFlare.db.profile.communityAutoInvite == true) then
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
		else
			-- auto invite not enabled
			CommunityFlare_SendMessage(sender, "Sorry, community auto invite not enabled.")
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
		CF.ASH.Jeron = "Killed"
	-- Ashran, rylai killed?
	elseif (text:find("rylai crestfall has been slain")) then
		-- rylai crestfall killed
		CF.ASH.Rylai = "Killed"
	end
end

-- process club member added
function CommFlare:CLUB_MEMBER_ADDED(msg, ...)
	local clubId, memberId = ...

	-- sas community?
	if (CommFlare.db.profile.SASID == clubId) then
		-- get member info
		CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)
		if (CF.MemberInfo ~= nil) then
			-- name not found?
			if (not CF.MemberInfo.name) then
				-- try again, 2 seconds later
				TimerAfter(2, function()
					-- get member info
					CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)

					-- name not found?
					if ((CF.MemberInfo ~= nil) and (CF.MemberInfo.name ~= nil)) then
						-- display / update
						print(strformat("SAS Member Added: %s (%d, %d)", CF.MemberInfo.name, clubId, memberId))
					else
						-- failed
						print("CLUB_MEMBER_ADDED: name still not found.")
					end
				end)
			else
				-- display
				print(strformat("SAS Member Added: %s (%d, %d)", CF.MemberInfo.name, clubId, memberId))
			end
		end
	end
end

-- process club member removed
function CommFlare:CLUB_MEMBER_REMOVED(msg, ...)
	local clubId, memberId = ...

	-- sas community?
	if (CommFlare.db.profile.SASID == clubId) then
		-- get member info
		CF.MemberInfo = ClubGetMemberInfo(clubId, memberId);
		if (CF.MemberInfo ~= nil) then
			-- found member name?
			if (CF.MemberInfo.name ~= nil) then
				-- display
				print(strformat("SAS Member Removed: %s (%d, %d)", CF.MemberInfo.name, clubId, memberId))
			else
				-- debug
				DevTools_Dump(CF.MemberInfo)
			end
		end
	end
end

-- process group invite confirmation
function CommFlare:GROUP_INVITE_CONFIRMATION(msg)
	-- has text?
	local text = StaticPopup1Text["text_arg1"]
	if (text and (text ~= "")) then
		-- you will be removed from random epic battleground?
		text = strlower(text)
		if (strfind(text, "you will be removed from") and strfind(text, "random epic battleground")) then
			if (StaticPopup1:IsShown()) then
				StaticPopup1Button2:Click()
			end
		end
	end
end

-- process lfg role check show
function CommFlare:LFG_ROLE_CHECK_SHOW(msg, ...)
	local isRequeue = ...
	local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate();

	-- is battleground queue?
	if (bgQueue) then
		-- verify auto queue enabled for queue type
		CF.AutoQueueable = false
		local queueName = GetLFGRoleUpdateBattlegroundInfo()
		if (queueName == "Random Epic Battleground") then
			-- auto queue option enabled?
			if (CommFlare.db.profile.autoQueueRandomEpicBgs == true) then
				-- wants to auto queue
				CF.AutoQueueable = true
			end
		elseif (queueName == "Random Battleground") then
			-- auto queue option enabled?
			if (CommFlare.db.profile.autoQueueRandomBgs == true) then
				-- wants to auto queue
				CF.AutoQueueable = true
			end
		end

		-- is auto queue allowed?
		if (CF.AutoQueueable == true) then
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
				if (CommFlare.db.profile.alwaysAutoQueue == true) then
					CF.AutoQueue = true
				-- community auto queue?
				elseif (CommFlare.db.profile.communityAutoQueue == true) then
					local player = CommunityFlare_FindClubMemberByName(CommunityFlare_GetPartyLeader())
					if (player ~= nil) then
						CF.AutoQueue = true
					end
				end
			end

			-- auto queue enabled?
			if (CF.AutoQueue == true) then
				-- check for deserter
				CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
				if (CF.HasAura == false) then
					-- auto queue up
					CF.QueueJoined = true
					CF.QueuePopped = false

					-- is shown?
					if (LFDRoleCheckPopupAcceptButton:IsShown()) then
						-- click auto accept
						LFDRoleCheckPopupAcceptButton:Click()
					end
				else
					-- have deserter / leave party
					CommunityFlare_SendMessage(nil, "Sorry, I currently have Deserter! Leaving party to avoid interrupting the queue!")
					PartyInfoLeaveParty()
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
	CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
	if (CF.HasAura == false) then
		-- community auto invite enabled?
		if (CommFlare.db.profile.communityAutoInvite == true) then
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

-- process player entering world
function CommFlare:PLAYER_ENTERING_WORLD(msg, ...)
	local isInitialLogin, isReloadingUi = ...
	if ((isInitialLogin) or (isReloadingUi)) then
		-- display version
		print("Community Flare: ", CommunityFlare_Version)
		TimerAfter(2, function()
			-- get proper sas community id
			CommFlare.db.profile.SASID = CommunityFlare_FindClubIDByName(CF.CommName)
		end)

		-- reloading?
		if (isReloadingUi) then
			-- reloaded
			CF.Reloaded = true

			-- load previous session
			CommunityFlare_LoadSession()

			-- inside battleground?
			CF.MatchStatus = 0
			if (PvPIsBattleground() == true) then
				-- reset joined / popped
				CF.QueueJoined = false
				CF.QueuePopped = false

				-- match state is active?
				if (PvPGetActiveMatchState() == Enum.PvPMatchState.Active) then
					-- match is active state?
					CF.MatchStatus = 1
					if (PvPGetActiveMatchDuration() > 0) then
						-- match started
						CF.MatchStatus = 2
					end
				end
			end
		end
	end
end

-- process player login
function CommFlare:PLAYER_LOGIN(msg)
	-- event hooks not enabled yet?
	if (CF.EventHandlerLoaded == false) then
		-- process queue stuff
		CommunityFlare_ProcessQueues()
		CF.EventHandlerLoaded = true
	end
end

-- process player logout
function CommFlare:PLAYER_LOGOUT(msg)
	-- save session variables
	CommunityFlare_SaveSession()
end

-- process pvp match active
function CommFlare:PVP_MATCH_ACTIVE(msg)
	-- ASH exists?
	if (not CF.ASH) then
		-- create base
		CF.ASH = {}
	end

	-- always reset ashran mages
	CF.ASH.Jeron = "Up"
	CF.ASH.Rylai = "Up"

	-- active status
	CF.MatchStatus = 1
end

-- process pvp match complete
function CommFlare:PVP_MATCH_COMPLETE(msg, ...)
	local winner, duration = ...

	-- update battleground status
	CF.MatchStatus = 3
	CommunityFlare_Update_Battleground_Status()

	-- report to anyone?
	if (CF.StatusCheck) then
		-- process all
		local timer = 0.0
		for k,v in pairs(CF.StatusCheck) do
			-- send replies staggered
			TimerAfter(timer, function()
				-- battleground finished
				CommunityFlare_SendMessage(k, "Epic Battleground has finished!")
			end)

			-- next
			timer = timer + 0.2
		end
	end

	-- clear
	CF.StatusCheck = {}
end

-- process pvp match inactive
function CommFlare:PVP_MATCH_INACTIVE(msg)
	-- reset battleground status
	CF.MatchStatus = 0
	CommunityFlare_Reset_Battleground_Status()
end

-- process ready check
function CommFlare:READY_CHECK(msg, ...)
	local sender, timeleft = ...

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
		if (CommFlare.db.profile.alwaysAutoQueue == true) then
			CF.AutoQueue = true
		-- community auto queue?
		elseif (CommFlare.db.profile.communityAutoQueue == true) then
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

-- process ui info message
function CommFlare:UI_INFO_MESSAGE(msg, ...)
	local type, text = ...

	-- someone has deserter?
	text = strlower(text)
	if (text:find("deserter")) then
		print("Someone has Deserter debuff!")
	end
end

-- process update battlefield status
function CommFlare:UPDATE_BATTLEFIELD_STATUS(msg, ...)
	local index = ...

	-- confirm?
	local status, mapName = GetBattlefieldStatus(index)
	if (status == "confirm") then
		-- process random epic battlegrounds only
		if (mapName == "Random Epic Battleground") then
			local expiration = GetBattlefieldPortExpiration(index)
			if (expiration > 0) then
				-- community reporter enabled?
				if (CommFlare.db.profile.communityReporter == true) then
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
end

-- enabled
function CommFlare:OnEnable()
	-- register events
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CLUB_MEMBER_ADDED")
	self:RegisterEvent("CLUB_MEMBER_REMOVED")
	self:RegisterEvent("GROUP_INVITE_CONFIRMATION")
	self:RegisterEvent("LFG_ROLE_CHECK_SHOW")
	self:RegisterEvent("NOTIFY_PVP_AFK_RESULT")
	self:RegisterEvent("PARTY_INVITE_REQUEST")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PVP_MATCH_ACTIVE")
	self:RegisterEvent("PVP_MATCH_COMPLETE")
	self:RegisterEvent("PVP_MATCH_INACTIVE")
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- disabled
function CommFlare:OnDisable()
	-- unregister events
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
	self:UnregisterEvent("CHAT_MSG_PARTY")
	self:UnregisterEvent("CHAT_MSG_PARTY_LEADER")
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	self:UnregisterEvent("CLUB_MEMBER_ADDED")
	self:UnregisterEvent("CLUB_MEMBER_REMOVED")
	self:UnregisterEvent("GROUP_INVITE_CONFIRMATION")
	self:UnregisterEvent("LFG_ROLE_CHECK_SHOW")
	self:UnregisterEvent("NOTIFY_PVP_AFK_RESULT")
	self:UnregisterEvent("PARTY_INVITE_REQUEST")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("PLAYER_LOGIN")
	self:UnregisterEvent("PLAYER_LOGOUT")
	self:UnregisterEvent("PVP_MATCH_ACTIVE")
	self:UnregisterEvent("PVP_MATCH_COMPLETE")
	self:UnregisterEvent("PVP_MATCH_INACTIVE")
	self:UnregisterEvent("READY_CHECK")
	self:UnregisterEvent("UI_INFO_MESSAGE")
	self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- refresh config
function CommFlare:RefreshConfig()
	-- always verify SASID
	CommFlare.db.profile.SASID = 0
	CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(CF.Clubs) do
		if (v.name == CF.CommName) then
			CommFlare.db.profile.SASID = v.clubId
		end
	end
	print("SASID: ", CommunityFlare_FindClubIDByName(CF.CommName))
end

-- initialize
function CommFlare:OnInitialize()
	-- setup options stuff
	self.db = LibStub("AceDB-3.0"):New("CommunityFlareDB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	AC:RegisterOptionsTable("CommFlare_Options", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CommFlare_Options", "Community Flare")

	-- setup profile stuff
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AC:RegisterOptionsTable("CommFlare_Profiles", profiles)
	ACD:AddToBlizOptions("CommFlare_Profiles", "Profiles", "Community Flare")
end

-- register slash command
CommFlare:RegisterChatCommand("comf", "Community_Flare_SlashCommand")
