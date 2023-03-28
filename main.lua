-- initialize ACE3
CommFlare = LibStub("AceAddon-3.0"):NewAddon("Community Flare", "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

-- localize stuff
local _G                                        = _G
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNInviteFriend                            = _G.BNInviteFriend
local BNRequestInviteFriend                     = _G.BNRequestInviteFriend
local BNSendWhisper                             = _G.BNSendWhisper
local CopyTable                                 = _G.CopyTable
local CreateFrame                               = _G.CreateFrame
local DeclineQuest                              = _G.DeclineQuest
local DevTools_Dump                             = _G.DevTools_Dump
local GetAddOnCPUUsage                          = _G.GetAddOnCPUUsage
local GetAddOnMemoryUsage                       = _G.GetAddOnMemoryUsage
local GetAddOnMetadata                          = _G.GetAddOnMetadata
local GetBattlefieldEstimatedWaitTime           = _G.GetBattlefieldEstimatedWaitTime
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetBattlefieldWinner                      = _G.GetBattlefieldWinner
local GetChannelName                            = _G.GetChannelName
local GetDisplayedInviteType                    = _G.GetDisplayedInviteType
local GetHomePartyInfo                          = _G.GetHomePartyInfo
local GetInviteConfirmationInfo                 = _G.GetInviteConfirmationInfo
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNextPendingInviteConfirmation          = _G.GetNextPendingInviteConfirmation
local GetNumBattlefieldScores                   = _G.GetNumBattlefieldScores
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local GetPlayerInfoByGUID                       = _G.GetPlayerInfoByGUID
local GetQuestID                                = _G.GetQuestID
local GetRaidRosterInfo                         = _G.GetRaidRosterInfo
local GetRealmName                              = _G.GetRealmName
local IsAddOnLoaded                             = _G.IsAddOnLoaded
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToAssistant                        = _G.PromoteToAssistant
local PromoteToLeader                           = _G.PromoteToLeader
local RespondToInviteConfirmation               = _G.RespondToInviteConfirmation
local SendChatMessage                           = _G.SendChatMessage
local SocialQueueUtil_GetRelationshipInfo       = _G.SocialQueueUtil_GetRelationshipInfo
local StaticPopupDialogs                        = _G.StaticPopupDialogs
local StaticPopup_FindVisible                   = _G.StaticPopup_FindVisible
local StaticPopup_Hide                          = _G.StaticPopup_Hide
local StaticPopup_Show                          = _G.StaticPopup_Show
local StaticPopup1                              = _G.StaticPopup1
local StaticPopup1Text                          = _G.StaticPopup1Text
local UninviteUnit                              = _G.UninviteUnit
local UnitFullName                              = _G.UnitFullName
local UnitGUID                                  = _G.UnitGUID
local UnitInRaid                                = _G.UnitInRaid
local UnitIsConnected                           = _G.UnitIsConnected
local UnitIsDeadOrGhost                         = _G.UnitIsDeadOrGhost
local UnitIsGroupLeader                         = _G.UnitIsGroupLeader
local UnitName                                  = _G.UnitName
local UnitRealmRelationship                     = _G.UnitRealmRelationship
local AuraUtilForEachAura                       = _G.AuraUtil.ForEachAura
local AreaPoiInfoGetAreaPOIForMap               = _G.C_AreaPoiInfo.GetAreaPOIForMap
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetAccountInfoByGUID             = _G.C_BattleNet.GetAccountInfoByGUID
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local ChatInfoRegisterAddonMessagePrefix        = _G.C_ChatInfo.RegisterAddonMessagePrefix
local ChatInfoSendAddonMessage                  = _G.C_ChatInfo.SendAddonMessage
local ClubGetClubMembers                        = _G.C_Club.GetClubMembers
local ClubGetMemberInfo                         = _G.C_Club.GetMemberInfo
local ClubGetSubscribedClubs                    = _G.C_Club.GetSubscribedClubs
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PartyInfoGetInviteReferralInfo            = _G.C_PartyInfo.GetInviteReferralInfo
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
local strfind                                   = _G.string.find
local strformat                                 = _G.string.format
local strgsub                                   = _G.string.gsub
local strlen                                    = _G.string.len
local strlower                                  = _G.string.lower
local strmatch                                  = _G.string.match
local strsplit                                  = _G.string.split
local time                                      = _G.time
local tinsert                                   = _G.table.insert
local tsort                                     = _G.table.sort
local type                                      = _G.type
local wipe                                      = _G.wipe

-- get current version
local CommunityFlare_Title = GetAddOnMetadata("Community_Flare", "Title") or "unspecified"
local CommunityFlare_Version = GetAddOnMetadata("Community_Flare", "Version") or "unspecified"

-- defaults
local defaults = {
	profile = {
		-- variables
		SASID = 0,
		SAS_ALTS_ID = 0,
		MatchStatus = 0,
		SavedTime = 0,

		-- profile only options
		alwaysAutoQueue = false,
		autoQueueBrawls = false,
		autoQueueRandomBgs = false,
		autoQueueRandomEpicBgs = true,
		blockSharedQuests = "1",
		bnetAutoInvite = false,
		communityAutoAssist = "2",
		communityAutoInvite = true,
		communityAutoPromoteLeader = true,
		communityAutoQueue = true,
		communityReporter = true,
		reportQueueBrawls = false,
		reportQueueRandomBgs = false,
		reportQueueRandomEpicBgs = true,
		uninvitePlayersAFK = "0",

		-- tables
		ASH = {},
		AV = {},
		IOC = {},
		WG = {},
	},
}

-- options
local options = {
	name = CommunityFlare_Title .. " " .. CommunityFlare_Version,
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
						autoQueueBrawls = {
							type = "toggle",
							order = 3,
							name = "Brawls?",
							desc = "This allows automatic queues for Brawls.",
							width = "full",
							get = function(info) return CommFlare.db.profile.autoQueueBrawls end,
							set = function(info, value) CommFlare.db.profile.autoQueueBrawls = value end,
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
				reportqueue = {
					type = "group",
					order = 5,
					name = "Report Queue Options",
					args = {
						reportQueueRandomEpicBgs = {
							type = "toggle",
							order = 1,
							name = "Random Epic Battlegrounds?",
							desc = "This allows reporting queues to SAS for Random Epic Battlegrounds.",
							width = "full",
							get = function(info) return CommFlare.db.profile.reportQueueRandomEpicBgs end,
							set = function(info, value) CommFlare.db.profile.reportQueueRandomEpicBgs = value end,
						},
						reportQueueRandomBgs = {
							type = "toggle",
							order = 2,
							name = "Random Battlegrounds?",
							desc = "This allows reporting queues to SAS for Random Battlegrounds.",
							width = "full",
							get = function(info) return CommFlare.db.profile.reportQueueRandomBgs end,
							set = function(info, value) CommFlare.db.profile.reportQueueRandomBgs = value end,
						},
						reportQueueBrawls = {
							type = "toggle",
							order = 3,
							name = "Brawls?",
							desc = "This allows reporting queues to SAS for Brawls.",
							width = "full",
							get = function(info) return CommFlare.db.profile.reportQueueBrawls end,
							set = function(info, value) CommFlare.db.profile.reportQueueBrawls = value end,
						},
					},
				},
				uninvitePlayersAFK = {
					type = "select",
					order = 6,
					name = "Uninvite any players that are AFK?",
					desc = "Pops up a box to uninvite any users that are AFK at the time of queuing.",
					values = {
						["0"] = "Disabled",
						["3"] = "3 Seconds",
						["4"] = "4 Seconds",
						["5"] = "5 Seconds",
						["6"] = "6 Seconds",
					},
					get = function(info) return CommFlare.db.profile.uninvitePlayersAFK end,
					set = function(info, value) CommFlare.db.profile.uninvitePlayersAFK = value end,
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
				communityAutoAssist = {
					type = "select",
					order = 1,
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
				communityAutoPromoteLeader = {
					type = "toggle",
					order = 2,
					name = "Auto promote leaders in SAS? (Requires Raid Leader status.)",
					desc = "This will automatically pass leadership from you to a recognized SAS community leader.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityAutoPromoteLeader end,
					set = function(info, value) CommFlare.db.profile.communityAutoPromoteLeader = value end,
				},
				blockSharedQuests = {
					type = "select",
					order = 3,
					name = "Block shared quests?",
					desc = "Automatically blocks shared quests during a Battleground.",
					values = {
						["1"] = "None",
						["2"] = "Irrelevant",
						["3"] = "All",
					},
					get = function(info) return CommFlare.db.profile.blockSharedQuests end,
					set = function(info, value) CommFlare.db.profile.blockSharedQuests = value end,
				},
			},
		},
	},
}

-- initialize CF
CommFlare.CF = {
	-- strings
	AltsCommName = "Savage Alliance Slayers ALTS",
	MainCommName = "Savage Alliance Slayers",
	MapName = "",
	PlayerServerName = "",

	-- booleans
	AutoInvite = false,
	AutoPromote = false,
	AutoQueue = false,
	AutoQueueable = false,
	EventHandlerLoaded = false,
	HasAura = false,
	Reloaded = false,

	-- numbers
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
	PlayerList = nil,
	PopupMessage = nil,
	Winner = nil,

	-- tables
	Clubs = {},
	ClubMembers = {},
	CommNamesList = {},
	MapInfo = {},
	MemberInfo = {},
	MercNamesList = {},
	POIInfo = {},
	Queues = {},
	ReadyCheck = {},
	RoleChosen = {},
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
	"Revoker-Dentarg",
	"Shotdasherif-Dentarg",
	"Angelsong-BlackwaterRaiders",
	"Faeryna-BlackwaterRaiders",
	"Shanlie-CenarionCircle",
	"Kroog-CenarionCircle",
	"Leyoterk-CenarionCircle",
	"Krolak-Proudmoore",
	"Greenbeans-CenarionCircle"
}

-- epic battlegrounds
local epicBattlegrounds = {
	["Random Epic Battleground"] = 1,
	["Alterac Valley"] = 2,
	["Isle of Conquest"] = 3,
	["Battle for Wintergrasp"] = 4,
	["Ashran"] = 5,
}

-- random battlegrounds
local randomBattlegrounds = {
	["Random Battleground"] = 1,
	["Warsong Gulch"] = 2,
	["Arathi Basin"] = 3,
	["Eye of the Storm"] = 4,
	["The Battle for Gilneas"] = 5,
	["Twin Peaks"] = 6,
	["Silvershard Mines"] = 7,
	["Temple of Kotmogu"] = 8,
	["Seething Shore"] = 9,
	["Deepwind Gorge"] = 10,
}

-- brawls
local brawls = {
	["Brawl: Arathi Blizzard"] = 1,
	["Brawl: Classic Ashran"] = 2,
	["Brawl: Comp Stomp"] = 3,
	["Brawl: Cooking Impossible"] = 4,
	["Brawl: Deep Six"] = 5,
	["Brawl: Deepwind Dunk"] = 6,
	["Brawl: Gravity Lapse"] = 7,
	["Brawl: Packed House"] = 8,
	["Brawl: Shado-Pan Showdown"] = 9,
	["Brawl: Tarren Mill vs. Southshore"] = 10,
	["Brawl: Temple of Hotmogu"] = 11,
	["Brawl: Warsong Scramble"] = 12,
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

-- is epic battleground?
local function CommunityFlare_IsEpicBG(name)
	-- check from name
	if (epicBattlegrounds[name] and (epicBattlegrounds[name] > 0)) then
		-- yup
		return true
	end

	-- nope
	return false
end

-- get epic battleground id
local function CommunityFlare_GetEpicBGID(name)
	-- check from name
	if (epicBattlegrounds[name] and (epicBattlegrounds[name] > 0)) then
		-- return id
		return epicBattlegrounds[name]
	end

	-- invalid
	return 0
end

-- is random battleground?
local function CommunityFlare_IsRandomBG(name)
	-- check from name
	if (randomBattlegrounds[name] and (randomBattlegrounds[name] > 0)) then
		-- yup
		return true
	end

	-- nope
	return false
end

-- get random battleground id
local function CommunityFlare_GetRandomBGID(name)
	-- check from name
	if (randomBattlegrounds[name] and (randomBattlegrounds[name] > 0)) then
		-- return id
		return randomBattlegrounds[name]
	end

	-- invalid
	return 0
end

-- is brawl?
local function CommunityFlare_IsBrawl(name)
	-- check from name
	if (brawls[name] and (brawls[name] > 0)) then
		-- yup
		return true
	end

	-- nope
	return false
end

-- get brawl id
local function CommunityFlare_GetBrawlID(name)
	-- check from name
	if (brawls[name] and (brawls[name] > 0)) then
		-- return id
		return brawls[name]
	end

	-- invalid
	return 0
end

-- is tracked pvp?
local function CommunityFlare_IsTrackedPVP(name)
	-- check against tracked maps
	local isBrawl = CommunityFlare_IsBrawl(name)
	local isEpicBattleground = CommunityFlare_IsEpicBG(name)
	local isRandomBattleground = CommunityFlare_IsRandomBG(name)

	-- is epic or random battleground?
	if ((isEpicBattleground == true) or (isRandomBattleground == true) or (isBrawl == true)) then
		-- tracked
		return true, isEpicBattleground, isRandomBattleground, isBrawl
	end

	-- nope
	return false, nil, nil, nil
end

-- is mesostealthy?
local function CommunityFlare_IsMesostealthy(player)
	-- invalid player?
	if (not player or (player == "")) then
		-- nope
		return false
	end

	-- realm matches?
	local name, realm = strsplit("-", player, 2)
	if (realm == "Dentarg") then
		-- meso's characters
		if ((name == "Mesostealthy") or (name == "Lifestooport") or (name == "Revoker") or (name == "Shotdasherif")) then
			-- yup
			return true
		end
	end

	-- nope
	return false
end

-- load session variables
local function CommunityFlare_LoadSession()
	-- misc stuff
	CommFlare.db.global.members = CommFlare.db.global.members or {}
	CommFlare.CF.MatchStatus = CommFlare.db.profile.MatchStatus
	CommFlare.CF.Queues = CommFlare.db.profile.Queues or {}

	-- battleground specific data
	CommFlare.CF.ASH = CommFlare.db.profile.ASH or {}
	CommFlare.CF.AV = CommFlare.db.profile.AV or {}
	CommFlare.CF.IOC = CommFlare.db.profile.IOC or {}
	CommFlare.CF.WG = CommFlare.db.profile.WG or {}
end

-- save session variables
local function CommunityFlare_SaveSession()
	-- global created?
	if (not CommFlare.db.global) then
		CommFlare.db.global = {}
	end

	-- misc stuff
	CommFlare.db.global.members = CommFlare.db.global.members or {}
	CommFlare.db.profile.MatchStatus = CommFlare.CF.MatchStatus
	CommFlare.db.profile.Queues = CommFlare.CF.Queues or {}
	CommFlare.db.profile.SavedTime = time()

	-- currently in battleground?
	if (PvPIsBattleground() == true) then
		-- save any settings
		CommFlare.db.profile.ASH = CommFlare.CF.ASH or {}
		CommFlare.db.profile.AV = CommFlare.CF.AV or {}
		CommFlare.db.profile.IOC = CommFlare.CF.IOC or {}
		CommFlare.db.profile.WG = CommFlare.CF.WG or {}
	else
		-- reset settings
		CommFlare.db.profile.ASH = {}
		CommFlare.db.profile.AV = {}
		CommFlare.db.profile.IOC = {}
		CommFlare.db.profile.WG = {}
	end
end

-- add to members
local function CommunityFlare_AddMember(id, info)
	-- build proper name
	local player = info.name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	end

	-- add to members
	CommFlare.db.global.members[player] = {
		clubId = id,
		guid = info.guid,
		memberNote = info.memberNote,
		name = player,
	}
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

-- get club id
local function CommunityFlare_FindClubID(name)
	-- looking for main community?
	if (name == CommFlare.CF.MainCommName) then
		-- has SASID already?
		if (CommFlare.db.profile.SASID and (CommFlare.db.profile.SASID > 0)) then
			return CommFlare.db.profile.SASID
		end
	-- looking for alts community?
	elseif (name == CommFlare.CF.AltsCommName) then
		-- has SAS_ALTS_ID already?
		if (CommFlare.db.profile.SAS_ALTS_ID and (CommFlare.db.profile.SAS_ALTS_ID > 0)) then
			return CommFlare.db.profile.SAS_ALTS_ID
		end
	end

	-- proper name given?
	if ((name ~= nil) and (type(name) == "string")) then
		-- process all subscribed communities
		CommFlare.CF.Clubs = ClubGetSubscribedClubs()
		for _,v in ipairs(CommFlare.CF.Clubs) do
			if (v.name == name) then
				return v.clubId
			end
		end
	end

	-- failed
	return 0
end

-- process club members
local function CommunityFlare_Process_Club_Members()
	-- find main community members
	local clubId = CommunityFlare_FindClubID(CommFlare.CF.MainCommName)
	if (clubId > 0) then
		-- SASID not setup yet?
		if (not CommFlare.db.profile.SASID or (CommFlare.db.profile.SASID <= 0)) then
			-- save SASID
			CommFlare.db.profile.SASID = clubId
		end

		-- process all members
		local members = ClubGetClubMembers(clubId)
		for _,v in ipairs(members) do
			local mi = ClubGetMemberInfo(clubId, v)
			if ((mi ~= nil) and (mi.name ~= nil)) then
				-- add to members
				CommunityFlare_AddMember(clubId, mi)
			end
		end
	end

	-- find alt community members
	clubId = CommunityFlare_FindClubID(CommFlare.CF.AltsCommName)
	if (clubId > 0) then
		-- SAS_ALTS_ID not setup yet?
		if (not CommFlare.db.profile.SAS_ALTS_ID or (CommFlare.db.profile.SAS_ALTS_ID <= 0)) then
			-- save SASID
			CommFlare.db.profile.SAS_ALTS_ID = clubId
		end

		-- process all members
		local members = ClubGetClubMembers(clubId)
		for _,v in ipairs(members) do
			local mi = ClubGetMemberInfo(clubId, v)
			if ((mi ~= nil) and (mi.name ~= nil)) then
				-- add to members
				CommunityFlare_AddMember(clubId, mi)
			end
		end
	end
end

-- send community box setup
StaticPopupDialogs["CommunityFlare_Send_Community_Dialog"] = {
	text = "Send: %s?",
	button1 = "Send",
	button2 = "No",
	OnAccept = function(self, message)
		-- SAS member?
		local clubId = 0
		if (CommFlare.db.profile.SASID > 0) then
			clubId = CommFlare.db.profile.SASID
		elseif (CommFlare.db.profile.SAS_ALTS_ID > 0) then
			clubId = CommFlare.db.profile.SAS_ALTS_ID
		end

		-- club id found?
		if (clubId > 0) then
			local channelId = "Community:" .. clubId .. ":1"
			local id, name = GetChannelName(channelId)
			if ((id > 0) and (name ~= nil)) then
				-- send channel messsage (hardware click acquired)
				SendChatMessage(message, "CHANNEL", nil, id)
			end
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- kick box setup
StaticPopupDialogs["CommunityFlare_Kick_Dialog"] = {
	text = "Kick: %s?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, player)
		-- uninvite user
		print("Uninviting ...")
		UninviteUnit(player, "AFK")

		-- community auto invite enabled?
		local text = "You've been removed from the party for being AFK."
		if (CommFlare.db.profile.communityAutoInvite == true) then
			-- update text for info about being reinvited
			text = text .. " Whisper me INV and if a spot is still available, you'll be readded to the party."
		end

		-- send message
		CommunityFlare_SendMessage(player, text)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- popup box
local function CommunityFlare_PopupBox(dlg, message)
	-- requires community id?
	local showPopup = true
	if (dlg == "CommunityFlare_Send_Community_Dialog") then
		-- SAS member?
		local clubId = 0
		if (CommFlare.db.profile.SASID > 0) then
			clubId = CommFlare.db.profile.SASID
		elseif (CommFlare.db.profile.SAS_ALTS_ID > 0) then
			clubId = CommFlare.db.profile.SAS_ALTS_ID
		end

		-- found id?
		if (clubId <= 0) then
			-- hide
			showPopup = false
		end
	end

	-- show popup?
	if (showPopup == true) then
		-- popup box setup
		local popup = StaticPopupDialogs[dlg]

		-- show the popup box
		CommFlare.CF.PopupMessage = message
		local dialog = StaticPopup_Show(dlg, message)
		if (dialog) then
			dialog.data = CommFlare.CF.PopupMessage
		end

		-- restore popup
		StaticPopupDialogs[dlg] = popup
	end
end

-- is sas leader? (yes, intended to be global)
function CommunityFlare_IsSASLeader(name)
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
	CommFlare.CF.Count = 1
	if (IsInGroup()) then
		if (not IsInRaid()) then
			-- update count
			CommFlare.CF.Count = GetNumGroupMembers()
		end
	end

	-- return x/5 count
	return strformat("%d/5", CommFlare.CF.Count)
end

-- get group members
local function CommunityFlare_GetGroupMemembers()
	-- are you grouped?
	local players = {}
	if (IsInGroup()) then
		-- are you in a raid?
		if (not IsInRaid()) then
			-- process all group members
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
	-- can search main community?
	if (CommunityFlare_FindClubID(CommFlare.CF.MainCommName) > 0) then
		-- use short name for same realm as you
		local name, realm = strsplit("-", player, 2)
		if (realm == GetRealmName()) then
			player = name
		end

		-- search through club members
		CommFlare.CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SASID)
		for _,v in ipairs(CommFlare.CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SASID, v)
			if (mi ~= nil) then
				if (mi.name == player) then
					return player
				end
			end
		end
	end

	-- can search alts community?
	if (CommunityFlare_FindClubID(CommFlare.CF.AltsCommName) > 0) then
		-- use short name for same realm as you
		local name, realm = strsplit("-", player, 2)
		if (realm == GetRealmName()) then
			player = name
		end

		-- search through club members
		CommFlare.CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SAS_ALTS_ID)
		for _,v in ipairs(CommFlare.CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SAS_ALTS_ID, v)
			if (mi ~= nil) then
				if (mi.name == player) then
					return player
				end
			end
		end
	end

	-- failed
	return nil
end

-- find community member by guid
local function CommunityFlare_FindClubMemberByGUID(guid)
	-- invalid guid?
	local name, realm = select(6, GetPlayerInfoByGUID(guid))
	if (not name or (name == "")) then
		-- failed
		return nil, nil
	end

	-- has realm?
	if (realm and (realm ~= "")) then
		-- add realm name
		player = name .. "-" .. realm
	else
		-- copy name / same realm as you
		player = name
		realm = GetRealmName()
	end

	-- can search main community?
	if (CommunityFlare_FindClubID(CommFlare.CF.MainCommName) > 0) then
		-- search through club members
		CommFlare.CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SASID)
		for _,v in ipairs(CommFlare.CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SASID, v)
			if (mi ~= nil) then
				if (mi.name == player) then
					return name, realm
				end
			end
		end
	end

	-- can search alts community?
	if (CommunityFlare_FindClubID(CommFlare.CF.AltsCommName) > 0) then
		-- search through club members
		CommFlare.CF.ClubMembers = ClubGetClubMembers(CommFlare.db.profile.SAS_ALTS_ID)
		for _,v in ipairs(CommFlare.CF.ClubMembers) do
			local mi = ClubGetMemberInfo(CommFlare.db.profile.SAS_ALTS_ID, v)
			if (mi ~= nil) then
				if (mi.name == player) then
					return name, realm
				end
			end
		end
	end

	-- failed
	return nil, nil
end

-- is SAS member? (yes, intended to be global)
function CommunityFlare_IsSASMember(name)
	-- invalid name?
	if (not name or (name == "")) then
		-- failed
		return false
	end

	-- need full player-server name
	local isMember = false
	local player, realm = strsplit("-", name, 2)
	if (not realm or (realm == "")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	else
		-- copy name
		player = name
	end

	-- SAS/SAS ALT found?
	if (player and (player ~= "") and CommFlare.db.global.members[player]) then
		-- member found in database
		isMember = true
	else
		-- find SAS member
		player = CommunityFlare_FindClubMemberByName(name)
		if (player ~= nil) then
			-- member found in club
			isMember = true
		end
	end

	-- return status
	return isMember
end

-- find player by GUID
function CommunityFlare_FindSASMemberByGUID(guid)
	-- invalid guid?
	if (not guid or (guid == "")) then
		-- failed
		return nil
	end

	-- process all
	for k,v in pairs(CommFlare.db.global.members) do
		-- matches?
		if (v.guid == guid) then
			-- found
			return k
		end
	end

	-- failed
	return nil
end

-- check if a unit has type aura active
local function CommunityFlare_CheckForAura(unit, type, auraName)
	-- save global variable if aura is active
	CommFlare.CF.HasAura = false
	AuraUtilForEachAura(unit, type, nil, function(name, icon, ...)
		if (name == auraName) then
			CommFlare.CF.HasAura = true
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
		local status, mapName = GetBattlefieldStatus(i)
		if (status == "active") then
			-- in battle
			CommFlare.CF.MapName = mapName
			return true
		end
	end
	return false
end

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

-- get current party leader
local function CommunityFlare_GetPartyLeader()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then 
			local name, realm = UnitName("party" .. i)
			if (realm and (realm ~= "")) then
				-- add realm name
				name = name .. "-" .. realm
			end

			-- leader found
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
	CommFlare.CF.CommCount = 0
	CommFlare.CF.MercsCount = 0
	CommFlare.CF.Horde.Count = 0
	CommFlare.CF.Alliance.Count = 0
	CommFlare.CF.Horde.Tanks = 0
	CommFlare.CF.Horde.Healers = 0
	CommFlare.CF.Alliance.Tanks = 0
	CommFlare.CF.Alliance.Healers = 0

	-- any battlefield scores?
	CommFlare.CF.NumScores = GetNumBattlefieldScores()
	if (CommFlare.CF.NumScores == 0) then
		print("SAS: Not in Battleground yet")
		return
	end

	-- process all scores
	CommFlare.CF.MercList = nil
	CommFlare.CF.PlayerList = nil
	CommFlare.CF.CommNamesList = {}
	CommFlare.CF.MercNamesList = {}
	CommFlare.CF.PlayerRank = CommunityFlare_GetRaidRank(UnitName("player"))
	for i=1, CommFlare.CF.NumScores do
		CommFlare.CF.ScoreInfo = PvPGetScoreInfo(i)
		if (CommFlare.CF.ScoreInfo and CommFlare.CF.ScoreInfo.faction and CommFlare.CF.ScoreInfo.talentSpec) then
			-- is healer or tank?
			CommFlare.CF.IsTank = CommunityFlare_IsTank(CommFlare.CF.ScoreInfo.talentSpec)
			CommFlare.CF.IsHealer = CommunityFlare_IsHealer(CommFlare.CF.ScoreInfo.talentSpec)

			-- force name-realm format
			local player = CommFlare.CF.ScoreInfo.name
			if (not strmatch(player, "-")) then
				-- add realm name
				player = player .. "-" .. GetRealmName()
			end

			-- horde faction?
			if (CommFlare.CF.ScoreInfo.faction == 0) then
				-- SAS member?
				if (CommFlare.db.global.members[player]) then
					-- processing player list too?
					if (type == "full") then
						-- add to names
						tinsert(CommFlare.CF.CommNamesList, CommFlare.CF.ScoreInfo.name)
					end

					-- player has raid leader?
					if (CommFlare.CF.PlayerRank == 2) then
						CommFlare.CF.AutoPromote = false
						if (CommFlare.db.profile.communityAutoAssist == "2") then
							if (CommunityFlare_IsSASLeader(player) == true) then
								CommFlare.CF.AutoPromote = true
							end
						elseif (CommFlare.db.profile.communityAutoAssist == "3") then
							CommFlare.CF.AutoPromote = true
						end
						if (CommFlare.CF.AutoPromote == true) then
							PromoteToAssistant(CommFlare.CF.ScoreInfo.name)
						end
					end
				end

				-- increase horde counts
				CommFlare.CF.Horde.Count = CommFlare.CF.Horde.Count + 1
				if (CommFlare.CF.IsHealer == true) then
					CommFlare.CF.Horde.Healers = CommFlare.CF.Horde.Healers + 1
				elseif (CommFlare.CF.IsTank == true) then
					CommFlare.CF.Horde.Tanks = CommFlare.CF.Horde.Tanks + 1
				end
			else
				-- SAS member?
				if (CommFlare.db.global.members[player]) then
					-- processing player list too?
					if (type == "full") then
						-- add to names
						tinsert(CommFlare.CF.MercNamesList, CommFlare.CF.ScoreInfo.name)
					end
				end

				-- player has raid leader?
				if (CommFlare.CF.PlayerRank == 2) then
					CommFlare.CF.AutoPromote = false
					if (CommFlare.db.profile.communityAutoAssist == "2") then
						if (CommunityFlare_IsSASLeader(player) == true) then
							CommFlare.CF.AutoPromote = true
						end
					elseif (CommFlare.db.profile.communityAutoAssist == "3") then
						CommFlare.CF.AutoPromote = true
					end
					if (CommFlare.CF.AutoPromote == true) then
						PromoteToAssistant(CommFlare.CF.ScoreInfo.name)
					end
				end

				-- increase alliance counts
				CommFlare.CF.Alliance.Count = CommFlare.CF.Alliance.Count + 1
				if (CommFlare.CF.IsHealer == true) then
					CommFlare.CF.Alliance.Healers = CommFlare.CF.Alliance.Healers + 1
				elseif (CommFlare.CF.IsTank == true) then
					CommFlare.CF.Alliance.Tanks = CommFlare.CF.Alliance.Tanks + 1
				end
			end
		end
	end

	-- display faction results
	print(strformat("Horde: Healers = %d, Tanks = %d", CommFlare.CF.Horde.Healers, CommFlare.CF.Horde.Tanks))
	print(strformat("Alliance: Healers = %d, Tanks = %d", CommFlare.CF.Alliance.Healers, CommFlare.CF.Alliance.Tanks))

	-- has mercenaries?
	if (#CommFlare.CF.MercNamesList > 0) then
		-- sort mercenary names list
		tsort(CommFlare.CF.MercNamesList)

		-- build player list
		CommFlare.CF.MercsCount = 0
		for k,v in pairs(CommFlare.CF.MercNamesList) do
			-- list still empty? start it!
			if (CommFlare.CF.PlayerList == nil) then
				CommFlare.CF.MercList = v
			else
				CommFlare.CF.MercList = CommFlare.CF.MercList .. ", " .. v
			end

			-- next
			CommFlare.CF.MercsCount = CommFlare.CF.MercsCount + 1
		end

		-- found merc list?
		if (CommFlare.CF.MercList ~= nil) then
			print("SAS MERCS: ", CommFlare.CF.MercList)
		end
		print(strformat("Found: %d Mercs", CommFlare.CF.MercsCount))
	end

	-- has community players?
	if (#CommFlare.CF.CommNamesList > 0) then
		-- sort community players
		tsort(CommFlare.CF.CommNamesList)

		-- build player list
		CommFlare.CF.CommCount = 0
		for k,v in pairs(CommFlare.CF.CommNamesList) do
			-- list still empty? start it!
			if (CommFlare.CF.PlayerList == nil) then
				CommFlare.CF.PlayerList = v
			else
				CommFlare.CF.PlayerList = CommFlare.CF.PlayerList .. ", " .. v
			end

			-- next
			CommFlare.CF.CommCount = CommFlare.CF.CommCount + 1
		end

		-- found player list?
		if (CommFlare.CF.PlayerList ~= nil) then
			print("SAS: ", CommFlare.CF.PlayerList)
		end
		print(strformat("Found: %d", CommFlare.CF.CommCount))
	end
end

-- securely hook accept battlefield port
local function CommunityFlare_AcceptBattlefieldPort(index, acceptFlag)
	-- invalid index?
	if (not index or (index < 1) or (index > GetMaxBattlefieldID())) then
		-- finished
		return
	end

	-- get battleground types by name
	local status, mapName = GetBattlefieldStatus(index)
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

	-- is tracked pvp?
	if (isTracked == true) then
		-- leaving queue?
		if (acceptFlag == false) then
			-- community reporter enabled?
			local text = CommunityFlare_GetGroupCount()
			if (CommFlare.db.profile.communityReporter == true) then
				-- only report drops for group leaders
				if (CommunityFlare_IsGroupLeader() == true) then
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
						CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
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
					CommunityFlare_SendMessage(nil, text)
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
				print("Unit is dead: ", unit)
				print("Player: ", player)
				print("Realm: ", realm)
			end

			-- are they offline?
			if (UnitIsConnected(unit) ~= true) then
				-- kick them
				kickPlayer = true
				print("Unit is offline: ", unit)
				print("Player: ", player)
				print("Realm: ", realm)
			end

			-- should kick?
			if (kickPlayer == true) then
				-- ask to kick?
				CommunityFlare_PopupBox("CommunityFlare_Kick_Dialog", player)
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
					CommunityFlare_SendMessage(nil, text)
				end

				-- community reporter enabled?
				if (CommFlare.db.profile.communityReporter == true) then
					-- send to community?
					CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
				end
			end
		end
	end
end

-- process queue stuff
local function CommunityFlare_ProcessQueues()
	-- hook stuff
	hooksecurefunc("AcceptBattlefieldPort", CommunityFlare_AcceptBattlefieldPort)
	PVPReadyDialog:HookScript("OnHide", CommunityFlare_PVPReadyDialog_OnHide)
end

-- reset battleground status
local function CommunityFlare_Reset_Battleground_Status()
	-- reset settings
	CommFlare.CF.MatchStartTime = 0

	-- reset maps
	CommFlare.CF.MapID = 0
	CommFlare.CF.ASH = {}
	CommFlare.CF.AV = {}
	CommFlare.CF.IOC = {}
	CommFlare.CF.WG = {}
	CommFlare.CF.MapInfo = {}
	CommFlare.CF.Reloaded = false
end

-- iniialize queue session
local function CommunityFlare_Initialize_Queue_Session()
	-- clear role chosen table
	CommFlare.CF.RoleChosen = {}

	-- not group leader?
	if (CommunityFlare_IsGroupLeader() ~= true) then
		-- finished
		return
	end

	-- get battleground types by name
	local mapName = GetLFGRoleUpdateBattlegroundInfo()
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

	-- is tracked pvp?
	if (isTracked == true) then
		-- Blizzard_PVPUI loaded?
		local loaded, finished = IsAddOnLoaded("Blizzard_PVPUI")
		if ((loaded == true) and (finished == true)) then
			-- uninvite players that are afk?
			local uninviteTimer = 0
			if (CommFlare.db.profile.uninvitePlayersAFK == "3") then
				uninviteTimer = 3
			elseif (CommFlare.db.profile.uninvitePlayersAFK == "4") then
				uninviteTimer = 4
			elseif (CommFlare.db.profile.uninvitePlayersAFK == "5") then
				uninviteTimer = 5
			elseif (CommFlare.db.profile.uninvitePlayersAFK == "6") then
				uninviteTimer = 6
			end

			-- uninvite enabled?
			if ((uninviteTimer >= 3) and (uninviteTimer <= 6)) then
				-- enable timer
				TimerAfter(uninviteTimer, function()
					local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

					-- not in progress?
					if (inProgress ~= true) then
						-- finished
						return
					end

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
						local unit = "party" .. i
						local player, realm = UnitName(unit)
						if (player and (player ~= "")) then
							-- check relationship
							local realmRelationship = UnitRealmRelationship(unit)
							if (realmRelationship == LE_REALM_RELATION_SAME) then
								-- player with same realm
								player = player .. "-" .. GetRealmName()
							else
								-- player with different realm
								player = player .. "-" .. realm
							end

							-- role not chosen?
							if (not CommFlare.CF.RoleChosen[player] or (CommFlare.CF.RoleChosen[player] ~= true)) then
								-- ask to kick?
								CommunityFlare_PopupBox("CommunityFlare_Kick_Dialog", player)
							end
						end
					end
				end)
			end
		end
	end
end

-- look for players with 0 damage and 0 healing
local function CommunityFlare_Check_For_Inactive_Players()
	-- any battlefield scores?
	CommFlare.CF.NumScores = GetNumBattlefieldScores()
	if (CommFlare.CF.NumScores == 0) then
		-- finished
		return
	end

	-- has match started yet?
	if (PvPGetActiveMatchDuration() > 0) then
		-- calculate time elapsed
		CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
		CommFlare.CF.Timer.Seconds = math.floor(CommFlare.CF.Timer.MilliSeconds / 1000)
		CommFlare.CF.Timer.Minutes = math.floor(CommFlare.CF.Timer.Seconds / 60)
		CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)

		-- process all scores
		for i=1, CommFlare.CF.NumScores do
			CommFlare.CF.ScoreInfo = PvPGetScoreInfo(i)
			if (CommFlare.CF.ScoreInfo and CommFlare.CF.ScoreInfo.name) then
				-- damage and healing done found?
				if ((CommFlare.CF.ScoreInfo.damageDone ~= nil) and (CommFlare.CF.ScoreInfo.healingDone ~= nil)) then
					-- both equal zero?
					if ((CommFlare.CF.ScoreInfo.damageDone == 0) and (CommFlare.CF.ScoreInfo.healingDone == 0)) then
						-- display
						print(strformat("%s: AFK after %d minutes, %d seconds?", CommFlare.CF.ScoreInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds))
					end
				end
			end
		end
	end
end

-- update battleground status
local function CommunityFlare_Update_Battleground_Status()
	-- get MapID
	CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (not CommFlare.CF.MapID) then
		-- failed
		return false
	end

	-- get map info
	CommFlare.CF.MapInfo = MapGetMapInfo(CommFlare.CF.MapID)
	if (not CommFlare.CF.MapInfo) then
		-- failed
		return false
	end

	-- alterac valley or korrak's revenge?
	if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
		-- initialize
		CommFlare.CF.AV = {}
		CommFlare.CF.AV.Counts = { Bunkers = 4, Towers = 4 }
		CommFlare.CF.AV.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- alterac valley?
		if (CommFlare.CF.MapID == 91) then
			-- initialize bunkers
			CommFlare.CF.AV.Bunkers = {
				[1] = { id = 1380, name = "IWB", status = "Up" },
				[2] = { id = 1352, name = "North", status = "Up" },
				[3] = { id = 1389, name = "SHB", status = "Up" },
				[4] = { id = 1355, name = "South", status = "Up" }
			}

			-- initialize towers
			CommFlare.CF.AV.Towers = {
				[1] = { id = 1362, name = "East", status = "Up" },
				[2] = { id = 1377, name = "IBT", status = "Up" },
				[3] = { id = 1405, name = "TP", status = "Up" },
				[4] = { id = 1528, name = "West", status = "Up" }
			}
		else
			-- initialize bunkers
			CommFlare.CF.AV.Bunkers = {
				[1] = { id = 6445, name = "IWB", status = "Up" },
				[2] = { id = 6422, name = "North", status = "Up" },
				[3] = { id = 6453, name = "SHB", status = "Up" },
				[4] = { id = 6425, name = "South", status = "Up" }
			}

			-- initialize towers
			CommFlare.CF.AV.Towers = {
				[1] = { id = 6430, name = "East", status = "Up" },
				[2] = { id = 6442, name = "IBT", status = "Up" },
				[3] = { id = 6465, name = "TP", status = "Up" },
				[4] = { id = 6469, name = "West", status = "Up" }
			}
		end

		-- process bunkers
		for i,v in ipairs(CommFlare.CF.AV.Bunkers) do
			CommFlare.CF.AV.Bunkers[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.AV.Bunkers[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.AV.Bunkers[i].status = "Destroyed"
				CommFlare.CF.AV.Counts.Bunkers = CommFlare.CF.AV.Counts.Bunkers - 1
			end
		end

		-- process towers
		for i,v in ipairs(CommFlare.CF.AV.Towers) do
			CommFlare.CF.AV.Towers[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.AV.Towers[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.AV.Towers[i].status = "Destroyed"
				CommFlare.CF.AV.Counts.Towers = CommFlare.CF.AV.Counts.Towers - 1
			end
		end

		-- 1684 = widgetID for Score Remaining
		CommFlare.CF.ScoreInfo = GetDoubleStatusBarWidgetVisualizationInfo(1684)
		if (CommFlare.CF.ScoreInfo) then
			-- set proper scores
			CommFlare.CF.AV.Scores = { Alliance = CommFlare.CF.ScoreInfo.leftBarValue, Horde = CommFlare.CF.ScoreInfo.rightBarValue }
		end

		-- success
		return true
	-- isle of conquest?
	elseif (CommFlare.CF.MapID == 169) then
		-- initialize settings
		CommFlare.CF.IOC = {}
		CommFlare.CF.IOC.Counts = { Alliance = 0, Horde = 0 }
		CommFlare.CF.IOC.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- initialize alliance gates
		CommFlare.CF.IOC.AllianceGates = {
			[1] = { id = 2378, name = "East", status = "Up" },
			[2] = { id = 2379, name = "Front", status = "Up" },
			[3] = { id = 2381, name = "West", status = "Up" }
		}

		-- initialize horde gates
		CommFlare.CF.IOC.HordeGates = {
			[1] = { id = 2374, name = "East", status = "Up" },
			[2] = { id = 2372, name = "Front", status = "Up" },
			[3] = { id = 2376, name = "West", status = "Up" }
		}

		-- process alliance gates
		for i,v in ipairs(CommFlare.CF.IOC.AllianceGates) do
			CommFlare.CF.IOC.AllianceGates[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.IOC.AllianceGates[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.IOC.AllianceGates[i].status = "Destroyed"
				CommFlare.CF.IOC.Counts.Alliance = CommFlare.CF.IOC.Counts.Alliance + 1
			end
		end

		-- process horde gates
		for i,v in ipairs(CommFlare.CF.IOC.HordeGates) do
			CommFlare.CF.IOC.HordeGates[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.IOC.HordeGates[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.IOC.HordeGates[i].status = "Destroyed"
				CommFlare.CF.IOC.Counts.Horde = CommFlare.CF.IOC.Counts.Horde + 1
			end
		end

		-- 1685 = widgetID for Score Remaining
		CommFlare.CF.ScoreInfo = GetDoubleStatusBarWidgetVisualizationInfo(1685)
		if (CommFlare.CF.ScoreInfo) then
			-- set proper scores
			CommFlare.CF.IOC.Scores = { Alliance = CommFlare.CF.ScoreInfo.leftBarValue, Horde = CommFlare.CF.ScoreInfo.rightBarValue }
		end

		-- success
		return true
	-- battle for wintergrasp?
	elseif (CommFlare.CF.MapID == 1334) then
		-- initialize
		CommFlare.CF.WG = {}
		CommFlare.CF.WG.Counts = { Towers = 0 }
		CommFlare.CF.WG.TimeRemaining = "Just entered match. Gates not opened yet!"

		-- initialize towers
		CommFlare.CF.WG.Towers = {
			[1] = { id = 6066, name = "East", status = "Up" },
			[2] = { id = 6065, name = "South", status = "Up" },
			[3] = { id = 6067, name = "West", status = "Up" }
		}

		-- process towers
		for i,v in ipairs(CommFlare.CF.WG.Towers) do
			CommFlare.CF.WG.Towers[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.WG.Towers[i].id)
			if (CommFlare.CF.POIInfo and (CommFlare.CF.POIInfo.textureIndex == 51)) then
				CommFlare.CF.WG.Towers[i].status = "Destroyed"
				CommFlare.CF.WG.Counts.Towers = CommFlare.CF.WG.Counts.Towers + 1
			end
		end

		-- match not started yet?
		if (CommFlare.CF.MatchStatus ~= 1) then
			-- 1612 = widgetID for Time Remaining
			CommFlare.CF.ScoreInfo = GetIconAndTextWidgetVisualizationInfo(1612)
			if (CommFlare.CF.ScoreInfo) then
				-- set proper time
				CommFlare.CF.WG.TimeRemaining = CommFlare.CF.ScoreInfo.text
			end
		end

		-- success
		return true
	-- ashran?
	elseif (CommFlare.CF.MapID == 1478) then
		-- initialize
		if (not CommFlare.CF.ASH) then
			CommFlare.CF.ASH = { Jeron = "Up", Rylal = "Up" }
		end
		CommFlare.CF.ASH.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- reloaded?
		if (CommFlare.CF.Reloaded == true) then
			-- match maybe reloaded, use saved session
			CommFlare.CF.ASH.Jeron = CommFlare.db.profile.ASH.Jeron
			CommFlare.CF.ASH.Rylai = CommFlare.db.profile.ASH.Rylai
		end

		-- 1997 = widgetID for Score Remaining
		CommFlare.CF.ScoreInfo = GetDoubleStatusBarWidgetVisualizationInfo(1997)
		if (CommFlare.CF.ScoreInfo) then
			-- set proper scores
			CommFlare.CF.ASH.Scores = { Alliance = CommFlare.CF.ScoreInfo.leftBarValue, Horde = CommFlare.CF.ScoreInfo.rightBarValue }
		end

		-- success
		return true
	end

	-- not epic battleground
	return false
end

-- get current status
local function CommunityFlare_Get_Current_Status()
	-- update battleground status
	if (CommunityFlare_Update_Battleground_Status() == false) then
		-- do nothing
		return
	end

	-- check for epic battleground
	if (CommFlare.CF.MapID) then
		-- get map info
		print("MapID: ", CommFlare.CF.MapID)
		CommFlare.CF.MapInfo = MapGetMapInfo(CommFlare.CF.MapID)
		if (CommFlare.CF.MapInfo and CommFlare.CF.MapInfo.name) then
			-- alterac valley or korrak's revenge?
			if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
				-- display alterac valley status
				print(strformat("%s: Alliance = %s; Horde = %s; Bunkers Left = %d/4; Towers Left = %d/4", CommFlare.CF.MapInfo.name, CommFlare.CF.AV.Scores.Alliance, CommFlare.CF.AV.Scores.Horde, CommFlare.CF.AV.Counts.Bunkers, CommFlare.CF.AV.Counts.Towers))
			-- isle of conquest?
			elseif (CommFlare.CF.MapID == 169) then
				-- display isle of conquest status
				print(strformat("%s: Alliance = %s; Gates Destroyed: %d/3; Horde = %s; Gates Destroyed: %d/3", CommFlare.CF.MapInfo.name, CommFlare.CF.IOC.Scores.Alliance, CommFlare.CF.IOC.Counts.Alliance, CommFlare.CF.IOC.Scores.Horde, CommFlare.CF.IOC.Counts.Horde))
			-- battle for wintergrasp?
			elseif (CommFlare.CF.MapID == 1334) then
				-- display wintergrasp status
				print(strformat("%s: %s; Towers Destroyed: %d/3", CommFlare.CF.MapInfo.name, CommFlare.CF.WG.TimeRemaining, CommFlare.CF.WG.Counts.Towers))
			-- ashran?
			elseif (CommFlare.CF.MapID == 1478) then
				-- display ashran status
				print(strformat("%s: Alliance = %s; Horde = %s; Jeron = %s; Rylai = %s", CommFlare.CF.MapInfo.name, CommFlare.CF.ASH.Scores.Alliance, CommFlare.CF.ASH.Scores.Horde, CommFlare.CF.ASH.Jeron, CommFlare.CF.ASH.Rylai))
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
				CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
				CommFlare.CF.Timer.Seconds = math.floor(CommFlare.CF.Timer.MilliSeconds / 1000)
				CommFlare.CF.Timer.Minutes = math.floor(CommFlare.CF.Timer.Seconds / 60)
				CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)

				-- alterac valley or korrak's revenge?
				if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
					-- reply to sender with alterac valley status
					CommunityFlare_SendMessage(sender, strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Horde = %s; Bunkers Left = %d/4; Towers Left = %d/4; %d SAS Members", CommFlare.CF.MapInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.AV.Scores.Alliance, CommFlare.CF.AV.Scores.Horde, CommFlare.CF.AV.Counts.Bunkers, CommFlare.CF.AV.Counts.Towers, CommFlare.CF.CommCount))
				-- isle of conquest?
				elseif (CommFlare.CF.MapID == 169) then
					-- reply to sender with isle of conquest status
					CommunityFlare_SendMessage(sender, strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Gates Destroyed: %d/3; Horde = %s; Gates Destroyed: %d/3; %d SAS Members", CommFlare.CF.MapInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.IOC.Scores.Alliance, CommFlare.CF.IOC.Counts.Alliance, CommFlare.CF.IOC.Scores.Horde, CommFlare.CF.IOC.Counts.Horde, CommFlare.CF.CommCount))
				-- battle for wintergrasp?
				elseif (CommFlare.CF.MapID == 1334) then
					-- reply to sender with wintergrasp status
					CommunityFlare_SendMessage(sender, strformat("%s: %s; Time Elapsed = %d minutes, %d seconds; Towers Destroyed: %d/3; %d SAS Members", CommFlare.CF.MapInfo.name, CommFlare.CF.WG.TimeRemaining, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.WG.Counts.Towers, CommFlare.CF.CommCount))
				-- ashran?
				elseif (CommFlare.CF.MapID == 1478) then
					-- reply to sender with ashran status
					CommunityFlare_SendMessage(sender, strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Horde = %s; Jeron = %s; Rylai = %s; %d SAS Members", CommFlare.CF.MapInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.ASH.Scores.Alliance, CommFlare.CF.ASH.Scores.Horde, CommFlare.CF.ASH.Jeron, CommFlare.CF.ASH.Rylai, CommFlare.CF.CommCount))
				end
			else
				-- reply to sender with map name, gates not opened yet
				CommunityFlare_SendMessage(sender, strformat("%s: Just entered match. Gates not opened yet! (%d SAS Members.)", CommFlare.CF.MapInfo.name, CommFlare.CF.CommCount))
			end
		else
			-- reply to sender, not epic battleground
			CommunityFlare_SendMessage(sender, strformat("%s: Not an Epic Battleground to track.", CommFlare.CF.MapInfo.name))
		end

		-- add to table for later
		CommFlare.CF.StatusCheck[sender] = time()
	else
		-- check for queued battleground
		local timer = 0.0
		local reported = false
		CommFlare.CF.Leader = CommunityFlare_GetPartyLeader()
		for i=1, GetMaxBattlefieldID() do
			-- get battleground types by name
			local status, mapName = GetBattlefieldStatus(i)
			local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

			-- queued?
			if (status == "queued") then
				-- is tracked pvp?
				if (isTracked == true) then
					-- reported
					reported = true

					-- send replies staggered
					TimerAfter(timer, function()
						-- report Time been in queue
						CommFlare.CF.Timer.MilliSeconds = GetBattlefieldTimeWaited(i)
						CommFlare.CF.Timer.Seconds = math.floor(CommFlare.CF.Timer.MilliSeconds / 1000)
						CommFlare.CF.Timer.Minutes = math.floor(CommFlare.CF.Timer.Seconds / 60)
						CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)
						CommunityFlare_SendMessage(sender, strformat("%s has been queued for %d minutes and %d seconds for %s.", CommFlare.CF.Leader, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, mapName))
					end)

					-- next
					timer = timer + 0.2
				end
			end
		end

		-- not reported?
		if (reported == false) then
			-- send message
			CommunityFlare_SendMessage(sender, "Not currently in an Epic Battleground or queue!")
		end
	end
end

-- report joined with estimated time
local function CommunityFlare_Report_Joined_With_Estimated_Time()
	-- clear role chosen table
	CommFlare.CF.RoleChosen = {}

	-- check if currently in queue
	for i=1, GetMaxBattlefieldID() do
		-- get battleground types by name
		local status, mapName = GetBattlefieldStatus(i)
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

		-- is tracked pvp?
		if (isTracked == true) then
			-- get estimated time
			CommFlare.CF.Timer.MilliSeconds = GetBattlefieldEstimatedWaitTime(i)
			if (CommFlare.CF.Timer.MilliSeconds > 0) then
				-- calculate minutes / seconds
				CommFlare.CF.Timer.Seconds = math.floor(CommFlare.CF.Timer.MilliSeconds / 1000)
				CommFlare.CF.Timer.Minutes = math.floor(CommFlare.CF.Timer.Seconds / 60)
				CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)

				-- does the player have the mercenary buff?
				local text = CommunityFlare_GetGroupCount()
				CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
				if (CommFlare.CF.HasAura == true) then
					-- build text for mercenary queue
					CommFlare.CF.Queues[i].mercenary = true
					text = text .. " Joined Mercenary Queue for " .. mapName .. "! Estimated Wait: " .. CommFlare.CF.Timer.Minutes .. " minutes, " .. CommFlare.CF.Timer.Seconds .. " seconds!"
				else
					-- build text for normal epic battleground queue
					CommFlare.CF.Queues[i].mercenary = false
					text = text .. " Joined Queue for " .. mapName .. "! Estimated Wait: " .. CommFlare.CF.Timer.Minutes .. " minutes, " .. CommFlare.CF.Timer.Seconds .. " seconds!"
				end

				-- check if group has room for more
				if (CommFlare.CF.Count < 5) then
					-- community auto invite enabled?
					if (CommFlare.db.profile.communityAutoInvite == true) then
						-- update text
						text = text .. " (For auto invite, whisper me INV)"
					end
				end

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
					-- send to community?
					CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
				end
			else
				-- try again
				TimerAfter(0.2, CommunityFlare_Report_Joined_With_Estimated_Time)
				return
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
			CommunityFlare_SendMessage(nil, strformat("%s: %s", CommunityFlare_Title, CommunityFlare_Version))
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
	elseif (input == "inactive") then
		-- check for inactive players
		CommunityFlare_Check_For_Inactive_Players()
	elseif (input == "refresh") then
		-- process club members
		CommunityFlare_Process_Club_Members()
	elseif (input == "reset") then
		-- reset members database
		CommFlare.db.global.members = {}
		print("Cleared members database!")
	elseif (input == "sasid") then
		-- get proper sas community id
		CommFlare.db.profile.SASID = CommunityFlare_FindClubID(CommFlare.CF.MainCommName)
		CommFlare.db.profile.SAS_ALTS_ID = CommunityFlare_FindClubID(CommFlare.CF.AltsCommName)
		print("SASID: ", CommFlare.db.profile.SASID)
		print("SAS_ALTS_ID: ", CommFlare.db.profile.SAS_ALTS_ID)
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

-- process addon loaded
function CommFlare:ADDON_LOADED(msg, ...)
	local addOnName = ...

	-- Blizzard_PVPUI?
	if (addOnName == "Blizzard_PVPUI") then
		-- hook queue button mouse over
		HonorFrameQueueButton:HookScript("OnEnter", CommunityFlare_HonorFrameQueueButton_OnEnter)
	end
end

-- process chat battle net whisper
function CommFlare:CHAT_MSG_BN_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- version check?
	text = strlower(text)
	if (text == "!cf") then
		-- send community flare version number
		CommunityFlare_SendMessage(bnSenderID, strformat("%s: %s", CommunityFlare_Title, CommunityFlare_Version))
	-- status check?
	elseif (text == "!status") then
		-- process status check
		CommunityFlare_Process_Status_Check(bnSenderID)
	-- asking for invite?
	elseif ((text == "inv") or (text == "invite")) then
		-- battle net auto invite enabled?
		if (CommFlare.db.profile.bnetAutoInvite == true) then
			if (CommunityFlare_IsInBattleground() == true) then
				CommunityFlare_SendMessage(bnSenderID, "Sorry, currently in a Battleground now.")
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
								CommunityFlare_SendMessage(bnSenderID, "Sorry, group is currently full.")
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

	-- someone has joined the battleground?
	text = strlower(text)
	if (text:find("has joined the instance group")) then
		-- community auto promote leader enabled?
		if (CommFlare.db.profile.communityAutoPromoteLeader == true) then
			-- not sas leader?
			local player = CommunityFlare_GetPlayerName("full")
			if (CommunityFlare_IsSASLeader(player) == false) then
				-- do you have lead?
				CommFlare.CF.PlayerRank = CommunityFlare_GetRaidRank(UnitName("player"))
				if (CommFlare.CF.PlayerRank == 2) then
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
	-- notify system has been enabled?
	elseif (text:find("notify system has been enabled")) then
		-- use full list for meso
		local type = "short"
		local player = CommunityFlare_GetPlayerName("full")
		if (CommunityFlare_IsMesostealthy(player)) then
			type = "full"
		end

		-- display battleground setup
		CommFlare.CF.MatchStatus = 2
		CommFlare.CF.MatchStartTime = time()
		CommunityFlare_Battleground_Setup(type)
	end
end

-- process chat whisper message
function CommFlare:CHAT_MSG_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, guid, bnSenderID = ...

	-- version check?
	text = strlower(text)
	if (text == "!cf") then
		-- send community flare version number
		CommunityFlare_SendMessage(sender, strformat("%s: %s", CommunityFlare_Title, CommunityFlare_Version))
	-- pass leadership?
	elseif (text == "!pl") then
		-- not sas leader?
		local player = CommunityFlare_GetPlayerName("full")
		if (CommunityFlare_IsSASLeader(player) == false) then
			-- do you have lead?
			CommFlare.CF.PlayerRank = CommunityFlare_GetRaidRank(UnitName("player"))
			if (CommFlare.CF.PlayerRank == 2) then
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
				CommunityFlare_SendMessage(sender, "Sorry, currently in a Battleground now.")
			else
				-- is sender an SAS member?
				CommFlare.CF.AutoInvite = CommunityFlare_IsSASMember(sender)
				if (CommFlare.CF.AutoInvite == true) then
					-- group is full?
					if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
						CommunityFlare_SendMessage(sender, "Sorry, group is currently full.")
					else
						PartyInfoInviteUnit(sender)
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

	-- sas community?
	if (CommFlare.db.profile.SASID == clubId) then
		-- get member info
		CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)
		if (CommFlare.CF.MemberInfo ~= nil) then
			-- name not found?
			if (not CommFlare.CF.MemberInfo.name) then
				-- try again, 2 seconds later
				TimerAfter(2, function()
					-- get member info
					CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)

					-- name not found?
					if ((CommFlare.CF.MemberInfo ~= nil) and (CommFlare.CF.MemberInfo.name ~= nil)) then
						-- display
						print(strformat("SAS Member Added: %s (%d, %d)", CommFlare.CF.MemberInfo.name, clubId, memberId))

						-- add to members
						CommunityFlare_AddMember(clubId, CommFlare.CF.MemberInfo)
					end
				end)
			else
				-- display
				print(strformat("SAS Member Added: %s (%d, %d)", CommFlare.CF.MemberInfo.name, clubId, memberId))

				-- add to members
				CommunityFlare_AddMember(clubId, CommFlare.CF.MemberInfo)
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
		CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)
		if (CommFlare.CF.MemberInfo ~= nil) then
			-- found member name?
			if (CommFlare.CF.MemberInfo.name ~= nil) then
				-- display
				print(strformat("SAS Member Removed: %s (%d, %d)", CommFlare.CF.MemberInfo.name, clubId, memberId))
			end
		end
	end
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
								CommunityFlare_SendMessage(accountInfo.bnetAccountID, "Sorry, group is currently full.")
							end
						else
							-- send message
							CommunityFlare_SendMessage(name, "Sorry, group is currently full.")
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
							-- is sender an SAS member?
							CommFlare.CF.AutoInvite = CommunityFlare_IsSASMember(player)
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

-- process group roster update
function CommFlare:GROUP_ROSTER_UPDATE(msg)
	-- not in raid and in group?
	if (not IsInRaid() and IsInGroup()) then
		-- are you group leader?
		if (CommunityFlare_IsGroupLeader() == true) then
			-- community reporter enabled?
			if (CommFlare.db.profile.communityReporter == true) then
				-- check current players in home party
				local count = 1
				local players = GetHomePartyInfo()
				if (players ~= nil) then
					-- has group size changed?
					local text = CommunityFlare_GetGroupCount()
					count = #players + count
					if ((CommFlare.CF.PreviousCount > 0) and (CommFlare.CF.PreviousCount < 5) and (count == 5)) then
						-- send to community?
						text = text .. " Full Now!"
						CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
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
	-- process club members after 5 seconds
	TimerAfter(5, CommunityFlare_Process_Club_Members)
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
	if (CommunityFlare_IsGroupLeader() == true) then
		-- is this your role?
		if (name == UnitName("player")) then
			-- initialize queue session
			CommunityFlare_Initialize_Queue_Session()
		end
	end

	-- is battleground queue?
	if (bgQueue) then
		-- get battleground types by name
		local mapName = GetLFGRoleUpdateBattlegroundInfo()
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

		-- is tracked pvp?
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
		-- get battleground types by name
		local mapName = GetLFGRoleUpdateBattlegroundInfo()
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

		-- is tracked pvp?
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
						-- is party leader an SAS member?
						CommFlare.CF.AutoQueue = CommunityFlare_IsSASMember(CommunityFlare_GetPartyLeader())
					end
				end

				-- auto queue enabled?
				if (CommFlare.CF.AutoQueue == true) then
					-- check for deserter
					CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
					if (CommFlare.CF.HasAura == false) then
						-- is shown?
						if (LFDRoleCheckPopupAcceptButton:IsShown()) then
							-- click accept button
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
	if (CommFlare.CF.HasAura == false) then
		-- community auto invite enabled?
		if (CommFlare.db.profile.communityAutoInvite == true) then
			-- is sender an SAS member?
			CommFlare.CF.AutoInvite = CommunityFlare_IsSASMember(sender)
			if (CommFlare.CF.AutoInvite == true) then
				-- lfg invite popup shown?
				if (LFGInvitePopup:IsShown()) then
					-- click accept button
					LFGInvitePopupAcceptButton:Click()
				end
			end
		end
	else
		-- send whisper back that you have deserter
		CommunityFlare_SendMessage(sender, "Sorry, I currently have Deserter!")
		if (LFGInvitePopup:IsShown()) then
			-- click decline button
			LFGInvitePopupDeclineButton:Click()
		end
	end
end

-- process party leader changed
function CommFlare:PARTY_LEADER_CHANGED(msg)
	-- in a group?
	if (IsInGroup()) then
		-- not in a raid?
		if (not IsInRaid()) then
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
			CommFlare.db.profile.SASID = CommunityFlare_FindClubID(CommFlare.CF.MainCommName)
			CommFlare.db.profile.SAS_ALTS_ID = CommunityFlare_FindClubID(CommFlare.CF.AltsCommName)
		end)

		-- global created?
		if (not CommFlare.db.global) then
			CommFlare.db.global = {}
		end

		-- reloading?
		if (isReloadingUi) then
			-- reloaded
			CommFlare.CF.Reloaded = true

			-- load previous session
			CommunityFlare_LoadSession()

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

			-- process club members after 5 seconds
			TimerAfter(5, CommunityFlare_Process_Club_Members)
		end
	end
end

-- process player login
function CommFlare:PLAYER_LOGIN(msg)
	-- event hooks not enabled yet?
	if (CommFlare.CF.EventHandlerLoaded == false) then
		-- process queue stuff
		CommunityFlare_ProcessQueues()
		CommFlare.CF.EventHandlerLoaded = true
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
	CommunityFlare_Process_Club_Members()
end

-- process pvp match complete
function CommFlare:PVP_MATCH_COMPLETE(msg, ...)
	local winner, duration = ...

	-- update battleground status
	CommFlare.CF.MatchStatus = 3
	CommunityFlare_Update_Battleground_Status()

	-- report to anyone?
	if (CommFlare.CF.StatusCheck) then
		-- get winner / mercenary status
		CommFlare.CF.Winner = GetBattlefieldWinner()
		CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")

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
				text = text .. " (" .. CommFlare.CF.CommCount .. " SAS Members.)"
				CommunityFlare_SendMessage(k, text)
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
	CommunityFlare_Reset_Battleground_Status()
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
			-- currently in battleground?
			if (PvPIsBattleground() == true) then
				-- block all shared quests?
				local decline = false
				if (CommFlare.db.profile.blockSharedQuests == "3") then
					-- always decline
					decline = true
				-- block irrelevant quests?
				elseif (CommFlare.db.profile.blockSharedQuests == "2") then
					-- get MapID
					CommFlare.CF.MapID = MapGetBestMapForUnit("player")
					if (CommFlare.CF.MapID and (CommFlare.CF.MapID > 0)) then
						-- initialize
						decline = true
						local epicBG = false
						CommFlare.CF.QuestID = GetQuestID()

						-- alterac valley or korrak's revenge?
						if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
							-- list of allowed Alterac Valley quests
							local allowedQuests = {
								[56257] = true,
								[56259] = true,
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
							-- list of allowed Wintergrasp quests
							local allowedQuests = {
								[13178] = true,
								[13183] = true,
								[13185] = true,
								[13223] = true,
								[13539] = true,
								[55509] = true,
								[55511] = true,
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[CommFlare.CF.QuestID] and (allowedQuests[CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						-- ashran?
						elseif (CommFlare.CF.MapID == 1478) then
							-- list of allowed Wintergrasp quests
							local allowedQuests = {
								[56337] = true,
								[56339] = true,
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
							-- list of allowed weekly quests
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
	if (CommunityFlare_IsGroupLeader() == true) then
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
	CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
	if (CommFlare.CF.HasAura == true) then
		CommunityFlare_SendMessage(nil, "I currently have the Mercenary Contract BUFF! (Are we mercing?)")
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
			-- is sender an SAS member?
			CommFlare.CF.AutoQueue = CommunityFlare_IsSASMember(sender)
		end
	end

	-- auto queue enabled?
	if (CommFlare.CF.AutoQueue == true) then
		-- verify player does not have deserter debuff
		CommunityFlare_CheckForAura("player", "HARMFUL", "Deserter")
		if (CommFlare.CF.HasAura == false) then
			if (ReadyCheckFrame:IsShown()) then
				-- click yes button
				ReadyCheckFrameYesButton:Click()
			end

			-- ready
			CommFlare.CF.ReadyCheck["player"] = true
		else
			-- send back to party that you have deserter
			CommunityFlare_SendMessage(nil, "Sorry, I currently have Deserter!")
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
						if (CommunityFlare_IsGroupLeader() == true) then
							-- check if group has room for more
							local text = CommunityFlare_GetGroupCount() .. " Ready!"
							if (CommFlare.CF.Count < 5) then
								-- community auto invite enabled
								if (CommFlare.db.profile.communityAutoInvite == true) then
									-- update text
									text = text .. " (For auto invite, whisper me INV)"
								end
							end

							-- send to community?
							CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
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

-- process update battlefield status
function CommFlare:UPDATE_BATTLEFIELD_STATUS(msg, ...)
	local index = ...

	-- invalid index?
	if (not index or (index < 1) or (index > GetMaxBattlefieldID())) then
		-- finished
		return
	end

	-- get battleground types by name
	local status, mapName = GetBattlefieldStatus(index)
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = CommunityFlare_IsTrackedPVP(mapName)

	-- is tracked pvp?
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
						if (CommunityFlare_IsGroupLeader() == true) then
							-- report joined queue with estimated time
							CommunityFlare_Report_Joined_With_Estimated_Time()
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
						if (CommunityFlare_IsGroupLeader() == true) then
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
								local text = CommunityFlare_GetGroupCount()
								if (CommFlare.CF.Queues[index].mercenary == true) then
									text = text .. " Mercenary Queue Popped for " .. mapName .. "!"
								else
									text = text .. " Queue Popped for " .. mapName .. "!"
								end

								-- send to community?
								CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
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
	self:RegisterEvent("GROUP_INVITE_CONFIRMATION")
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
	self:UnregisterEvent("GROUP_INVITE_CONFIRMATION")
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
	self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- refresh config
function CommFlare:RefreshConfig()
	-- always verify SASID
	CommFlare.db.profile.SASID = 0
	CommFlare.CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(CommFlare.CF.Clubs) do
		if (v.name == CommFlare.CF.MainCommName) then
			CommFlare.db.profile.SASID = v.clubId
		elseif (v.name == CommFlare.CF.AltsCommName) then
			CommFlare.db.profile.SAS_ALTS_ID = v.clubId
		end
	end
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
